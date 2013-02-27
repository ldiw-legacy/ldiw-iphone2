//
//  LoginRequest.h
//  Ldiw
//
//  Created by sander on 2/20/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"

@interface LoginRequest : NetworkRequest

+ (void)logInWithParameters:(NSDictionary *)parameters andFacebook:(BOOL)faceBookLogin success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
+ (void)loginUserToDatabaseWithDictionary:(NSDictionary *)inputDictionary;

@end
