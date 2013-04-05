//
//  LoginViewController.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import "LoginRequest.h"
#import "LoginViewController.h"
#import "ActivityViewController.h"
#import "DesignHelper.h"
#import "FBHelper.h"
#import "Constants.h"
#import "LocationManager.h"
#import "Database+Server.h"
#import "Database+User.h"
#import "BaseUrlRequest.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginUserLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation LoginViewController
@synthesize loginUserLabel,loginPasswordLabel,signinButton, delegate, facebookLoginButton, registerButton;

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
  self.view.backgroundColor = kDarkBackgroundColor;
  [DesignHelper setLoginButtonTitle:self.facebookLoginButton];
  [DesignHelper setLoginButtonTitle:self.registerButton];
  [self.registerButton setTitle:NSLocalizedString(@"login.register", nil)     forState:UIControlStateNormal];
  [self.facebookLoginButton setTitle:NSLocalizedString(@"login.facebook", nil) forState:UIControlStateNormal];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLoginView) name:kNotificationDismissLoginView object:nil];
}

- (void)loginUser {
  NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.loginPasswordLabel.text, @"password", self.loginUserLabel.text, @"username", nil];
  
  [LoginRequest logInWithParameters:parameters andFacebook:NO success:^(NSDictionary *success) {
    MSLog(@"SUCCESS:: %@", success);
    [self closeLoginView];
  } failure:^(NSError *e) {
    [self.spinner stopAnimating];
    NSString *errorstring;
    if (e.code==0)
    {
      errorstring=[e.userInfo objectForKey:@"NSLocalizedDescription"];
    } else {
      NSString *strg = [[e.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"] description];
      
      if (![strg length] > 0) {
        strg = @"Sorry, our servers are too busy. Try again later.";
      }
      
      NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
      errorstring=[[strg componentsSeparatedByCharactersInSet:set] componentsJoinedByString: @""];
    }
    [self showAlertWithText:errorstring];
  }];
}

- (void)showAlertWithText:(NSString *)alertText {
  UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil
                                             message:alertText
                                            delegate:self
                                   cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [av show];
}

- (IBAction)signin:(UIButton *)sender {
  [self signInWithFacebook:NO];
}

- (void)signInWithFacebook:(BOOL)facebookLogin {
  [self.view endEditing:YES];
  [self.spinner startAnimating];
  if ([[LocationManager sharedManager] locationServicesEnabled]) {
    [[Database sharedInstance] needToLoadServerInformationWithBlock:^(BOOL result) {
      if (result) {
        MSLog(@"Need to load base server information");
        [BaseUrlRequest loadServerInfoForCurrentLocationWithSuccess:^(void) {
          if (facebookLogin) {
            [FBHelper openSession];
          } else {
            [self loginUser];          
          }
        } failure:^(void) {
          [self showAlertWithText:@"Network error"];
        }];
      } else {
        [self closeLoginView];
      }
    }];
  }
}

- (void)closeLoginView {
  [self.spinner stopAnimating];

  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [[Database sharedInstance] setUserCurrentLocation:location];
    [delegate loginSuccessful];
  } errorBlock:^(NSError *error) {
    [delegate loginSuccessful];
    MSLog(@"Unable to get location");
  }];
}

- (IBAction)registerAccount:(UIButton *)sender {
  [[UIApplication sharedApplication] openURL: [NSURL URLWithString:kExternalWebLink]];
}

- (IBAction)loginFB:(id)sender {
  [self signInWithFacebook:YES];
}

- (IBAction)backgroundTap:(id)sender {
  [[self view] endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
  if (textField == loginUserLabel) {
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
-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self.spinner stopAnimating];
}

#pragma mark Facebook
- (void)loginFailed {
  if (delegate) {
    [delegate loginFailed];
  }
  [self.spinner stopAnimating];
}

- (void)viewDidUnload {
  [self setSpinner:nil];
  [super viewDidUnload];
}
@end
