//
//  WastepointRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastepointRequest.h"
#import "Database+Server.h"
#import "AFHTTPRequestOperation.h"
#import "parseCSV.h"

#define kGetWPListPath @"waste_points.csv"

#define kMaxResultsKey @"max_results" //default 10
#define kNearestPointToKey @"nearest_points_to" //optional coordinates (lon,lat in WGS84): "-74,30". If set, then returns individual WPs (not clusters) nearest to the coordinates given, and also adds a distance_meters field to results.
#define kBBoxKey @"BBOX" // optional

@implementation WastepointRequest

+ (void)getWPList:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  //  URL: GET/POST <api_base_url>/waste_points.{json,csv,kml}
  // ONLY CSV is supported
  
  NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
  [parametersDict setValue:[NSNumber numberWithInt:100] forKey:kMaxResultsKey];
  NSString *baseUrlString = [[Database sharedInstance] serverBaseUrl];
  NSString *baseUrlSuffix = [[Database sharedInstance] serverSuffix];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", baseUrlString, baseUrlSuffix,kGetWPListPath]];
  MSLog(@"Get WP list from: %@", url);
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSData *responseData = (NSData *)responseObject;
    
    //    NSString *csvString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
    CSVParser *parser = [[CSVParser alloc] init];
    NSArray *parsedArray = [parser parseData:responseData];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSArray *fieldArray = [parsedArray objectAtIndex:0];
    for (int i = 1; i < [parsedArray count] - 1; i++) {
      NSMutableDictionary *oneElementDict = [NSMutableDictionary dictionary];
      NSArray *elementArray = [parsedArray objectAtIndex:i];
      for (int j = 0; j < [fieldArray count]; j++) {
        [oneElementDict setObject:[elementArray objectAtIndex:j] forKey:[fieldArray objectAtIndex:j]];
      }
      [resultArray addObject:oneElementDict];
    }
    
    success(resultArray);
    
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Things go boom. %@", [error localizedDescription]);
    failure(error);
  }];
  [operation start];
}

@end
