//
//  DesignHelper.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DesignHelper.h"
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "AccountViewController.h"

#define kbgCornerRadius 8.0
#define kTabBarTitlePositionAdjustment 8.0
#define kBoldThemeFont @"HelveticaNeue-Bold"


#define kHeaderButtonTitleColorNormal [UIColor darkGrayColor]
#define kHeaderButtonTitleColorSelected [UIColor whiteColor]
#define kHeaderButtonTitleShadowColor [UIColor darkGrayColor]
@implementation DesignHelper

+(void)setUpHeaderViewButton:(UIButton *)button
{
  [button setTitleColor:kHeaderButtonTitleColorSelected forState:UIControlStateSelected];
  [button setTitleColor:kHeaderButtonTitleColorNormal forState:UIControlStateNormal];
  [button setTitleShadowColor:kHeaderButtonTitleShadowColor forState:UIControlStateSelected];
  [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  button.titleLabel.shadowOffset = CGSizeMake (0,1);
  button.titleLabel.shadowColor = kHeaderButtonTitleShadowColor;
  button.titleLabel.font = [UIFont fontWithName:kBoldThemeFont size:13];
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
  label.backgroundColor = [UIColor clearColor];
}

+(void)setActivityViewNametitle:(UILabel *)label
{
  label.font=[UIFont fontWithName:kBoldThemeFont size:14];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
}

+(void)setActivityViewActiontitle:(UILabel *)label
{
  label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
}

+(void)setActivityViewLocationtitle:(UILabel *)label
{
  
}

+ (void)setNavigationTitleStyle:(UILabel *)label
{
  label.font = [UIFont fontWithName:@"Caecilia-Heavy" size:18];
  label.textColor = [UIColor whiteColor];
  label.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
  label.shadowOffset = CGSizeMake (0,1);
  label.backgroundColor = [UIColor clearColor];
  label.textAlignment = UITextAlignmentCenter;
}

+ (void) setBarButtonTitleAttributes:(UIButton *)button
{
  button.titleLabel.textColor = [UIColor whiteColor];
  button.titleLabel.font = [UIFont fontWithName:kBoldThemeFont size:12];
  button.titleLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
  button.titleLabel.shadowOffset = CGSizeMake (0,1);
}

+(UIImage *)wastePointImage:(UIImage *)image
{
  CGSize originalsize = [image size];
  CGRect newimagerect = CGRectMake(0, 0, 300, 100);
  CGRect strokerect = CGRectMake(1, 1, 298, 98);
  float ratio = MAX (newimagerect.size.height/originalsize.height, newimagerect.size.width/originalsize.width);
  
  UIGraphicsBeginImageContextWithOptions(newimagerect.size, NO , 0.0);
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newimagerect cornerRadius:kbgCornerRadius];
  UIBezierPath *strokepath=[UIBezierPath bezierPathWithRoundedRect:strokerect cornerRadius:kbgCornerRadius];
  [path addClip];
  
  CGRect projectRect;
  projectRect.size.width=ratio * originalsize.width;
  projectRect.size.height=ratio * originalsize.height;
  projectRect.origin.x = (newimagerect.size.width - projectRect.size.width) / 2.0;
  projectRect.origin.y = (newimagerect.size.height -projectRect.size.width) / 2.0;
  [image drawInRect:projectRect];
  strokepath.lineWidth = 2;
  [[UIColor whiteColor] setStroke];
  [strokepath stroke];
  
  UIImage *wastePointImage=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return wastePointImage;
  
}

+(UIImage *)resizeImage:(UIImage *)image {
  CGFloat originalWidth = image.size.width;
  
  if (originalWidth <= 480) {
    return image;
  }
  
  CGFloat originalHeight = image.size.height;
  
  CGFloat timesTooBig = originalWidth/480.0f;
  originalWidth = originalWidth/timesTooBig;
  originalHeight = originalHeight/timesTooBig;
  
  CGRect newRect = CGRectMake(0, 0, originalWidth, originalHeight);
  UIGraphicsBeginImageContext(newRect.size);
  [image drawInRect:newRect];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+(UIImage *)userIconImage:(UIImage *)image {
  CGSize originalsize = [image size];
  CGRect newimagerect = CGRectMake(0, 0, 33, 33);
  float ratio = MAX (newimagerect.size.height/originalsize.height, newimagerect.size.width/originalsize.width);
  UIGraphicsBeginImageContextWithOptions(newimagerect.size, NO , 0.0);
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:newimagerect];
  [path addClip];
  CGRect projectRect;
  projectRect.size.width = ratio * originalsize.width;
  projectRect.size.height = ratio * originalsize.height;
  projectRect.origin.x = (newimagerect.size.width - projectRect.size.width) / 2.0;
  projectRect.origin.y = (newimagerect.size.height - projectRect.size.width) / 2.0;
  [image drawInRect:projectRect];
  UIImage *userIconImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return userIconImage;
}

+(UITabBarController*) createTabBarController {
  DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
  AccountViewController *accountVC = [[AccountViewController alloc] initWithNibName:nil bundle:nil];
  ActivityViewController *activityVC = [[ActivityViewController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:activityVC];
  UINavigationController *accountNavVC = [[UINavigationController alloc] initWithRootViewController:accountVC];
  
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"titlebar_bg"] forBarMetrics:UIBarMetricsDefault];
  //[[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]]];
  
  [tabBarController setViewControllers:[NSArray arrayWithObjects:navVC, detailViewController, accountNavVC, nil]];
  
  UITabBar *tabbar = tabBarController.tabBar;
  tabbar.clipsToBounds = NO;
  
  UIImage *selectedImage0 = [UIImage imageNamed:@"tab_feed_pressed"];
  UIImage *unselctedImage0 = [UIImage imageNamed:@"tab_feed_normal"];
  
  UIImage *selectedImage1 = [UIImage imageNamed:@"tab_addpoint_pressed"];
  UIImage *unselctedImage1 = [UIImage imageNamed:@"tab_addpoint_normal"];
  
  UIImage *selectedImage2 = [UIImage imageNamed:@"tab_account_pressed"];
  UIImage *unselctedImage2 = [UIImage imageNamed:@"tab_account_normal"];
  
  UITabBarItem *item0 = [tabbar.items objectAtIndex:0];
  UITabBarItem *item1 = [tabbar.items objectAtIndex:1];
  UITabBarItem *item2 = [tabbar.items objectAtIndex:2];
  [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselctedImage0];
  [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselctedImage1];
  [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselctedImage2];
  
  
  item0.titlePositionAdjustment = UIOffsetMake(0, -kTabBarTitlePositionAdjustment);
  item1.titlePositionAdjustment = UIOffsetMake(0, -kTabBarTitlePositionAdjustment);
  item2.titlePositionAdjustment = UIOffsetMake(0, -kTabBarTitlePositionAdjustment);
  item0.title = NSLocalizedString(@"tabBar.activityTabName", nil);
  item1.title = NSLocalizedString(@"tabBar.newPointTabText", nil);
  item2.title = NSLocalizedString(@"tabBar.myAccountTabText", nil);
  
  return tabBarController;
}

@end
