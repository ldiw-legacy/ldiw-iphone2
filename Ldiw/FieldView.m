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

@implementation FieldView
@synthesize wastePointField, delegate;

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
    [nameLabel setFont:[UIFont fontWithName:kFontNameBold size:kWPLabelTextSize]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [bg addSubview:nameLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kDescriptionTopPadding, kLabelTextLength, kWPDescripttionTextSize)];
    [descriptionLabel setText:field.edit_instructions];
    [descriptionLabel setFont:[UIFont fontWithName:kFontName size:kWPDescripttionTextSize]];
    [descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [bg addSubview:descriptionLabel];
    
    UIButton *addDataBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_normal"] forState:UIControlStateNormal];
    [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_pressed"] forState:UIControlStateSelected];
    [addDataBtn addTarget:self action:@selector(addDataPressed) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubviewToRightBottomCorner:addDataBtn withPadding:kContentPaddingFromSide];
    
    if ([field.typicalValue count] > 0) {
      [self addTypicalValueFields];
    }
        //
    //        [checkButton setExclusiveTouch:YES];
    //
    //        [typicalValueView addSubview:tValueLabel];
    //        [typicalValueView addSubview:checkButton];
    //        [typicalValueView setUserInteractionEnabled:YES];
    //        [fieldView addSubview:typicalValueView];
    //        subStartHeight += kTValueHeight;
    //        tValueCounter++;
    //      }

    
    }
  return self;
}

- (void)addTypicalValueFields {
  
  
  UIView *typicalValueView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kContentPaddingFromSide, kContentWidth, 0)];
  NSArray *tvArray = [[Database sharedInstance] typicalValuesForField:self.wastePointField];

  for (int i = 0; i < [tvArray count]; i++) {
    TypicalValue *tValue = [tvArray objectAtIndex:i];
    UILabel *tValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, 0, kLabelTextLength, kTValueHeight)];
    [tValueLabel setText:tValue.key];
    [tValueLabel setFont:[UIFont fontWithName:kFontName size:kWPLabelTextSize]];
    [tValueLabel setBackgroundColor:[UIColor clearColor]];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame:CGRectMake(0, 0, 20, 20)];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_active"] forState:UIControlStateSelected];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_inactive"] forState:UIControlStateNormal];
    [checkButton setTag:i];
    [checkButton addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [typicalValueView addSubviewToBottom:tValueLabel];
    [typicalValueView addSubviewToRightBottomCorner:checkButton withRightPadding:kCheckmarkPadding andBottomPadding:kTopPadding];

  }
  [self addSubviewToBottom:typicalValueView];
}

- (void)addDataPressed {
  [delegate addDataPressedForField:self.wastePointField.field_name];
}

- (void)checkPressed:(UIButton *)sender {
  NSArray *tvArray = [[Database sharedInstance] typicalValuesForField:self.wastePointField];
  TypicalValue *tValue = [tvArray objectAtIndex:sender.tag];
  NSString *value = tValue.value;
  [delegate checkedValue:value forField:self.wastePointField.field_name];
}

@end
