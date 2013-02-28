#import "WastePoint.h"
#import "CustomValue.h"
#import "Database.h"
#import "PictureHelper.h"

@implementation WastePoint

// Custom logic goes here.

+ (WastePoint *) newWastePointUsingImage:(UIImage *)image {
  WastePoint *wp = [WastePoint insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  if (image) [PictureHelper saveImage:image forWastePoint:wp];
  return wp;
}

- (void)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName {
  for (CustomValue* value in self.customValues) {
    if ([value.fieldName isEqualToString:fieldName]) {
      [value setValue:newValue];
      return;
    }
  }
  MSLog(@"Need to add new value");
  CustomValue *value = [CustomValue customValueWithKey:fieldName andValue:newValue];
  [self addCustomValuesObject:value];
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
