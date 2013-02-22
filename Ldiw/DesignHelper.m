//
//  DesignHelper.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DesignHelper.h"
#import "MainViewController.h"
#import "ActivityViewController.h"

#define kHeaderButtonTitleColorNormal [UIColor darkGrayColor]
#define kHeaderButtonTitleColorSelected [UIColor whiteColor]
#define kHeaderButtonTitleShadowColor [UIColor darkGrayColor]
#define kTextSubtitleColor [UIColor colorWithRed:0.58 green:0.588 blue:0.545 alpha:1] /*#94968b*/
@implementation DesignHelper

+(void)setUpHeaderViewButton:(UIButton *)button
{
  [button setTitleColor:kHeaderButtonTitleColorSelected forState:UIControlStateSelected];
  [button setTitleColor:kHeaderButtonTitleColorNormal forState:UIControlStateNormal];
  [button setTitleShadowColor:kHeaderButtonTitleShadowColor forState:UIControlStateSelected];
  [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  button.titleLabel.shadowOffset = CGSizeMake (0,1);
  button.titleLabel.shadowColor = kHeaderButtonTitleShadowColor;
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
}

+(void)setLoginButtonTitle:(UIButton *)button
{
  [button setTitleColor:kHeaderButtonTitleColorSelected forState:UIControlStateHighlighted];
  button.titleLabel.font = [UIFont fontWithName:@"Caecilia-Heavy" size:18];
  
}

+(void)setActivityViewSubtitle:(UILabel *)label
{
  label.font=[UIFont fontWithName:@"HelveticaNeue" size:13];
  label.textColor=kTextSubtitleColor;
  label.backgroundColor=[UIColor clearColor];
  [label sizeToFit];
}
+(void)setActivityViewNametitle:(UILabel *)label
{
  label.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
  label.textColor=[UIColor whiteColor];
  label.backgroundColor=[UIColor clearColor];
  [label sizeToFit];
  
}

+(void)setActivityViewActiontitle:(UILabel *)label
{
  label.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
  label.textColor=[UIColor whiteColor];
  label.backgroundColor=[UIColor clearColor];
  [label sizeToFit];
}

+(void)setActivityViewLocationtitle:(UILabel *)label
{
  
}


+(UITabBarController*) createActivityView {
  MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
  MainViewController *mainVC = [[MainViewController alloc]initWithNibName:nil bundle:nil];
  ActivityViewController *activityVC= [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
  UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:activityVC];
  
  UITabBarController *tabBar = [[UITabBarController alloc] init];
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]]];
  [tabBar setViewControllers:[NSArray arrayWithObjects:navVC,mainViewController,mainVC, nil]];
  return tabBar;
}

@end
