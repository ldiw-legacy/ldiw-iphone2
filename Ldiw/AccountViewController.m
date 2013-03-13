//
//  AccountViewController.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "AccountViewController.h"
#import "DesignHelper.h"
#import "MySettingsViewController.h"
#import "Database+Server.h"
#import "FBHelper.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  UIImage *image = [UIImage imageNamed:@"logo_titlebar"];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
  UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *settingsLogo = [UIImage imageNamed:@"actions_normal"];
  settingsButton.bounds = CGRectMake( 0, 0, 40, 30);
  [settingsButton setBackgroundImage:settingsLogo forState:UIControlStateNormal];
  [settingsButton setBackgroundImage:[UIImage imageNamed:@"actions_pressed"] forState:UIControlStateHighlighted];
  [settingsButton addTarget:self action:@selector(settingsPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
  [self.navigationItem setRightBarButtonItem:settingsBarButton];

  UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
  UIImage *logoutImage = [UIImage imageNamed:@"cancel_normal"];
  logoutButton.bounds = CGRectMake( 0, 0, logoutImage.size.width, logoutImage.size.height );
  [logoutButton setBackgroundImage:logoutImage forState:UIControlStateNormal];
  [logoutButton setBackgroundImage:[UIImage imageNamed:@"cancel_pressed"] forState:UIControlStateHighlighted];
  [logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
  [logoutButton setTitle:NSLocalizedString(@"setting.logout",nil) forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:logoutButton];
  UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
  self.navigationItem.leftBarButtonItem = logoutBarButton;

}

- (void)logoutPressed:(UIButton *)sender
{
  NSLog(@"LogOut Pressed");
  // Implement logOut
  User *userinfo = [[Database sharedInstance] currentUser];
  userinfo.sessid=nil;
  userinfo.session_name=nil;
  userinfo.token=nil;
  [FBSession.activeSession close];
  [[Database sharedInstance] saveContext];
  self.tabBarController.selectedIndex=0;
  
}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)settingsPressed:(id)sender {
  MySettingsViewController *settingsVC = [[MySettingsViewController alloc] initWithNibName:@"MySettingsViewController" bundle:nil];
  [self.navigationController pushViewController:settingsVC animated:YES];
}

@end
