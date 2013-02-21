//
//  LocationManager.h
//  Munizapp
//
//  Created by Lauri Eskor on 11/12/12.
//
//

#import <CoreLocation/CoreLocation.h>

typedef void (^LocationBlock)(CLLocation *currentLocation);

@interface LocationManager : NSObject <CLLocationManagerDelegate> {
  void (^_locationBlock)(CLLocation *currentLocation);
  void (^_errorBlock)(NSError *error);
  void (^_geocodeBlock)(NSArray *placemarks);
  void (^_booleanResultBlock)(BOOL result);

}

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSDate *locationManagerStart;

+ (LocationManager *)sharedManager;
- (void)locationWithBlock:(void (^)(CLLocation *currentLocation)) locationBlock errorBlock:(void (^)(NSError *error))errorBlock;
- (void)reverseGeoCodeLocation:(CLLocation *)locationToCode withBlock:(void (^)(NSArray *placemarks)) geocodeBlock errorBlock:(void (^)(NSError *error))errorBlock;
- (void)currentLocationIsInsideBox:(NSString *)box withResultBlock:(void (^)(BOOL result)) booleanResultBlock;
- (BOOL)location:(CLLocation *)location IsInsideBox:(NSString *)box;

+(NSString*) getPhoneLanguage;
@end
