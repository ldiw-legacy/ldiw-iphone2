//
//  WastepointRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastepointRequest.h"
#import "Database+Server.h"
#import "Database+WP.h"
#import "AFHTTPRequestOperation.h"
#import "LocationManager.h"

#define kGetWPListPath @"waste_points.csv"

#define kMaxResultsKey @"max_results" //default 10
#define kNearestPointToKey @"nearest_points_to" //optional coordinates (lon,lat in WGS84): "-74,30". If set, then returns individual WPs (not clusters) nearest to the coordinates given, and also adds a distance_meters field to results.
#define kBBoxKey @"BBOX" // optional

@implementation WastepointRequest

+ (void)getWPList:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  //  URL: GET/POST <api_base_url>/waste_points.{json,csv,kml}
  // ONLY CSV is supported
  
  MSLog(@"Start ListWP request");
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    MSLog(@"Got location");
    NSString *latitude = [NSString stringWithFormat:@"%g", location.coordinate.latitude];
    NSString *longtitude = [NSString stringWithFormat:@"%g", location.coordinate.longitude];
    NSString *locationString = [NSString stringWithFormat:@"%@,%@", latitude, longtitude];
    NSString *serverBBox = [[Database sharedInstance] bBox];
    
// http://api.letsdoitworld.org/?q=api/waste_points.csv&max_results=10&nearest_points_to=26.7167,58.3833
    NSString *path = [NSString stringWithFormat:@"%@&%@=%d&%@=%@&%@=%@", kGetWPListPath, kMaxResultsKey, 1000, kNearestPointToKey, locationString, kBBoxKey, serverBBox];
    
    NSString *baseUrlString = [[Database sharedInstance] serverBaseUrl];
    NSString *baseUrlSuffix = [[Database sharedInstance] serverSuffix];

    NSString *url = [NSString stringWithFormat:@"%@%@/%@", baseUrlString, baseUrlSuffix, path];
    MSLog(@"Get WP list from: %@", url);
    
    NSString *language = [LocationManager getPhoneLanguage];
    NSDictionary *parameters;
    if (language) {
      parameters = [NSDictionary dictionaryWithObject:language forKey:kLanguageCodeKey];
    }
    MSLog(@"GET WP list with parameters:%@", parameters);
    
    NSURLRequest *request = [[[AFHTTPClient alloc] init] requestWithMethod:@"GET" path:url parameters:parameters];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSData *responseData = (NSData *)responseObject;
      NSArray *resultArray = [[Database sharedInstance] WPListFromData:responseData];
      success(resultArray);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Things go boom. %@", [error localizedDescription]);
      failure(error);
    }];
    [operation start];

    
  } errorBlock:^(NSError *error) {
    failure(error);
  }];
  
}

@end
