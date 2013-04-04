//
//  LoginClient.m
//  Ldiw
//
//  Created by Johannes Vainikko on 2/21/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LoginClient.h"
#import "AFJSONRequestOperation.h"
#import "Database+Server.h"

@implementation LoginClient

+ (id)sharedLoginClient
{
  static LoginClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  NSURL *serverUrl = [NSURL URLWithString:[[Database sharedInstance] serverBaseUrl]];
  dispatch_once(&onceToken, ^{
    _sharedClient = [[LoginClient alloc] initWithBaseURL:serverUrl];
  });
  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  if (!url) {
    return nil;
  }
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }
  
  // [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
  self.parameterEncoding = AFJSONParameterEncoding;
  
  return self;
}

@end
