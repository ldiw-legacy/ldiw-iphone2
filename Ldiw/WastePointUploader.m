//
//  WastePointUploader.m
//  Ldiw
//
//  Created by Johannes Vainikko on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePointUploader.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "Database+Server.h"
#import "Database+WP.h"
#import "User.h"
#import "Reachability.h"
#import "Image.h"
#import "CustomValue.h"

#define kCreateNewWPPath @"?q=api/wp.json"

@implementation WastePointUploader


+ (void)uploadWP:(WastePoint *)point withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  NSString *lat = [NSString stringWithFormat:@"%g", point.latitudeValue];
  NSString *lon = [NSString stringWithFormat:@"%g", point.longitudeValue];
  
  [parameters setObject:lat forKey:@"lat"];
  [parameters setObject:lon forKey:@"lon"];
  
  for (CustomValue *val in point.customValues) {
    [parameters setObject:val.value forKey:val.fieldName];
  }
  
  Image *image = point.images.anyObject;
  NSData *imgData = [NSData dataWithContentsOfFile:image.localURL];
  
  NSURL *serverBaseUrl = [NSURL URLWithString:[[Database sharedInstance] serverBaseUrl]];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:serverBaseUrl];

  NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:kCreateNewWPPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    if (imgData) {
      [formData appendPartWithFileData:imgData name:@"photo_file_1" fileName:@"file" mimeType:@"application/octet-stream"];
    }
  }];
  [request setHTTPShouldHandleCookies:YES];
    
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
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
  
  MSLog(@"All header fields: %@", request.allHTTPHeaderFields);
  [httpClient enqueueHTTPRequestOperation:operation];
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
      
      [[Database sharedInstance] createWastePointWithDictionary:responseWP];
      
      [WPs removeObject:wp];
      [[[Database sharedInstance] managedObjectContext] deleteObject:wp];
      [[Database sharedInstance] saveContext];
      MSLog(@"UPLOAD SUCCESSFUL FOR WP");

      if (WPs.count > 0) {
        [self uploadAllLocalWPsWithArray:WPs];        
      } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUploadsComplete object:nil];
      }
    } failure:^(NSError *error) {
      MSLog(@"UPLOAD FAILED FOR: %@", wp);
    }];
}

@end
