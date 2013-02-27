#import "_WastePoint.h"

@interface WastePoint : _WastePoint {}
// Custom logic goes here.

+ (WastePoint *)newWastePointUsingImage:(UIImage *)image;
+ (void)setImage:(UIImage*)image forWastePoint:(WastePoint*)wp;

@end
