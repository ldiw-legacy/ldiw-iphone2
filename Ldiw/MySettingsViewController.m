//
//  MySettingsViewController.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MySettingsViewController.h"
#import "Database+Server.h"
#import "DesignHelper.h"

@interface MySettingsViewController ()

@end

@implementation MySettingsViewController

@synthesize uploadSettingBaseView, uploadSettingSwitch, uploadSettingDescritption, uploadSettingTitle;

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
  [self setTitle:@"My Settings"];
  [self.navigationItem setHidesBackButton:YES];
  
  UIImage *backimage = [UIImage imageNamed:@"back_normal@2x"];
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.bounds = CGRectMake( 0, 0, 50, 30);
  [backButton setBackgroundImage:backimage forState:UIControlStateNormal];
  [backButton setBackgroundImage:[UIImage imageNamed:@"back_pressed@2x.png"] forState:UIControlStateHighlighted];
  [backButton addTarget:self action:@selector(customBackPressed:) forControlEvents:UIControlEventTouchUpInside];
  [backButton setTitle:NSLocalizedString(@"back", nil)  forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:backButton];
  UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  [self.navigationItem setLeftBarButtonItem:backBarBtn];
  
  DCRoundSwitch *onlineOfflineSwitch = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(200, 55, 110, 30)];
  [onlineOfflineSwitch setOnText:@"WIFI"];
  [onlineOfflineSwitch setOffText:@"3G/WIFI"];
  [onlineOfflineSwitch addTarget:self action:@selector(wifiOr3g:) forControlEvents:UIControlEventValueChanged];
  [self setUploadSettingSwitch:onlineOfflineSwitch];
  [self.view addSubview:onlineOfflineSwitch];
  
  [uploadSettingTitle setText:NSLocalizedString(@"setting.upload.title", nil)];
  [uploadSettingDescritption setText:NSLocalizedString(@"setting.upload.description", nil)];
  if ([[[Database sharedInstance] currentUser].uploadWifiOnly isEqualToNumber:[NSNumber numberWithInt:kUploadWifiOnly]]) {
    [uploadSettingSwitch setOn:YES];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)customBackPressed:(UIBarButtonItem *)sender {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)wifiOr3g:(DCRoundSwitch *)sender {
  if (sender.isOn) {
    [[[Database sharedInstance] currentUser] setUploadWifiOnly:[NSNumber numberWithInt:kUploadWifiOnly]];
    MSLog(@"Upload setting set: WIFI only");
  } else {
    [[[Database sharedInstance] currentUser] setUploadWifiOnly:[NSNumber numberWithInt:kUploadWifiAnd3G]];
    MSLog(@"Upload setting set: WIFI and 3G");
  }
  [[Database sharedInstance] saveContext];
}
@end
