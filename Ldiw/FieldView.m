//
//  FieldView.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/27/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FieldView.h"
#import "TypicalValue.h"
#import "UIView+addSubView.h"
#import "Database+WPField.h"

#define kTValueHeight 35.0f
#define kWPFieldHeight 58.0f
#define kTopPadding 5.0f
#define kContentPaddingFromSide 10.0f
#define kLabelTextLength 230.0f
#define kDescriptionTopPadding 32.0f
#define kCheckmarkPadding 13.0f
#define kContentWidth 300.0f
#define kButtonContentWidth 320.0f

@implementation FieldView
@synthesize wastePointField, delegate, tickButtonArray, valueLabel;

- (id)initWithWPField:(WPField *)field {  

  CGRect frame = CGRectMake(0, 0, 320, kWPFieldHeight);
  self = [super initWithFrame:frame];
  if (self) {
    [self setWastePointField:field];
    [self setBackgroundColor:kWPFieldBgColor];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kContentWidth, kWPFieldHeight - kTopPadding)];
    [bg setBackgroundColor:kWPFieldFGColor];
    bg.layer.cornerRadius = 5;
    bg.layer.masksToBounds = YES;
    [self addSubview:bg];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kLabelTextLength, 30)];
    [nameLabel setText:field.label];
    [nameLabel setFont:[UIFont fontWithName:kCustomFont size:kWPLabelTextSize]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [bg addSubview:nameLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kDescriptionTopPadding, kLabelTextLength, kWPDescripttionTextSize)];
    [descriptionLabel setText:field.edit_instructions];
    [descriptionLabel setFont:[UIFont fontWithName:kFontName size:kWPDescripttionTextSize]];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionLabel setTextColor:kFieldDescriptionTextColor];
    [self setValueLabel:descriptionLabel];
    [bg addSubview:descriptionLabel];
    
    if (!field.allowedValues.count > 0) {
      UIButton *addDataBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
      [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_normal"] forState:UIControlStateNormal];
      [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_pressed"] forState:UIControlStateSelected];
      [addDataBtn addTarget:self action:@selector(addDataPressed) forControlEvents:UIControlEventTouchUpInside];
      [bg addSubviewToRightBottomCorner:addDataBtn withPadding:kContentPaddingFromSide];
    }
    
    
    if ([field.typicalValues count] > 0 || [field.allowedValues count] > 0) {
      [self addTypicalValueFields];
    }
    
  }
  return self;
}

- (void)addTypicalValueFields {
  UIView *typicalValueView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kContentPaddingFromSide, kButtonContentWidth, 0)];
  NSArray *tvArray = [[Database sharedInstance] typicalValuesForField:self.wastePointField];
  [self setTickButtonArray:[NSMutableArray array]];

  for (int i = 0; i < [tvArray count]; i++) {
    TypicalValue *tValue = [tvArray objectAtIndex:i];
    UILabel *tValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, 0, kLabelTextLength, kTValueHeight)];
    [tValueLabel setText:tValue.key];
    [tValueLabel setFont:[UIFont fontWithName:kFontName size:kWPLabelTextSize]];
    [tValueLabel setBackgroundColor:[UIColor clearColor]];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame:CGRectMake(0, 0, kContentWidth, tValueLabel.frame.size.height)];
    [checkButton setImage:[UIImage imageNamed:@"tick_active_wide"] forState:UIControlStateSelected];
    [checkButton setImage:[UIImage imageNamed:@"tick_inactive_wide"] forState:UIControlStateNormal];
    checkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    checkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [checkButton setTag:i];
    [checkButton addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    [tickButtonArray addObject:checkButton];
    [typicalValueView addSubviewToBottom:tValueLabel];
    [typicalValueView addSubviewToRightBottomCorner:checkButton withRightPadding:kCheckmarkPadding andBottomPadding:0];

  }
  [self addSubviewToBottom:typicalValueView];
}

- (void)addDataPressed {
  [delegate addDataPressedForField:self.wastePointField.field_name];
}

-(void) deselctAllTics {
  for (UIButton *button in tickButtonArray) {
    [button setSelected:NO];
  }
}

- (void)checkPressed:(UIButton *)sender {
  [self deselctAllTics];
  [sender setSelected:YES];
  
  NSArray *tvArray = [[Database sharedInstance] typicalValuesForField:self.wastePointField];
  TypicalValue *tValue = [tvArray objectAtIndex:sender.tag];
  NSString *value = tValue.value;
  [delegate checkedValue:value forField:self.wastePointField.field_name];
}

- (void)setValue:(NSString *)value {
  if (!self.wastePointField.allowedValues.count > 0) {
    [valueLabel setText:value];
    [valueLabel setTextColor:[UIColor darkGrayColor]];
  }
  
}

@end
