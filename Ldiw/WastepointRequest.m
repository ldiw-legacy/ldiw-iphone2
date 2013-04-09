//
//  WastepointRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastepointRequest.h"
#import "Database+Server.h"
#import "Database+User.h"
#import "Database+WP.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "LocationManager.h"

#define kGetWPListPath @"waste_points.csv"
#define kCreateNewWPPath @"wp.json"

#define kNrOfResultsForMap 20
#define kNrOfResultsForList 100
#define kMaxResultsKey @"max_results" //default 10
#define kNearestPointToKey @"nearest_points_to" //optional coordinates (lon,lat in WGS84): "-74,30". If set, then returns individual WPs (not clusters) nearest to the coordinates given, and also adds a distance_meters field to results.
#define kBBoxKey @"BBOX" // optional

#define kErrorRequestCancelled -999

@implementation WastepointRequest

+ (AFHTTPClient *)sharedWastepointClient {
  static WastepointRequest *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURL *serverBaseUrl = [NSURL URLWithString:[[Database sharedInstance] serverBaseUrl]];
    _sharedClient = [[WastepointRequest alloc] initWithBaseURL:serverBaseUrl];
  });
  
  NSURL *serverBaseUrl = [NSURL URLWithString:[[Database sharedInstance] serverBaseUrl]];
  if (![_sharedClient.baseURL isEqual:serverBaseUrl]) {
    MSLog(@"Change base url for shared client");
    _sharedClient = [[WastepointRequest alloc] initWithBaseURL:serverBaseUrl];
  }
  
  return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
  if (!url) {
    return nil;
  }
  self = [super initWithBaseURL:url];
  if (self) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    self.parameterEncoding = AFJSONParameterEncoding;
  }
  return self;
}

+ (void)getWPListForCurrentAreaForViewType:(ViewType)viewType withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  NSString *bbox = [[LocationManager sharedManager] currentBoundingBox];
  CLLocationCoordinate2D currentLocation = [[[Database sharedInstance] currentUserLocation] coordinate];
  NSString *locationString = [NSString stringWithFormat:@"%g,%g", currentLocation.longitude, currentLocation.latitude];

  [self getWPListWithBbox:bbox andCoordinates:locationString andViewType:ViewTypeList withSuccess:^(NSArray* responseArray) {
    success(responseArray);
  } failure:^(NSError *error) {
    failure(error);
  }];
}


+ (void)getWPListForArea:(MKCoordinateRegion)region andViewType:(ViewType)viewType withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  MKCoordinateSpan span = region.span;
  
  CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(region.center.latitude - span.latitudeDelta, region.center.longitude - span.longitudeDelta);
  CLLocationCoordinate2D botRight = CLLocationCoordinate2DMake(region.center.latitude + span.latitudeDelta, region.center.longitude + span.longitudeDelta);
  NSString *bBoxString = [NSString stringWithFormat:@"%g,%g,%g,%g", topLeft.longitude, topLeft.latitude, botRight.longitude, botRight.latitude];

  [self getWPListWithBbox:bBoxString andCoordinates:nil andViewType:viewType withSuccess:^(NSArray* responseArray) {
    success(responseArray);
  } failure:^(NSError *error) {
    failure(error);
  }];
}

+ (void)getWPListWithBbox:(NSString *)box andCoordinates:(NSString *)coordinates andViewType:(ViewType)viewType withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  //  URL: GET/POST <api_base_url>/waste_points.{json,csv,kml}
  // ONLY CSV is supported
  
  // http://api.letsdoitworld.org/?q=api/waste_points.csv&max_results=10&nearest_points_to=26.7167,58.3833

  // Cancel all previous operations
  [[[WastepointRequest sharedWastepointClient] operationQueue] cancelAllOperations];
  
  NSString *baseUrlSuffix = [[Database sharedInstance] serverSuffix];

  int maxResults = 0;
  if (viewType == ViewTypeList) {
    maxResults = kNrOfResultsForList;
  } else if (viewType == ViewTypeLargeMap || viewType == ViewTypeSmallMap) {
    maxResults = kNrOfResultsForMap;
  }
  
  NSMutableString *path = [NSMutableString stringWithFormat:@"%@/%@&%@=%d&%@=%@", baseUrlSuffix, kGetWPListPath, kMaxResultsKey, maxResults, kBBoxKey, box];
  
  if (coordinates) {
    [path appendFormat:@"&%@=%@", kNearestPointToKey, coordinates];
  }
  
  NSString *language = [LocationManager getPhoneLanguage];
  NSDictionary *parameters;
  if (language) {
    parameters = [NSDictionary dictionaryWithObject:language forKey:kLanguageCodeKey];
  }
  MSLog(@"List wp request to path %@", path);
  
  [[WastepointRequest sharedWastepointClient] getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSData *responseData = (NSData *)responseObject;
    NSArray *resultArray = [[Database sharedInstance] WPListFromData:responseData forViewType:viewType];
    MSLog(@"List wastepoints request done with %d objects", [resultArray count]);
    success(resultArray);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSInteger errorCode = error.code;
    if (errorCode == kErrorRequestCancelled) {
      MSLog(@"Previous request cancelled");
    } else {
      NSLog(@"Things go boom. %@", error);
      failure(error);
    }
  }];
}

@end
