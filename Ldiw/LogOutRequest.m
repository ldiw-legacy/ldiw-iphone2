//
//  LogOutRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 3/14/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LogOutRequest.h"
#import "LoginClient.h"
#define kLogoutPath @"?q=api/user/logout.json"
@implementation LogOutRequest

+ (void)logOutUserWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
  [[LoginClient sharedLoginClient] postPath:kLogoutPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    MSLog(@"Logout success");
    if ([responseObject isKindOfClass:[NSData class]]) {
      NSError *error;
      responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
    }
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    MSLog(@"Logout failed");
    failure(error);
  }];
}

@end
