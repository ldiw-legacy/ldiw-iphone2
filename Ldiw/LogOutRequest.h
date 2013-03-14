//
//  LogOutRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 3/14/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"

@interface LogOutRequest : NetworkRequest
+ (void)logOutUserWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

@end
