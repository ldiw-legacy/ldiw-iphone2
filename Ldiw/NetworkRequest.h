//
//  NetworkRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "AFHTTPClient.h"

@interface NetworkRequest : AFHTTPClient
+ (id)sharedHTTPClient;

@end
