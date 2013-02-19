//
//  NetworkRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"
#import "AFJSONRequestOperation.h"

@implementation NetworkRequest

+ (id)sharedHTTPClient
{
  static NetworkRequest *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
     NSURL *requestURL = [NSURL URLWithString:kFirstServerUrl];
    _sharedClient = [[NetworkRequest alloc] initWithBaseURL:requestURL];
  });
  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }
    
  // [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
  self.parameterEncoding = AFJSONParameterEncoding;
  
  [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingOperationDidStartNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[note object];
    MSLog(@"Operation started: %@", operation.request.URL);
  }];
  
  return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
  
  NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
  [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
  //  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  return request;
}

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
  [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRea)
   {
     // NSLog(@"DOWNLOAD PROGRESS %i, %lld, %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
   }];
  
  [super enqueueHTTPRequestOperation:operation];
}

@end
