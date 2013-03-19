//
//  WastePointUploader.m
//  Ldiw
//
//  Created by Johannes Vainikko on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePointUploader.h"
#import "AFHTTPRequestOperation.h"
#import "Database+Server.h"
#import "Database+WP.h"
#import "User.h"
#import "Reachability.h"
#import "Image.h"

#define kCreateNewWPPath @"?q=api/wp.json"

@implementation WastePointUploader


+ (void)uploadWP:(WastePoint *)point withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  NSString *lat = [NSString stringWithFormat:@"%g", point.latitudeValue];
  NSString *lon = [NSString stringWithFormat:@"%g", point.longitudeValue];
  
  [parameters setObject:lat forKey:@"lat"];
  [parameters setObject:lon forKey:@"lon"];

  Image *image = point.images.anyObject;
  NSData *imgData = [NSData dataWithContentsOfFile:image.localURL];
  
  NSMutableURLRequest *request = [[LoginClient sharedLoginClient] multipartFormRequestWithMethod:@"POST" path:kCreateNewWPPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:imgData name:@"photo_file_1"];
  }];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  User *user = [[Database sharedInstance] currentUser];

  if (user.token) {
    [request setValue:user.token forHTTPHeaderField:user.uid];
  }
  

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject isKindOfClass:[NSData class]]) {
      NSError *error;
      responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
      
    }
    MSLog(@"New WP created!");
    MSLog(@"Response %@", responseObject);
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    MSLog(@"Error: %@", error);
    failure(error);
  }];
  
  [[LoginClient sharedLoginClient] enqueueHTTPRequestOperation:operation];
}

+ (void)uploadAllLocalWPs {
  MSLog(@"LOCAL WPs COUNT: %i", [[Database sharedInstance] listWastePointsWithNoId].count);
  NSMutableArray *localWPs = [NSMutableArray arrayWithArray:[[Database sharedInstance] listWastePointsWithNoId]];
  if (localWPs.count <= 0 ) {
    return;
  }
  
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  [reachability startNotifier];
  
  NetworkStatus status = [reachability currentReachabilityStatus];
  int userUploadSetting = [[Database sharedInstance] currentUser].uploadWifiOnlyValue;
  
  if(status == NotReachable)
  {
    //No internet
    MSLog(@"No Internet connection");
  }
  else if (status == ReachableViaWiFi && (userUploadSetting == ReachableViaWiFi || userUploadSetting == ReachableViaWWAN))
  {
    //WiFi and 3G
    MSLog(@"-- WIFI is Active!");
    [WastePointUploader uploadAllLocalWPsWithArray:localWPs];
  }
  else
  {
    MSLog(@"-- No 3G upload is allowed!");
  }
}

+ (void)uploadAllLocalWPsWithArray:(NSMutableArray *)WPs {
    WastePoint *wp = [WPs objectAtIndex:0];
    [WastePointUploader uploadWP:wp withSuccess:^(NSDictionary* result) {
      NSDictionary *responseWP = [result objectForKey:[result.allKeys objectAtIndex:0]];
      NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
      [f setNumberStyle:NSNumberFormatterDecimalStyle];
      NSNumber *myNumber = [f numberFromString:[responseWP objectForKey:kKeyId]];
      [wp setId:myNumber];
//      [wp setPhotos:[responseWP objectForKey:kKeyPhotos]];
      [WPs removeObject:wp];
      if (WPs.count > 0) {
        [self uploadAllLocalWPsWithArray:WPs];        
      }
      MSLog(@"UPLOAD SUCCESSFUL FOR WP WITH ID: %@", wp.id);
    } failure:^(NSError *error) {
      MSLog(@"UPLOAD FAILED FOR: %@", wp);
    }];
}

@end
