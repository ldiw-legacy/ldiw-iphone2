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
#define kCompositionElementHeight 100.0f
#define kCheckButtonSize 20.0f

@implementation CompositionView
@synthesize tickButtonArray, field, delegate;

- (id)initWithField:(WPField *)aField {
  self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
  if (self) {
    [self setField:aField];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kContentWidth, 0)];
    [bg setBackgroundColor:kWPFieldFGColor];
    bg.layer.cornerRadius = 5;
    bg.layer.masksToBounds = YES;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingFromSide, kTopPadding, kContentWidth, kCheckButtonSize)];
    [nameLabel setText:field.label];
    [bg addSubview:nameLabel];
    
    [self addSubviewToBottom:bg];

    [self addAllowedValueViews];
  }
  return self;
}

- (void)addAllowedValueViews {
  
  NSArray *valuesArray = [[Database sharedInstance] allowedValuesForField:self.field];
  [self setTickButtonArray:[NSMutableArray array]];
  
  for (int i = 0; i < [valuesArray count]; i++) {
    AllowedValue *value = [valuesArray objectAtIndex:i];
    NSString *allowedValueValue = value.value;

    UIView *gridElement = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, kCompositionElementHeight)];

    CGRect labelRect = CGRectMake(kContentPaddingFromSide, 0, gridElement.frame.size.width - kCheckButtonSize - 2 * kContentPaddingFromSide, gridElement.frame.size.height);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:labelRect];
    [nameLabel setNumberOfLines:0];
    [nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [nameLabel setText:allowedValueValue];
    [nameLabel setFont:[UIFont fontWithName:kFontName size:kWPLabelTextSize]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [gridElement addSubview:nameLabel];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonRect = CGRectMake(gridElement.frame.size.width - kCheckButtonSize - kContentPaddingFromSide, gridElement.frame.size.height / 2 - (kCheckButtonSize / 2), kCheckButtonSize, kCheckButtonSize);
    [checkButton setFrame:buttonRect];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_active"] forState:UIControlStateSelected];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"tick_inactive"] forState:UIControlStateNormal];
    [checkButton setTag:i];
    [checkButton addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tickButtonArray addObject:checkButton];
    [gridElement addSubview:checkButton];    
    [self addViewToGrid:gridElement];
  }
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
