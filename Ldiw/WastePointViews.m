//
//  WastePointViews.m
//  Ldiw
//
//  Created by Timo Kallaste on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePointViews.h"
#import "Database+WPField.h"
#import "TypicalValue.h"
#import "WPField.h"

#define kTValueHeight 40.0f
#define kWPFieldHeight 58.0f

#define kContentWidth 300.0f
#define kLabelTextLength 230.0f
#define kContentPaddingFromLeft 10.0f

@implementation WastePointViews

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (id)initWithWastePoint:(WastePoint *)wp
{
  UIView *baseView = [[UIView alloc] init];
  NSArray *wpFields = [[Database sharedInstance] listAllWPFields];
  CGFloat height = 0.0;
  int counter = 0;
  CGFloat currentHeight = 0.0;
  CGFloat startHeight = 0.0;
  
  for (WPField *wpField in wpFields) {
    if (wpField.label) {
      UIView *fieldView;
      
      if (counter == 0) {
        currentHeight = kWPFieldHeight + [wpField.typicalValue allObjects].count * kTValueHeight;
        height = currentHeight;
        fieldView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, 5 , kContentWidth, currentHeight)];
        startHeight = 5;
      } else {
        startHeight = height;
        currentHeight = kWPFieldHeight + [wpField.typicalValue allObjects].count * kTValueHeight;
        fieldView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, startHeight, kContentWidth, currentHeight)];
        height += currentHeight;
      }
      [fieldView setBackgroundColor:kWPFieldBgColor];
      
      UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, 5, kLabelTextLength, 30)];
      [nameLabel setText:wpField.label];
      [nameLabel setFont:[UIFont fontWithName:kFontNameBold size:kWPLabelTextSize]];
      [nameLabel setBackgroundColor:[UIColor clearColor]];
      
      UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, 27, kLabelTextLength, 25)];
      [descriptionLabel setText:wpField.edit_instructions];
      [descriptionLabel setFont:[UIFont fontWithName:kFontName size:kWPDescripttionTextSize]];
      [descriptionLabel setBackgroundColor:[UIColor clearColor]];
      
      UIButton *addDataBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 32, 32)];
      [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_normal@2x"] forState:UIControlStateNormal];
      [addDataBtn setImage:[UIImage imageNamed:@"plus_btn_pressed@2x"] forState:UIControlStateSelected];
      [fieldView addSubview:nameLabel];
      [fieldView addSubview:descriptionLabel];
      [fieldView addSubview:addDataBtn];
      
      int tValueCounter = 0;
      CGFloat subStartHeight = kWPFieldHeight;
      for (TypicalValue *tValue in [wpField.typicalValue allObjects]) {
        UIView *typicalValueView = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, subStartHeight, kContentWidth, kTValueHeight)];
        UILabel *tValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, 5, kLabelTextLength, 20)];
        [tValueLabel setText:tValue.value];
        [tValueLabel setFont:[UIFont fontWithName:kFontName size:13]];
        [tValueLabel setBackgroundColor:[UIColor clearColor]];
        [typicalValueView addSubview:tValueLabel];
        [fieldView addSubview:typicalValueView];
        subStartHeight += kTValueHeight;
        tValueCounter++;
      }
      [baseView addSubview:fieldView];
      counter++;
    }
  }
  self = [super initWithFrame:CGRectMake(0, 0, 320, height)];
  if (self) {
    // Initialization code
    [self addSubview:baseView];
  }
  return self;
}

@end
