//
//  WastePointViews.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePointViews.h"
#import "Database+WPField.h"
#import "UIView+addSubView.h"
#import "TypicalValue.h"
#import "WPField.h"
#import "FieldView.h"

@implementation WastePointViews
@synthesize wastePoint;

- (id)initWithWastePoint:(WastePoint *)wp {
  self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
  if (self) {
    [self setWastePoint:wp];
    [self configureView];
  }
  return self;
}

- (void)configureView {
  
  NSArray *nonCompFields = [[Database sharedInstance] listAllNonCompositionFields];
  
  for (WPField *wpField in nonCompFields) {
    FieldView *field = [[FieldView alloc] initWithWPField:wpField];
    [self addSubviewToBottom:field];
  }
}

- (void)check:(UIButton *)sender {
  MSLog(@"CHECKED button %@", sender);
}

@end
