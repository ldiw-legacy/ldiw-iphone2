//
//  WastepointRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NetworkRequest.h"
#import "WastePoint.h"

@interface WastepointRequest : NetworkRequest

+ (void)getWPListForArea:(MKCoordinateRegion)region withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
+ (void)getWPListForCurrentAreaWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end
