//
//  Database+WP.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+WP.h"
#import "CSVParser.h"
#import "CustomValue.h"
#import "PictureHelper.h"
#import "Database+Image.h"
#import "Database+User.h"

@implementation Database (WP)

- (WastePoint *)addWastePointUsingImage:(UIImage *)image {
  WastePoint *wp = [WastePoint insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  if (image) {
    [PictureHelper saveImage:image forWastePoint:wp];
  }
  MSLog(@"Added waste point %@", wp);
  return wp;
}

- (WastePoint *)wastepointWithId:(NSString *)remoteId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@ && viewType == %d", remoteId, ViewTypeList];
  WastePoint *result = [self findCoreDataObjectNamed:@"WastePoint" withPredicate:predicate];
  return result;
}

- (void)deletePointsForViewType:(ViewType)viewType {
  NSArray *points = [self listWastepointsWithViewType:viewType];
  for (WastePoint *point in points) {
    [[[Database sharedInstance] managedObjectContext] deleteObject:point];
  }
  
  [[Database sharedInstance] saveContext];
}

- (NSArray *)listWastepointsWithViewType:(ViewType)viewType {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"viewType == %d", viewType];
  NSArray *pointsArray = [self listCoreObjectsNamed:@"WastePoint" withPredicate:predicate];
  NSArray *sortedArray = [pointsArray sortedArrayUsingSelector:@selector(sortByDistance:)];
  return sortedArray;
}

- (NSArray *)WPListFromData:(NSData *)csvData forViewType:(ViewType)viewType {
  [self deletePointsForViewType:viewType];
  NSString *csvString = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
  CSVParser *parser = [[CSVParser alloc] initWithString:csvString];
  NSArray *parsedArray = [parser arrayOfParsedRows];
  
  MSLog(@"Parsed %i objects", parsedArray.count);

  for (NSDictionary *elementDict in parsedArray) {
    [self createWastePointWithDictionary:elementDict forViewType:viewType];
  }

  [[Database sharedInstance] saveContext];
  return [self listWastepointsWithViewType:viewType];
}

- (void)createWastePointWithDictionary:(NSDictionary *)inDict forViewType:(ViewType)viewType {
  NSMutableDictionary *wpDict = [NSMutableDictionary dictionaryWithDictionary:inDict];
  MSLog(@"Create wp with dict: %@", inDict);
  NSString *wpId = [wpDict objectForKey:kKeyId];
  [wpDict removeObjectForKey:kKeyId];
  NSString *wpLat = [wpDict objectForKey:kKeyLat];
  [wpDict removeObjectForKey:kKeyLat];
  NSString *wpLon = [wpDict objectForKey:kKeyLon];
  [wpDict removeObjectForKey:kKeyLon];
  NSString *wpPhotos = [wpDict objectForKey:kKeyPhotos];
  [wpDict removeObjectForKey:kKeyPhotos];
  NSString *distanceString = [wpDict objectForKey:@"distance_meters"];
  [wpDict removeObjectForKey:@"distance_meters"];
  
  WastePoint *point = nil;
  if (viewType == ViewTypeNewPoint) {
    point = [[Database sharedInstance] wastepointWithId:wpId];
    if (!point) {
      point = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
    }
    viewType = ViewTypeList;
  } else {
    point = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
  }
  
  [point setId:wpId];
  [point setViewTypeValue:viewType];
  [point setLatitudeValue:[wpLat floatValue]];
  [point setLongitudeValue:[wpLon floatValue]];

  NSInteger nrOfNodes = [[wpDict objectForKey:@"nr_of_nodes"] integerValue];
  [wpDict removeObjectForKey:@"nr_of_nodes"];
  
  if (viewType == ViewTypeList) {
    [point setDistanceValue:[distanceString floatValue]];
    
    // Create correct image objects
    if ([wpPhotos length] > 0) {
      point.images = nil;
      NSRange photoNameRange = [wpPhotos rangeOfString:@":"];
      NSString *photoname = [wpPhotos substringToIndex:photoNameRange.location];
      Image *newImage = [self imageWithRemoteUrl:photoname];
      if (![point.images containsObject:newImage]) {
        [point addImagesObject:newImage];
      }
    }
    
    [point setCustomValues:nil];
    for (NSString *key in [wpDict allKeys]) {
      NSString *value = [wpDict objectForKey:key];
      CustomValue *valueToAdd = [self addCustomValueWithKey:key andValue:value];
      if (valueToAdd) {
        [point addCustomValuesObject:valueToAdd];
      }
    }
  } else if (viewType == ViewTypeLargeMap || viewType == ViewTypeSmallMap){
    [point setNrOfNodesValue:nrOfNodes];
  }
}

- (NSArray *)listWastePointsWithNoId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == nil"];
  return [self listCoreObjectsNamed:@"WastePoint" withPredicate:predicate];
}

- (CustomValue *)addCustomValueWithKey:(NSString *)key andValue:(NSString *)value {
  if ([value isKindOfClass:[NSString class]]) {
    CustomValue *aValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
    [aValue setFieldName:key];
    [aValue setValue:value];
    return aValue;
  } else {
    return nil;
  }
}

- (CustomValue *)customValueWithKey:(NSString *)key andValue:(NSString *)newValue {
  CustomValue *aValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setValue:newValue];
  [aValue setFieldName:key];
  return aValue;
}

@end
