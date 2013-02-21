//
//  Database+WP.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+WP.h"
#import "Database+WPField.h"
#import "CSVParser.h"
#import "WastePoint.h"
#import "WPField.h"

#define kKeyId @"id"
#define kKeyLat @"lat"
#define kKeyLong @"lon"
#define kKeyPhotos @"photos"
#define kKeyNodes @"nr_of_nodes"
#define kKeyVolume @"volume"

@implementation Database (WP)

- (NSArray *)WPListFromData:(NSData *)csvData {
  
  NSString *csvString = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
  NSArray *parsedArray = [CSVParser parseCSVIntoArrayOfDictionariesFromString:csvString withSeparatedCharacterString:@"," quoteCharacterString:nil];
  
  MSLog(@"Parsed array count: %i", parsedArray.count);
  NSMutableArray *resultArray = [NSMutableArray array];
  
  // Find all API-defined fields and separate them from server specific fields.
  NSMutableArray *fieldArray = [NSMutableArray arrayWithArray:[parsedArray objectAtIndex:0]];
  NSMutableSet *serverFieldsSet = [NSMutableSet set];
  
  for (NSString *key in fieldArray) {
    WPField *field = [self findWPFieldWithFieldName:key orLabel:nil];
    if (field) {
      [serverFieldsSet addObject:key];
    }
  }
  
  for (int i = 1; i < [parsedArray count] - 1; i++) {
    NSMutableDictionary *oneElementDict = [NSMutableDictionary dictionary];
    NSArray *elementArray = [parsedArray objectAtIndex:i];
    for (int j = 0; j < [fieldArray count]; j++) {
      NSString *object = [elementArray objectAtIndex:j];
      NSString *key = [fieldArray objectAtIndex:j];
      
      [oneElementDict setObject:object forKey:key];
    }
    WastePoint *point = [self wastePointFromDictionary:oneElementDict];
    

  }
  
  
  return resultArray;
}


- (WastePoint *)wastePointFromDictionary:(NSDictionary *)inDict {
  NSString *wpId = [inDict objectForKey:kKeyId];
  NSString *wpLon = [inDict objectForKey:kKeyLong];
  NSString *wpLat = [inDict objectForKey:kKeyLat];
  NSString *photos = [inDict objectForKey:kKeyPhotos];
  
  WastePoint *point = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
  [point setIdValue:wpId.intValue];
  [point setLongitudeValue:wpLon.floatValue];
  [point setLatitudeValue:wpLat.floatValue];
  [point setPhotos:photos];

  return point;
}

@end
