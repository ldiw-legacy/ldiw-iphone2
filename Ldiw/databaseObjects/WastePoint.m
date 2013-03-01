#import "WastePoint.h"
#import "CustomValue.h"
#import "Database.h"
#import "Database+WP.h"

@implementation WastePoint

// Custom logic goes here.
- (void)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName {
  for (CustomValue* value in self.customValues) {
    if ([value.fieldName isEqualToString:fieldName]) {
      MSLog(@"Change value for field '%@' to '%@'", fieldName, newValue);
      [value setValue:newValue];
      return;
    }
  }
  CustomValue *value = [[Database sharedInstance] customValueWithKey:fieldName andValue:newValue];
  [self addCustomValuesObject:value];
  MSLog(@"Added new customValue '%@' to point", fieldName);
}

- (NSString *)description {
  NSString *returnString = [NSString stringWithFormat:@"id = %d\nlat = %f\nlon = %f\nphotos = %@", self.idValue, self.latitudeValue, self.longitudeValue, self.photos];
  NSMutableString *customValuesString = [NSMutableString string];
  
  for (CustomValue *value in self.customValues) {
    [customValuesString appendString:[NSString stringWithFormat:@"%@ = %@\n", value.fieldName, value.value]];
  }
  return [NSString stringWithFormat:@"%@\n%@", returnString, customValuesString];
}

@end
