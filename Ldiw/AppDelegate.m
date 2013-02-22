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
#import "LoginViewController.h"
#import "Database+Server.h"
#import "LocationManager.h"
#import "BaseUrlRequest.h"
#import "DesignHelper.h"

@implementation AppDelegate

@synthesize mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  if ([Database isUserLoggedIn] == YES) {
    UITabBarController *tabBar = [DesignHelper createActivityView];
    [self.window setRootViewController:tabBar];
  } else {
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:lvc];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:kNotifycationUserDidExitRegion object:nil];
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    // Yes, so just open the session (this won't display any UX).
    [self openSession];
  } else {
    // No, display the login page.
    [self showLoginView];
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [[Database sharedInstance] saveContext];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
  return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark Facebook SDK
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
  switch (state) {
    case FBSessionStateOpen: {
      [[FBRequest requestForMe] startWithCompletionHandler:
       ^(FBRequestConnection *connection,
         NSDictionary<FBGraphUser> *user,
         NSError *error) {
         if (!error) {
           MSLog(@"UID: %@", user.id);
           [self.mainViewController gotoActivityView];
         }
       }];
    }
      break;
    case FBSessionStateClosed: {
      MSLog(@"FB SESSION CLOSED!");
    }
      break;
    case FBSessionStateClosedLoginFailed:
      // Once the user has logged in, we want them to
      // be looking at the root view.
      
      [FBSession.activeSession closeAndClearTokenInformation];
      
      break;
    default:
      break;
  }
  
  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"facebook.error.title",nil)
                              message:NSLocalizedString(@"facebook.error.login", nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"button.ok", nil)
                              otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)openSession
{
  [FBSession openActiveSessionWithReadPermissions:nil
                                     allowLoginUI:YES
                                completionHandler:
   ^(FBSession *session,
     FBSessionState state, NSError *error) {
     [self sessionStateChanged:session state:state error:error];
   }];
}

- (void)showLoginView
{
  // Show login view
}

- (void)locationChanged:(NSNotification *)notification {
  MSLog(@"Got location changed notification");
  CLLocation *location = (CLLocation *)notification.object;
  NSString *serverBox = [[Database sharedInstance] bBox];
  if (serverBox) {
    MSLog(@"Server box is present, check if user is inside box");
    BOOL userIsInsideBox = [[LocationManager sharedManager] location:location IsInsideBox:serverBox];
    if (!userIsInsideBox) {
      [BaseUrlRequest loadServerInfoForCurrentLocationWithSuccess:^(void) {
        MSLog(@"New base url loaded");
      } failure:^(void) {
        MSLog(@"Server info loading fail");
      }];
    }
  }
}
@end
