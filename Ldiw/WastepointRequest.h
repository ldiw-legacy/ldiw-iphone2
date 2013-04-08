//
//  WastepointRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WastePoint.h"
#import "AFHTTPClient.h"

@interface WastepointRequest : AFHTTPClient

+ (void)getWPListForArea:(MKCoordinateRegion)region withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
+ (void)getWPListForCurrentAreaWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end
