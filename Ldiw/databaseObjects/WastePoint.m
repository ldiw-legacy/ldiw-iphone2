#import "WastePoint.h"
#import "CustomValue.h"
#import "Database.h"
#import "Database+WP.h"
#import "Database+WPField.h"
#import "WPField.h"

@implementation WastePoint


-(long) capInt:(long)num from:(long)min toMax:(long)max {
  
  if (num >= max) {
    num = max;
  } else if (num <= min) {
    num = min;
  }
  return num;
}


-(double) capFloat:(double)num from:(double)min toMax:(double)max {
  if (num >= max) {
    num = max;
  } else if (num <= min) {
    num = min;
  }
  return num;
}



// Custom logic goes here.
- (NSString*)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName {
  
  WPField *wpF = [[Database sharedInstance] findWPFieldWithFieldName:fieldName orLabel:nil];
  if (wpF.min || wpF.max) {
    
    if ([wpF.type isEqualToString:@"integer"]) {
      int num = [newValue intValue];
      num = [self capInt:num from:wpF.minValue toMax:wpF.maxValue];
      newValue = [NSString stringWithFormat:@"%d", num];
    } else if ([wpF.type isEqualToString:@"float"]) {
      double num = [newValue doubleValue];
      num = [self capFloat:num from:[wpF.min doubleValue] toMax:[wpF.max doubleValue]];
      
      NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
      [nf setMaximumFractionDigits:5];
      newValue = [nf stringFromNumber:[NSNumber numberWithDouble:num]];
    }

  }
  
  
  
  for (CustomValue* value in self.customValues) {
    if ([value.fieldName isEqualToString:fieldName]) {
      MSLog(@"Change value for field '%@' to '%@'", fieldName, newValue);
      [value setValue:newValue];
      return newValue;
    }
  }
  CustomValue *value = [[Database sharedInstance] customValueWithKey:fieldName andValue:newValue];
  [self addCustomValuesObject:value];
  MSLog(@"Added new customValue '%@' to point", fieldName);
  return newValue;
}

- (NSString *)description {
  NSString *returnString = [NSString stringWithFormat:@"id = %d\nlat = %f\nlon = %f\nnrPhotos = %d", self.idValue, self.latitudeValue, self.longitudeValue, [self.images count]];
  NSMutableString *customValuesString = [NSMutableString string];
  
  for (CustomValue *value in self.customValues) {
    [customValuesString appendString:[NSString stringWithFormat:@"%@ = %@\n", value.fieldName, value.value]];
  }
  return [NSString stringWithFormat:@"%@\n%@", returnString, customValuesString];
}

@end
