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
#import "User.h"

@interface Database (Server)

- (Server *)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox;
- (NSString *)serverBaseUrl;
- (NSString *)serverSuffix;
- (NSString *)bBox;
- (Server *)currentServer;
- (User *)currentUser;

- (void)setCurrentLocation:(CLLocation *)currentLocation;
- (CLLocation *)currentLocation;

- (void)needToLoadServerInformationWithBlock:(void (^)(BOOL result)) resultBlock;

- (BOOL)userIsLoggedIn;

@end
