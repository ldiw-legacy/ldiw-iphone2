//
//  CompositionView.m
//  Ldiw
//
//  Created by Lauri Eskor on 3/1/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CompositionView.h"
#import "AllowedValue.h"
#import "UIView+addSubView.h"
#import "Database+WPField.h"

#define kContentPaddingFromSide 10.0f
#define kTopPadding 5.0f
#define kContentWidth 300.0f
#define kLabelTextLength 230.0f
#define kCompositionElementHeight 100.0f
#define kCheckButtonSize 20.0f
#define kLabelHeight 38.0f
#define kCheckmarkPadding 13.0f


@implementation CompositionView
@synthesize tickButtonArray, field, delegate;

- (id)initWithField:(WPField *)aField {
  self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
  if (self) {
    [self setField:aField];
    [self setupView];
    [self addAllowedValueViews];
  }
  return self;
}

- (void) setupView {
  UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kContentWidth, 0)];
  [bg setBackgroundColor:kWPFieldFGColor];
  bg.layer.cornerRadius = 5;
  bg.layer.masksToBounds = YES;
  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kContentWidth, kLabelHeight)];
  [nameLabel setText:field.label];
  [nameLabel setFont:[UIFont fontWithName:kCustomFont size:kWPLabelTextSize]];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [bg addSubviewToBottom:nameLabel];
  [self addSubviewToBottom:bg];
}

- (void)addAllowedValueViews {
  
  NSArray *valuesArray = [[Database sharedInstance] allowedValuesForField:self.field];
  [self setTickButtonArray:[NSMutableArray array]];
  
  UIView *typicalValueView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kContentPaddingFromSide, kContentWidth, 0)];
  
  for (int i = 0; i < [valuesArray count]; i++) {
    AllowedValue *value = [valuesArray objectAtIndex:i];
    
    UILabel *tValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, 0, kLabelTextLength, kLabelHeight)];
    [tValueLabel setText:value.value];
    [tValueLabel setFont:[UIFont fontWithName:kCustomFont size:kWPLabelTextSize]];
    [tValueLabel setBackgroundColor:[UIColor clearColor]];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame:CGRectMake(0, 0, 20, 20)];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_active"] forState:UIControlStateSelected];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_inactive"] forState:UIControlStateNormal];
    [checkButton setTag:i];
    [checkButton addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tickButtonArray addObject:checkButton];
    [typicalValueView addSubviewToBottom:tValueLabel];
    [typicalValueView addSubviewToRightBottomCorner:checkButton withRightPadding:kCheckmarkPadding andBottomPadding:kTopPadding];
  }
  [self addSubviewToBottom:typicalValueView];
}

- (void)checkPressed:(UIButton *)sender {
  for (UIButton *button in tickButtonArray) {
    [button setSelected:NO];
  }
  [sender setSelected:YES];
  
  NSArray *valuesArray = [[Database sharedInstance] allowedValuesForField:self.field];
  AllowedValue *allowedValue = [valuesArray objectAtIndex:sender.tag];
  NSString *value = allowedValue.value;
  [delegate checkedValue:value forField:self.field.field_name];
}

@end
