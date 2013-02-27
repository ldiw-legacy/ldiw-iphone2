#import "WastePoint.h"
#import "CustomValue.h"
#import "Database.h"
#import "PictureHelper.h"
@implementation WastePoint

// Custom logic goes here.

+ (WastePoint *) newWastePointUsingImage:(UIImage *)image {
  WastePoint *wp = [WastePoint insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  [self setImage:image forWastePoint:wp];
  return wp;
}

+ (void)setImage:(UIImage*)image forWastePoint:(WastePoint*)wp {
  if (image) {
    [PictureHelper saveImage:image forWastePoint:wp];
  }
}


- (NSString *)description {
  NSString *returnString = [NSString stringWithFormat:@"id = %d\nlat = %f\nlon = %f\nphotos = %@", self.idValue, self.latitudeValue, self.longitudeValue, self.photos];
  NSMutableString *customValuesString = [NSMutableString string];
  
  for (CustomValue *value in self.customValue) {
    [customValuesString appendString:[NSString stringWithFormat:@"%@ = %@\n", value.fieldName, value.value]];
  }
  return [NSString stringWithFormat:@"%@\n%@", returnString, customValuesString];
}

@end
