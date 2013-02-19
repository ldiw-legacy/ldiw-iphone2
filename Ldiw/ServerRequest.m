//
//  ServerRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ServerRequest.h"
#import "Database+Server.h"
#define kGetWPFieldsPath @"/waste-point-extra-fields.json"

@implementation ServerRequest

+ (void)getWPFieldsWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
  // URL: GET <api_base_url>/waste-point-extra-fields.json
  [[self sharedHTTPClient] getPath:kGetWPFieldsPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *jsonError;
    
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
    MSLog(@"Got datavse fields %@", responseDict);
    success(responseDict);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
  
}

@end
