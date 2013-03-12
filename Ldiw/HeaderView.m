//
//  HeaderView.m
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "HeaderView.h"
#import "DesignHelper.h"


#define kButtonPadding 10.0
@implementation HeaderView
@synthesize nearbyButton,friendsButton,showMapButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feed_subtab_bg"]];
      UIImage *leftSegment = [UIImage imageNamed:@"subtab_left_normal"];
      UIImage *middleSegment = [UIImage imageNamed:@"subtab_middle_normal"];
      UIImage *rightSegment = [UIImage imageNamed:@"subtab_right_normal"];
      UIImage *selectedleftSegment = [UIImage imageNamed:@"subtab_left_pressed"];
   //   UIImage *selectedmiddleSegment = [UIImage imageNamed:@"subtab_middle_pressed"];
      UIImage *selectedrightSegment = [UIImage imageNamed:@"subtab_right_pressed"];
      
      self.nearbyButton = [UIButton buttonWithType:UIButtonTypeCustom];
      self.friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
      self.showMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
      
      self.nearbyButton.frame = CGRectMake( kButtonPadding + middleSegment.size.width/2, kButtonPadding, leftSegment.size.width, leftSegment.size.height );
      [self.nearbyButton setBackgroundImage:leftSegment forState:UIControlStateNormal];
      [self.nearbyButton setBackgroundImage:selectedleftSegment forState:UIControlStateSelected];
      [self.nearbyButton setTitle:NSLocalizedString(@"activities.nearbyButton", nil) forState:UIControlStateNormal];
      [DesignHelper setUpHeaderViewButton:self.nearbyButton];


      //Removed Friends button temporary
      /*
     self.friendsButton.frame = CGRectMake( kButtonPadding + leftSegment.size.width, kButtonPadding, middleSegment.size.width, middleSegment.size.height );
      [self.friendsButton setTitle:NSLocalizedString(@"activities.friendsButton", nil) forState:UIControlStateNormal];
      [self.friendsButton setBackgroundImage:middleSegment forState:UIControlStateNormal];
      [self.friendsButton setBackgroundImage:selectedmiddleSegment forState:UIControlStateSelected];
      [DesignHelper setUpHeaderViewButton:self.friendsButton];
       */
      
      self.showMapButton.frame = CGRectMake(kButtonPadding + leftSegment.size.width +middleSegment.size.width/2, kButtonPadding, rightSegment.size.width, rightSegment.size.height);
      [self.showMapButton setTitle:NSLocalizedString(@"activities.showMapButton", nil) forState:UIControlStateNormal];
      [DesignHelper setUpHeaderViewButton:self.showMapButton];
      [self.showMapButton setBackgroundImage:rightSegment forState:UIControlStateNormal];
      [self.showMapButton setBackgroundImage:selectedrightSegment forState:UIControlStateSelected];
      [self addSubview:nearbyButton];
     // [self addSubview:friendsButton];
      [self addSubview:showMapButton];
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

@end
