//
//  LoginClient.h
//  Ldiw
//
//  Created by Johannes Vainikko on 2/21/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "AFHTTPClient.h"

@interface LoginClient : AFHTTPClient

+ (id)sharedLoginClient;

@end
