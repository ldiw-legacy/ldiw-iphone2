//
//  LoginClient.m
//  Ldiw
//
//  Created by Johannes Vainikko on 2/21/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LoginClient.h"
#import "AFJSONRequestOperation.h"


#define kLoginServerUrl  @"https://www.letsdoitworld.org/api/"


@implementation LoginClient

+ (id)sharedLoginClient
{
  static LoginClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[LoginClient alloc] initWithBaseURL:[NSURL URLWithString:kLoginServerUrl]];
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
