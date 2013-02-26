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

#define kKeyId @"id"
#define kKeyLat @"lat"
#define kKeyLon @"lon"
#define kKeyPhotos @"photos"

@implementation Database (WP)

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
  }
  
  for (NSString *key in [wpDict allKeys]) {
    NSString *value = [wpDict objectForKey:key];
    CustomValue *valueToAdd = [self addCustomValueWithKey:key andValue:value];
    [point addCustomValueObject:valueToAdd];
  }
  return point;
}

- (CustomValue *)addCustomValueWithKey:(NSString *)key andValue:(NSString *)value {
  CustomValue *aValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setFieldName:key];
  [aValue setValue:value];
  return aValue;
}

@end
