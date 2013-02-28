//
//  MySettingsViewController.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MySettingsViewController.h"
#import "DesignHelper.h"

@interface MySettingsViewController ()

@end

@implementation MySettingsViewController

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
@end
