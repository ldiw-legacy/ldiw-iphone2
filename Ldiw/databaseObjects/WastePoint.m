#import "WastePoint.h"
#import "CustomValue.h"
@implementation WastePoint

// Custom logic goes here.

- (NSString *)description {
  NSString *returnString = [NSString stringWithFormat:@"id = %d\nlat = %f\nlon = %f\nphotos = %@", self.idValue, self.latitudeValue, self.longitudeValue, self.photos];
  NSMutableString *customValuesString = [NSMutableString string];
  
  for (CustomValue *value in self.customValue) {
    [customValuesString appendString:[NSString stringWithFormat:@"%@ = %@\n", value.fieldName, value.value]];
  }
  return [NSString stringWithFormat:@"%@\n%@", returnString, customValuesString];
}

@end
