//
//  WastepointRequest.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "NetworkRequest.h"
#import <MapKit/MapKit.h>

@interface WastepointRequest : NetworkRequest

+ (void)getWPListWithBbox:(NSString *)box andCoordinates:(NSString *)coordinates withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

+ (void)getWPListForArea:(MKCoordinateRegion)region withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;
@end
