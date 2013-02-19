//
//  WastepointRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"

@interface WastepointRequest : NetworkRequest

+ (void)getWPList:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end
