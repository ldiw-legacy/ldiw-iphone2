//
//  LoginViewController.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import "LoginRequest.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "ActivityViewController.h"
#import "DesignHelper.h"
#define kDarkBackgroundColor [UIColor colorWithRed:0.153 green:0.141 blue:0.125 alpha:1] /*#272420*/
#define kExternalWebLink @"https://www.letsdoitworld.org/user/register"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginUserLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;




@end

@implementation LoginViewController
@synthesize loginUserLabel,loginPasswordLabel,signinButton;

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
  self.view.backgroundColor=kDarkBackgroundColor;
  [DesignHelper setLoginButtonTitle:self.facebookLoginButton];
  [DesignHelper setLoginButtonTitle:self.registerButton];
  [self.registerButton setTitle:NSLocalizedString(@"login.register", nil)     forState:UIControlStateNormal];
  [self.facebookLoginButton setTitle:NSLocalizedString(@"login.facebook", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)signin:(UIButton *)sender {
  [self resignFirstResponder];
//  NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:self.loginPasswordLabel.text, @"password", self.loginUserLabel.text, @"username", nil];
//
//  [LoginRequest logInWithParameters:parameters success:^(NSArray *success) {
//     NSLog(@"ResultArray %@",success);
//    
//     [self gotoActivityView];
//  } failure:^(NSError *e) {
//    NSLog(@"Login Error  %@",e);
//  }];
  [self gotoActivityView];


  
}

- (IBAction)registerAccount:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:kExternalWebLink]];
}

- (IBAction)loginFB:(id)sender {
}

-(void)gotoActivityView
{
  MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
  MainViewController *mainVC = [[MainViewController alloc]initWithNibName:nil bundle:nil];
  ActivityViewController *activityVC= [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
  UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:activityVC];

  UITabBarController *tabBar = [[UITabBarController alloc] init];
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]]];
  [tabBar setViewControllers:[NSArray arrayWithObjects:navVC,mainViewController,mainVC, nil]];
  tabBar.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
  [self presentViewController:tabBar animated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
  if (textField==loginUserLabel) {
    [loginPasswordLabel becomeFirstResponder];
    return NO;
  } else {
    [textField resignFirstResponder];
    [self signin:nil];
  }
  return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
