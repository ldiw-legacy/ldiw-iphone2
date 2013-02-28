#import "WPField.h"
#define kCompositionString @"composition_"
@implementation WPField

// Custom logic goes here.

- (BOOL)isCompositionField:(BOOL)composition {
  NSString *fieldName = self.field_name;

  if (!fieldName) {
    fieldName = self.label;
  }
  
  BOOL fieldIsComposition = NO;
  
  NSRange compositionRange = [fieldName rangeOfString:kCompositionString];
  if (compositionRange.location != NSNotFound) {
    fieldIsComposition = YES;
  } else {
    fieldIsComposition = NO;
  }
  
  BOOL returnValue = (composition == fieldIsComposition);
  return returnValue;
}

@end
