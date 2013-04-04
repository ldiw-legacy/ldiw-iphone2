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

- (WastePoint *)wastepointWithId:(int)remoteId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %i", remoteId];
  WastePoint *result = [self findCoreDataObjectNamed:@"WastePoint" withPredicate:predicate];
  return result;
}

- (void)deleteAllDistances {
  NSArray *points = [self listAllWastePoints];
  for (WastePoint *point in points) {
    [point setDistanceValue:CGFLOAT_MAX];
  }
}

- (NSArray *)WPListFromData:(NSData *)csvData {
  NSString *csvString = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
  CSVParser *parser = [[CSVParser alloc] initWithString:csvString];
  NSArray *parsedArray = [parser arrayOfParsedRows];
  
  MSLog(@"Parsed %i objects", parsedArray.count);

  for (NSDictionary *elementDict in parsedArray) {
    [self createWastePointWithDictionary:elementDict];
  }
  
  [[Database sharedInstance] saveContext];
  return [self listWastepointsWithDistance];
}

- (void)createWastePointWithDictionary:(NSDictionary *)inDict {
  NSMutableDictionary *wpDict = [NSMutableDictionary dictionaryWithDictionary:inDict];
  
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
  
  WastePoint *point = [self wastepointWithId:wpId.intValue];
  
  if (!point) {
    point = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
    [point setIdValue:wpId.intValue];
    [point setLatitudeValue:[wpLat floatValue]];
    [point setLongitudeValue:[wpLon floatValue]];
  }
  
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
}

- (NSArray *)listWastePointsWithNoId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == 0"];
  return [self listCoreObjectsNamed:@"WastePoint" withPredicate:predicate];
}

- (NSArray *)listAllWastePoints {
  return [self listCoreObjectsNamed:@"WastePoint" withPredicate:nil];
}

- (NSArray *)listWastepointsWithDistance {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"distance < %f", CGFLOAT_MAX];
  NSArray *pointsArray = [self listCoreObjectsNamed:@"WastePoint" withPredicate:predicate];
  NSArray *sortedArray = [pointsArray sortedArrayUsingSelector:@selector(sortByDistance:)];
  return sortedArray;
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
