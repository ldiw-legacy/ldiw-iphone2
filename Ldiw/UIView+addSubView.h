//
//  UIView+addSubView.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (addSubView)

- (void)addSubviewToBottom:(UIView *)subView;
- (void)addSubviewToRightBottomCorner:(UIView *)subView withPadding:(int)padding;
- (void)addSubviewToRightBottomCorner:(UIView *)subView withRightPadding:(int)rightPadding andBottomPadding:(int)bottomPadding;
- (void)addViewToGrid:(UIView *)viewToAdd;
@end
