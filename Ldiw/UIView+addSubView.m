//
//  UIView+addSubView.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "UIView+addSubView.h"

@implementation UIView (addSubView)

- (void)addSubviewToBottom:(UIView *)subView {
  [self increaseFrameHeightBy:subView.frame.size.height];
  [subView setFrame:CGRectMake(subView.frame.origin.x, self.frame.size.height - subView.frame.size.height, subView.frame.size.width, subView.frame.size.height)];
  [self addSubview:subView];
}

- (void)addSubviewToRightBottomCorner:(UIView *)subView withRightPadding:(int)rightPadding andBottomPadding:(int)bottomPadding {
  [subView setFrame:CGRectMake(self.frame.size.width - subView.frame.size.width - rightPadding, self.frame.size.height - subView.frame.size.height - bottomPadding, subView.frame.size.width, subView.frame.size.height)];
  [self addSubview:subView];

}

- (void)addSubviewToRightBottomCorner:(UIView *)subView withPadding:(int)padding {
  [self addSubviewToRightBottomCorner:subView withRightPadding:padding andBottomPadding:padding];
}

- (void)increaseFrameHeightBy:(int)amount {
  CGRect oldFrame = self.frame;
  CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height + amount);
  [self setFrame:newFrame];
}

@end
