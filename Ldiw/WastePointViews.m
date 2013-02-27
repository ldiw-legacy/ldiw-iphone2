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
#import "TypicalValueView.h"
#import "WPField.h"

#define kTValueHeight 40.0f
#define kWPFieldHeight 58.0f

#define kContentWidth 300.0f
#define kLabelTextLength 230.0f
#define kContentPaddingFromLeft 10.0f

@implementation WastePointViews

@synthesize checkArray;

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
  [baseView setUserInteractionEnabled:NO];
  NSArray *wpFields = [[Database sharedInstance] listAllWPFields];
  CGFloat height = 0.0;
  int counter = 0;
  CGFloat currentHeight = 0.0;
  CGFloat startHeight = 0.0;
  checkArray = [NSMutableArray array];
  for (WPField *wpField in wpFields) {
    if (wpField.label) {
      UIView *fieldView;
      [fieldView setUserInteractionEnabled:NO];
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
      
      UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 5 , kContentWidth, kWPFieldHeight)];
      [bg setBackgroundColor:[UIColor grayColor]];
      [fieldView addSubview:bg];
      
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
      [bg addSubview:addDataBtn];
      
      int tValueCounter = 0;
      CGFloat subStartHeight = kWPFieldHeight;
      NSArray *sortedArray;

      sortedArray = [[wpField.typicalValue allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(TypicalValue*)a value];
        NSString *second = [(TypicalValue*)b value];
        return [first compare:second options:NSNumericSearch];
      }];
      
      for (TypicalValue *tValue in sortedArray) {
        TypicalValueView *typicalValueView = [[TypicalValueView alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, subStartHeight, kContentWidth, kTValueHeight)];
        UILabel *tValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromLeft, 5, kLabelTextLength, 25)];
        [tValueLabel setText:tValue.value];
        [tValueLabel setFont:[UIFont fontWithName:kFontName size:15]];
        [tValueLabel setBackgroundColor:[UIColor clearColor]];
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton setFrame:CGRectMake(220, 5, 30, 30)];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_active@2x"] forState:UIControlStateSelected];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_inactive@2x"] forState:UIControlStateNormal];
        [checkButton setTag:counter * 100 + tValueCounter];
        [checkButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        [checkButton setExclusiveTouch:YES];
        [checkArray addObject:checkButton];
        
        [typicalValueView addSubview:tValueLabel];
        [typicalValueView addSubview:checkButton];
        [typicalValueView setUserInteractionEnabled:YES];
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
    [self setUserInteractionEnabled:NO];
  }
  return self;
}

- (void)check:(id)sender {
  MSLog(@"CHECKED!");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

  return self;
}
@end
