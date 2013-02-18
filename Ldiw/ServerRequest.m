//
//  ServerRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ServerRequest.h"
#import "LocationManager.h"

#define kBaseUrlKey @"api_base_url"
#define kSafeBBoxKey @"safe_bbox"

@implementation ServerRequest

+ (void) loadServerInfoForCurrentLocationWithSuccess:(void (^)())success failure:(void (^)())failure {
  
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    
    NSString *latitude = [NSString stringWithFormat:@"%g", location.coordinate.latitude];
    NSString *longtitude = [NSString stringWithFormat:@"%g", location.coordinate.longitude];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:latitude forKey:@"lat"];
    [parameters setObject:longtitude forKey:@"lon"];
    
    NSURL *url = [NSURL URLWithString:kFirstServerUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kServerRequestPath parameters:parameters];

    AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                           NSError *jsonError;
                                           NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];

                                           //  {
                                           //    "api_base_url" = "http://api.letsdoitworld.org/?q=api";
                                           //    "safe_bbox" = "26.2167,57.8833,27.2167,58.8833";
                                           //  }
                                           NSString *baseUrl = [responseDict objectForKey:kBaseUrlKey];
                                           NSString *safeBox = [responseDict objectForKey:kSafeBBoxKey];
                                         // TODO: Save server information to database
                                           
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                           NSLog(@"Error: %@", error);
                                         }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
  } errorBlock:^(NSError *error) {
    // TODO:How to handle location error?
    MSLog(@"Can not get location informateion");
  }];
}

@end
