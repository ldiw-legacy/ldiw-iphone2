//
//  DesignHelper.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DesignHelper.h"
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
  button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
}

+(void)setLoginButtonTitle:(UIButton *)button
{
  [button setTitleColor:kHeaderButtonTitleColorSelected forState:UIControlStateHighlighted];
  button.titleLabel.font = [UIFont fontWithName:@"Caecilia-Heavy" size:18];
  
}

@end
