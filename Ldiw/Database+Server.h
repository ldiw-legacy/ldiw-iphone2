//
//  Database+Server.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"
#import "WPField.h"
#import "TypicalValue.h"
#import "AllowedValue.h"
#import "LocationManager.h"

@interface Database (Server)

- (void)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox;
- (NSString *)serverBaseUrl;
- (NSString *)serverSuffix;
- (NSString *)bBox;
- (Server *)currentServer;

- (void)setCurrentLocation:(CLLocation *)currentLocation;
- (CLLocation *)currentLocation;

- (void)needToLoadServerInfotmationWithBlock:(void (^)(BOOL result)) resultBlock;;
@end
