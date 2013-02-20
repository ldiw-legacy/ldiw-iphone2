//
//  LoginRequest.h
//  Ldiw
//
//  Created by sander on 2/20/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"

@interface LoginRequest : NetworkRequest

+ (void)logInWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;



@end
