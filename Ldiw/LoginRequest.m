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
#import "Database+Server.h"
#import "Server.h"
#import "User.h"

@implementation LoginRequest

#define kLoginPath @"user/login.json"


+ (void)logInWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
  [[LoginClient sharedLoginClient] postPath:kLoginPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      User *userinfo = [[Database sharedInstance] currentUser];
      userinfo.sessid = [responseObject objectForKey:@"sessid"];
      userinfo.session_name = [responseObject objectForKey:@"session_name"];
      
      if (success) {
        success(responseObject);
      }
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    MSLog(@"Error %@", error);
    failure(error);
  }];
}

+ (void)loginWithFBToken:(NSString *)token andUID:(NSString *)uid{
  NSURL *url = [NSURL URLWithString:@"http://test.letsdoitworld.org/"];
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"access_token", uid, @"fb_uid", nil];
  [httpClient postPath:@"api/user/fbconnect.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"Request Successful, response '%@'", responseStr);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
  }];
}


@end
