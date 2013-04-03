//
//  AppDelegate.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "Database.h"
#import "ActivityViewController.h"
#import "Database+Server.h"
#import "LocationManager.h"
#import "BaseUrlRequest.h"
#import "DesignHelper.h"
#import "WastePointUploader.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  if ([[[Database sharedInstance] currentUser] uploadWifiOnly] == nil) {
    [[[Database sharedInstance] currentUser] setUploadWifiOnly:[NSNumber numberWithInt:kUploadWifiOnly]];
  }
  UITabBarController *tabBar = [DesignHelper createTabBarController];
  
  [self.window setRootViewController:tabBar];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:kNotifycationUserDidExitRegion object:nil];
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [[Database sharedInstance] saveContext];
  [[LocationManager sharedManager] stopLocationManager];
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [FBSession.activeSession handleDidBecomeActive];
  [WastePointUploader uploadAllLocalWPs];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [FBSession.activeSession handleOpenURL:url];
}

- (void)locationChanged:(NSNotification *)notification {
}
@end
