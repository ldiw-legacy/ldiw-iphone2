//
//  ServerRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"

@interface BaseUrlRequest : NSObject

+ (void)loadServerInfoForCurrentLocationWithSuccess:(void (^)())success failure:(void (^)())failure;

@end
