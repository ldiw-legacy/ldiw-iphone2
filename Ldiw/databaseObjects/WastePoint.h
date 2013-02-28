#import "_WastePoint.h"

@interface WastePoint : _WastePoint {}
// Custom logic goes here.

+ (WastePoint *)newWastePointUsingImage:(UIImage *)image;
- (void)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName;

@end
