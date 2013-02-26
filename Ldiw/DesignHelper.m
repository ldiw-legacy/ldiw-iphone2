//
//  DesignHelper.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DesignHelper.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "AddNewWPViewController.h"

#define kbgCornerRadius 8.0


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

+(UIImage *)resizeImage:(UIImage *)image
{

  CGFloat originalWidth = image.size.width;
  CGFloat originalHeight = image.size.height;
  CGFloat ratio=originalWidth/originalHeight;
  CGFloat maxRatio=320.0/480.0;

  if (ratio != maxRatio) {
    if (ratio < maxRatio){
      ratio = 480 / originalHeight;
      originalWidth = ratio * originalWidth;
    }
    else {
      ratio=320.0/originalWidth;
      originalHeight=ratio * originalHeight;
      originalWidth=320.0;

    }

  }
  CGRect newRect =CGRectMake(0, 0, originalWidth, originalHeight);
  UIGraphicsBeginImageContext(newRect.size);
  [image drawInRect:newRect];
  UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
  
}

+(UIImage *)userIconImage:(UIImage *)image
{
  CGSize originalsize = [image size];
  CGRect newimagerect = CGRectMake(0, 0, 33, 33);
  float ratio = MAX (newimagerect.size.height/originalsize.height, newimagerect.size.width/originalsize.width);
  UIGraphicsBeginImageContextWithOptions(newimagerect.size, NO , 0.0);
  UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:newimagerect];
  [path addClip];
  CGRect projectRect;
  projectRect.size.width=ratio * originalsize.width;
  projectRect.size.height=ratio * originalsize.height;
  projectRect.origin.x = (newimagerect.size.width - projectRect.size.width) / 2.0;
  projectRect.origin.y = (newimagerect.size.height -projectRect.size.width) / 2.0;
  [image drawInRect:projectRect];
  UIImage *userIconImage=UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return userIconImage;
 
  
}


+(UITabBarController*) createActivityView {
  MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
  AddNewWPViewController *newWP = [[AddNewWPViewController alloc] initWithNibName:@"AddNewWPViewController" bundle:nil];
  ActivityViewController *activityVC= [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
  UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:activityVC];
  
  UITabBarController *tabBar = [[UITabBarController alloc] init];
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]]];

  [tabBar setViewControllers:[NSArray arrayWithObjects:navVC, mainViewController, newWP, nil]];
  return tabBar;
}

@end
