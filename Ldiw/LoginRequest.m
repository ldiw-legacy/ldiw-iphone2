//
//  LoginRequest.m
//  Ldiw
//
//  Created by sander on 2/20/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LoginRequest.h"
#import "LoginViewController.h"

@implementation LoginRequest

#define kLoginPath @"user/login.json"
#define kLoginServerUrl  @"http://www.letsdoitworld.org/?q=api"

+ (void)logInWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
  
  AFHTTPClient *httpClient = [self sharedHTTPClient];
  [httpClient postPath:kLoginPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *jsonError;
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
    success(responseArray);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    MSLog(@"Error %@", error);
    failure(error);
  }];
  
}


@end
