//
//  LoginRequest.m
//  Ldiw
//
//  Created by sander on 2/20/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LoginRequest.h"
#import "LoginViewController.h"
#import "LoginClient.h"

@implementation LoginRequest

#define kLoginPath @"user/login.json"

+ (void)logInWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
  
  
  [[LoginClient sharedLoginClient] postPath:kLoginPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    MSLog(@"Error %@", error);
    failure(error);
  }];
  
}


@end
