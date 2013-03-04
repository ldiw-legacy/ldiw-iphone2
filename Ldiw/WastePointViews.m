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
#import "CompositionView.h"

@implementation WastePointViews
@synthesize wastePoint, fieldDelegate, fieldsDictionary;

- (id)initWithWastePoint:(WastePoint *)wp andDelegate:(id)delegate {
  self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
  if (self) {
    [self setFieldsDictionary:[NSMutableDictionary dictionary]];
    [self setWastePoint:wp];
    [self setFieldDelegate:delegate];
    [self addNonCompFields];
    [self addCompFields];
  }
  return self;
}

- (void)addNonCompFields {
  
  NSArray *nonCompFields = [[Database sharedInstance] listAllNonCompositionFields];
  
  for (WPField *wpField in nonCompFields) {
    FieldView *field = [[FieldView alloc] initWithWPField:wpField];
    [field setDelegate:fieldDelegate];
    [fieldsDictionary setObject:field forKey:wpField.field_name];
    [self addSubviewToBottom:field];
  }
}

- (void)addCompFields {
  NSArray *compFields = [[Database sharedInstance] listAllCompositionFields];
  for (WPField *wpField in compFields) {
    CompositionView *compView = [[CompositionView alloc] initWithField:wpField];
    [compView setDelegate:fieldDelegate];
    [self addSubviewToBottom:compView];
  }
}

- (void)setValue:(NSString *)value forField:(NSString *)fieldname {
  FieldView *fieldView = (FieldView *)[fieldsDictionary objectForKey:fieldname];
  [fieldView setValue:value];
}

@end
