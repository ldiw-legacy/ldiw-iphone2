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
#import "CustomValue.h"

@implementation WastePointViews
@synthesize wastePoint, fieldDelegate, fieldsDictionary;

- (id)initWithWastePoint:(WastePoint *)wp andDelegate:(id)delegate {
  self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
  if (self) {
    [self setFieldsDictionary:[NSMutableDictionary dictionary]];
    [self setWastePoint:wp];
    [self setFieldDelegate:delegate];
    
    // If point has no, then let user edit fields
    if (wastePoint.id) {
      [self addNonCompFields];
    } else {
    // Else show only fields that have a value
      [self addOnlyFieldsWithData];
    }
//    [self addCompFields];
  }
  return self;
}

- (void)addOnlyFieldsWithData {
  for (CustomValue *value in wastePoint.customValues) {
    NSString *fieldname = value.fieldName;
    NSString *data = value.value;
    BOOL dataPresent = (![data isEqualToString:@"0"] && [data length] > 0);
    WPField *fieldToAdd = [[Database sharedInstance] findWPFieldWithFieldName:fieldname orLabel:nil];
    if (fieldToAdd && dataPresent) {
      FieldView *fieldView = [[FieldView alloc] initWithWPField:fieldToAdd forEditing:NO];
      [fieldView.valueLabel setText:data];
      [self addSubviewToBottom:fieldView];
    }
  }
}

- (void)addNonCompFields {
  
  NSArray *nonCompFields = [[Database sharedInstance] listAllWPFields];
  for (WPField *wpField in nonCompFields) {
    FieldView *field = [[FieldView alloc] initWithWPField:wpField];
    [field setDelegate:fieldDelegate];
    if (wpField.field_name) {
      [fieldsDictionary setObject:field forKey:wpField.field_name];
      [self addSubviewToBottom:field];
    }
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

- (void) deselectAllTicsForField:(NSString *)fieldname {
  FieldView *fieldView = (FieldView *)[fieldsDictionary objectForKey:fieldname];
  [fieldView deselctAllTics];
}

@end
