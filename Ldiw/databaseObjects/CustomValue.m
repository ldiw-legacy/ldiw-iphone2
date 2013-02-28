#import "CustomValue.h"


@interface CustomValue ()

// Private interface goes here.

@end


@implementation CustomValue

// Custom logic goes here.

+ (CustomValue *)customValueWithKey:(NSString *)key andValue:(NSString *)newValue {
  CustomValue *returnValue = [CustomValue insertInManagedObjectContext:self.managedObjectContext];
  [returnValue setValue:newValue];
  [returnValue setFieldName:key];
  return returnValue;
}

@end
