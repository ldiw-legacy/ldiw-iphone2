#import "_WastePoint.h"
#import <MapKit/MapKit.h>

@interface WastePoint : _WastePoint {}
// Custom logic goes here.

- (NSString*)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName;
- (CLLocation *)location;

@end
