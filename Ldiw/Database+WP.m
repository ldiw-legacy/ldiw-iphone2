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

#define kKeyId @"id"
#define kKeyLat @"lat"
#define kKeyLon @"lon"
#define kKeyPhotos @"photos"

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
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", remoteId];
  WastePoint *result = [self findCoreDataObjectNamed:@"WastePoint" withPredicate:predicate];
  return result;
}

- (NSArray *)WPListFromData:(NSData *)csvData {
  
  NSString *csvString = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
  CSVParser *parser = [[CSVParser alloc] initWithString:csvString];
  NSArray *parsedArray = [parser arrayOfParsedRows];
  
  MSLog(@"Parsed %i objects", parsedArray.count);
  NSMutableArray *resultArray = [NSMutableArray array];
  
  for (NSDictionary *elementDict in parsedArray) {
    WastePoint *point = [self wastePointFromDictionary:elementDict];
    [resultArray addObject:point];
  }
  
  return resultArray;
}

- (WastePoint *)wastePointFromDictionary:(NSDictionary *)inDict {
  NSMutableDictionary *wpDict = [NSMutableDictionary dictionaryWithDictionary:inDict];
  
  NSString *wpId = [wpDict objectForKey:kKeyId];
  [wpDict removeObjectForKey:kKeyId];
  NSString *wpLat = [wpDict objectForKey:kKeyLat];
  [wpDict removeObjectForKey:kKeyLat];
  NSString *wpLon = [wpDict objectForKey:kKeyLon];
  [wpDict removeObjectForKey:kKeyLon];
  NSString *wpPhotos = [wpDict objectForKey:kKeyPhotos];
  [wpDict removeObjectForKey:kKeyPhotos];
  
  WastePoint *point = [self wastepointWithId:wpId];
  if (!point) {
    point = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
    [point setIdValue:wpId.intValue];
    [point setLatitudeValue:[wpLat floatValue]];
    [point setLongitudeValue:[wpLon floatValue]];
    [point setPhotos:wpPhotos];
    
    for (NSString *key in [wpDict allKeys]) {
      NSString *value = [wpDict objectForKey:key];
      CustomValue *valueToAdd = [self addCustomValueWithKey:key andValue:value];
      [point addCustomValuesObject:valueToAdd];
    }
  }
  return point;
}

- (NSArray *)listWastePointsWithNoId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == 0"];
  return [self listCoreObjectsNamed:@"WastePoint" withPredicate:predicate];
}

- (CustomValue *)addCustomValueWithKey:(NSString *)key andValue:(NSString *)value {
  CustomValue *aValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setFieldName:key];
  [aValue setValue:value];
  return aValue;
}

- (CustomValue *)customValueWithKey:(NSString *)key andValue:(NSString *)newValue {
  
  CustomValue *aValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setValue:newValue];
  [aValue setFieldName:key];
  return aValue;
}

@end
