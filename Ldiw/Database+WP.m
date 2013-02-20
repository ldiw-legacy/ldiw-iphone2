//
//  Database+WP.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+WP.h"
#import "parseCSV.h"
#import "WastePoint.h"

#define kKeyGlass @"composition_glass"
#define kKeyLarge @"composition_Large"
#define kKeyOther @"composition_other"
#define kKeyPaper @"composition_paper"
#define kKeyPmp @"composition_pmp"
#define kKeyDescription @"description"
#define kKey


@implementation Database (WP)

- (NSArray *)WPListFromData:(NSData *)csvData {
  
  CSVParser *parser = [[CSVParser alloc] init];
  NSArray *parsedArray = [parser parseData:csvData];
  MSLog(@"Parsed array: %@", parsedArray);
  NSMutableArray *resultArray = [NSMutableArray array];
  
  NSArray *fieldArray = [parsedArray objectAtIndex:0];
  for (int i = 1; i < [parsedArray count] - 1; i++) {
    NSMutableDictionary *oneElementDict = [NSMutableDictionary dictionary];
    NSArray *elementArray = [parsedArray objectAtIndex:i];
    for (int j = 0; j < [fieldArray count]; j++) {
      NSString *object = [elementArray objectAtIndex:j];
      NSString *key = [fieldArray objectAtIndex:j];
      [oneElementDict setObject:object forKey:key];
    }
    
    
    [resultArray addObject:oneElementDict];
  }
  
  
  return resultArray;
}

- (WastePoint *)wastePointFromDictionary:(NSDictionary *)inDict {
  WastePoint *wastePoint = [WastePoint insertInManagedObjectContext:self.managedObjectContext];
  // id, lat, long, description
//  "composition_glass" = "12463.23883";
//  "composition_large" = "31609.1141";
//  "composition_other" = "61793.91432";
//  "composition_paper" = "24411.18699";
//  "composition_pmp" = "96134.29363";
//  description = "";
//  "geo_areas_json" = "";
//  id = "c3_3";
//  lat = "3722.89050685";
//  lon = "6034.882686817";
//  "nr_of_nodes" = 3105;
//  "nr_of_tires" = 14666;
//  photos = "";
//  volume = "115633.87059";

//  NSString *compGlass = inDict
  
}

@end
