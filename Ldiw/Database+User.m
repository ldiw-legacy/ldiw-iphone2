//
//  Database+User.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/21/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+User.h"

@implementation Database (User)

- (void)setUserCurrentLocation:(CLLocation *)currentLocation {
  MSLog(@"--- SET Location");
  User *currentUser = [[Database sharedInstance] currentUser];
  [currentUser setUserLatitudeValue:currentLocation.coordinate.latitude];
  [currentUser setUserLongitudeValue:currentLocation.coordinate.longitude];
}

- (CLLocation *)currentUserLocation {
  User *currentUser = [[Database sharedInstance] currentUser];
  CLLocation *returnLocation = [[CLLocation alloc] initWithLatitude:currentUser.userLatitudeValue longitude:currentUser.userLongitudeValue];
  return  returnLocation;
}

@end
