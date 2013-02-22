//
//  Database+Server.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+Server.h"
#import "Database+WPField.h"
#import "Server.h"

@implementation Database (Server)

- (Server *)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox {
  MSLog(@"Save server with baseUrl %@ and bbox %@", baseUrl, safeBBox);
  [self deleteAllWPFields];
  
  // Note that returned api_base_url may or may not include a query portion ('?').
  // This requires correct handling for functions needing GET parameters:
  // if api_base_url includes '?', then additional GET parameters must be appended to URL using '&';
  // otherwise, the first GET parameter must be appended using '?'.
  
  NSString *suffix = @"?";
  NSArray *urlPartsArray = [baseUrl componentsSeparatedByString:@"?"];
  if ([urlPartsArray count] > 1) {
    suffix = [NSString stringWithFormat:@"?%@", [urlPartsArray objectAtIndex:1]];
    baseUrl = [urlPartsArray objectAtIndex:0];
  }
  
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:nil];

  if (!server) {
    server = [Server insertInManagedObjectContext:self.managedObjectContext];
  }
  
  [server setBaseUrlSuffix:suffix];
  [server setBaseUrl:baseUrl];
  [server setSafeBBox:safeBBox];
  [self saveContext];
  return server;
}

- (NSString *)serverBaseUrl {
  Server *server = [self currentServer];
  return server.baseUrl;
}

- (NSString *)serverSuffix {
  Server *server = [self currentServer];
  return server.baseUrlSuffix;
}

- (NSString *)bBox {
  Server *server = [self currentServer];
  return server.safeBBox;
}

- (Server *)currentServer {
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:nil];
  if (!server) {
    server = [self addServerWithBaseUrl:nil andSafeBBox:nil];
  }
  return server;
}

- (User *)currentUser {
  User *user = [self findCoreDataObjectNamed:@"User" withPredicate:nil];
  if (!user) {
    user = [User insertInManagedObjectContext:self.managedObjectContext];
  }
  return user;
}

- (void)setCurrentLocation:(CLLocation *)currentLocation {
  Server *server = [self currentServer];
  [server setLocationLatValue:currentLocation.coordinate.latitude];
  [server setLocationLonValue:currentLocation.coordinate.longitude];
}

- (CLLocation *)currentLocation {
  Server *server = [self currentServer];
  double lon = server.locationLonValue;
  double lat = server.locationLatValue;
  CLLocation *returnLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
  return  returnLocation;
}

- (void)needToLoadServerInfotmationWithBlock:(void (^)(BOOL))resultBlock {
  MSLog(@"NeedToLoadServerInformationWithBlock");
  [[LocationManager sharedManager] currentLocationIsInsideBox:[self bBox] withResultBlock:^(BOOL locationIsInsideBox) {
    NSString *baseUrl = [self serverBaseUrl];
    BOOL serverInfoIsAvailable = (baseUrl.length == 0);
    BOOL needToLoadServerInfo = !serverInfoIsAvailable || !locationIsInsideBox;
    resultBlock(needToLoadServerInfo);
  }];
}

+ (BOOL)isUserLoggedIn {
  if ([[self  sharedInstance] currentUser].sessid) {
    return YES;
  } else {
    return NO;
  }
}

@end
