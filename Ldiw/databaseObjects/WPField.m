#import "WPField.h"
#define kCompositionString @"composition"
@implementation WPField

// Custom logic goes here.

- (BOOL)isCompositionField:(BOOL)composition {
//  return NO;
  NSString *fieldName = self.field_name;
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
