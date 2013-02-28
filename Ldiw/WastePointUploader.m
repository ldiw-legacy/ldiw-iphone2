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
#import "User.h"

#define kCreateNewWPPath @"?q=api/wp.json"

@implementation WastePointUploader


+ (void)uploadWP:(WastePoint *)point withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  NSString *lat = [NSString stringWithFormat:@"%g", point.latitudeValue];
  NSString *lon = [NSString stringWithFormat:@"%g", point.longitudeValue];
  
  [parameters setObject:lat forKey:@"lat"];
  [parameters setObject:lon forKey:@"lon"];
  
//  NSURL *url = [NSURL URLWithString:kCreateNewWPPath];
  
  NSMutableURLRequest *request = [[LoginClient sharedLoginClient] requestWithMethod:@"POST" path:kCreateNewWPPath parameters:parameters];
  
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
  
  
//  [[LoginClient sharedLoginClient] postPath:kCreateNewWPPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    MSLog(@"New WP created!");
//    MSLog(@"Response %@", responseObject);
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    MSLog(@"Error: %@", error);
//  }];
}

@end
