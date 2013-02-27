//
//  TypicalValueView.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/27/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "TypicalValueView.h"

@implementation TypicalValueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  return self;
}
@end
