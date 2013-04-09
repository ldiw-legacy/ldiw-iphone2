//
//  SuccessView.m
//  Ldiw
//
//  Created by sander on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "SuccessView.h"
#import "DesignHelper.h"

@implementation SuccessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor=[UIColor clearColor];
      UIView *dimView = [[UIView alloc] initWithFrame:frame];
      dimView.backgroundColor = [UIColor blackColor];
      [self addSubview:dimView];
      dimView.alpha = 0;
      [UIView animateWithDuration:0.5
                       animations:^{dimView.alpha = 0.75;}
                       completion:^(BOOL finished) {
                         UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ldiw_popup"]];
                         back.frame = CGRectMake(30, 90, 260, 320);
                         [self addSubview:back];
                         UIImageView *badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b_social"]];
                         badge.frame = CGRectMake(61, 30, 137, 137);
                         [back addSubview:badge];
                         CGRect labelFrame = CGRectMake(0, 177, 260, 30);
                         UILabel *successLabel = [[UILabel alloc]initWithFrame:labelFrame];
                         successLabel.text = NSLocalizedString(@"success", nil);
                         successLabel.font = [UIFont fontWithName:@"Caecilia-Heavy" size:24];
                         successLabel.textColor = [UIColor blackColor];
                         successLabel.textAlignment = UITextAlignmentCenter;
                         [back addSubview:successLabel];
                         CGRect infoRect = CGRectMake(0, 207, 260, 30);
                         UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoRect];
                         infoLabel.text = NSLocalizedString(@"success.newwastepoint", nil);
                         infoLabel.textAlignment = UITextAlignmentCenter;
                         infoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
                         infoLabel.textColor = [UIColor colorWithRed:0.58 green:0.588 blue:0.545 alpha:1];
                         [back addSubview:infoLabel];
                         
                         CGRect buttonFrame = CGRectMake(40, 356, 240, 44);
                         UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                     continueButton.frame=buttonFrame;
                         [continueButton setBackgroundImage:[UIImage imageNamed:@"black_btn"] forState:UIControlStateNormal];
                         [continueButton setBackgroundImage:[UIImage imageNamed:@"black_btn"] forState:UIControlStateHighlighted];
                         [continueButton setTitle:NSLocalizedString(@"continue", nil) forState:UIControlStateNormal];
                         [DesignHelper setLoginButtonTitle:continueButton];
                         [continueButton addTarget:self action:@selector(continuePressed:) forControlEvents:UIControlEventTouchUpInside];
                         [self addSubview:continueButton];
                                                  
                       }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)continuePressed:(id)sender
{
  self.controller.navigationController.navigationBarHidden = NO;
  self.controller.tabBarController.tabBar.hidden = NO;
  [self removeFromSuperview];
}


@end
