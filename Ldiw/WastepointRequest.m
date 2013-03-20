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
#define kCreateNewWPPath @"wp.json"

#define kResultsToReturn 100
#define kMaxResultsKey @"max_results" //default 10
#define kNearestPointToKey @"nearest_points_to" //optional coordinates (lon,lat in WGS84): "-74,30". If set, then returns individual WPs (not clusters) nearest to the coordinates given, and also adds a distance_meters field to results.
#define kBBoxKey @"BBOX" // optional

@implementation WastepointRequest

+ (void)getWPListForArea:(MKCoordinateRegion)region withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  CLLocationCoordinate2D center = region.center;
  MKCoordinateSpan span = region.span;
  
  CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(region.center.latitude - span.latitudeDelta, region.center.longitude - span.longitudeDelta);
  CLLocationCoordinate2D botRight = CLLocationCoordinate2DMake(region.center.latitude + span.latitudeDelta, region.center.longitude + span.longitudeDelta);
  NSString *bBoxString = [NSString stringWithFormat:@"%g,%g,%g,%g", topLeft.longitude, topLeft.latitude, botRight.longitude, botRight.latitude];
  NSString *locationString = [NSString stringWithFormat:@"%g,%g", center.longitude, center.latitude];
  [self getWPListWithBbox:bBoxString andCoordinates:locationString withSuccess:^(NSArray* responseArray) {
    success(responseArray);
  } failure:^(NSError *error) {
    failure(error);
  }];
}

+ (void)getWPListWithBbox:(NSString *)box andCoordinates:(NSString *)coordinates withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  //  URL: GET/POST <api_base_url>/waste_points.{json,csv,kml}
  // ONLY CSV is supported
  
  // http://api.letsdoitworld.org/?q=api/waste_points.csv&max_results=10&nearest_points_to=26.7167,58.3833
  NSString *path = [NSString stringWithFormat:@"%@&%@=%d&%@=%@&%@=%@", kGetWPListPath, kMaxResultsKey, kResultsToReturn, kNearestPointToKey, coordinates, kBBoxKey, box];
  
  NSString *baseUrlString = [[Database sharedInstance] serverBaseUrl];
  NSString *baseUrlSuffix = [[Database sharedInstance] serverSuffix];
  
  NSString *url = [NSString stringWithFormat:@"%@%@/%@", baseUrlString, baseUrlSuffix, path];
  
  NSString *language = [LocationManager getPhoneLanguage];
  NSDictionary *parameters;
  if (language) {
    parameters = [NSDictionary dictionaryWithObject:language forKey:kLanguageCodeKey];
  }
  
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
}



@end
