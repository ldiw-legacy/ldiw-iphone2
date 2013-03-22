//
//  Database+User.h
//  Ldiw
//
//  Created by Timo Kallaste on 2/21/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"
#import "Database+Server.h"
#import "LocationManager.h"

@interface Database (User)

- (void)setUserCurrentLocation:(CLLocation *)currentLocation;
- (CLLocation *)currentUserLocation;

@end
