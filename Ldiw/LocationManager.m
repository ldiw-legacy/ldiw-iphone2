//
//  LocationManager.m
//  Munizapp
//
//  Created by Lauri Eskor on 11/12/12.
//
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>

@implementation LocationManager
@synthesize locManager, geocoder, locationManagerStart;

- (LocationManager *)init {
  self = [super init];
  if (self) {
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    [self setLocManager:manager];
    [self setLocationManagerStart:[NSDate date]];
    
    CLGeocoder *gcoder = [[CLGeocoder alloc] init];
    [self setGeocoder:gcoder];
    
    [locManager setDelegate:self];
    [locManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
  }
  return self;
}

+ (LocationManager *)sharedManager
{
  static dispatch_once_t pred;
  static LocationManager *sharedInstance = nil;
  
  dispatch_once(&pred, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)locationWithBlock:(void (^)(CLLocation *currentLocation)) locationBlock errorBlock:(void (^)(NSError *error))errorBlock {
  _locationBlock = [locationBlock copy];
  _errorBlock = [errorBlock copy];
  [locManager startUpdatingLocation];
}

- (void)reverseGeoCodeLocation:(CLLocation *)locationToCode withBlock:(void (^)(NSArray *))geocodeBlock errorBlock:(void (^)(NSError *))errorBlock {
  _geocodeBlock = [geocodeBlock copy];
  _errorBlock = [errorBlock copy];
  
  [geocoder cancelGeocode];
  [geocoder reverseGeocodeLocation:locationToCode completionHandler:^(NSArray *placemarks, NSError *error) {
    if (error) {
      if (_errorBlock) {
        if (error.code != kCLErrorGeocodeCanceled) {
          MSLog(@"Geocoding error %@", error);
          _errorBlock(error);
        }
      }
    } else {
      if (_geocodeBlock) {
        _geocodeBlock(placemarks);
      }
    }
  }];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
  if ([self isValidLocation:newLocation withOldLocation:oldLocation]) {
    [locManager stopUpdatingLocation];
    if (_locationBlock) {
      MSLog(@"Got goot location, call newLocation block");
      _locationBlock(newLocation);
    }
  } else {
    MSLog(@"Bad location info %@", newLocation);
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  MSLog(@"Failed to update location %@", error);
  if (_errorBlock) {
    _errorBlock(error);
  }
  [locManager stopUpdatingLocation];
}

- (BOOL)isValidLocation:(CLLocation *)newLocation
        withOldLocation:(CLLocation *)oldLocation
{
  // Filter out nil locations
  if (!newLocation)
  {
    return NO;
  }
  
  // Filter out points by invalid accuracy
  if (newLocation.horizontalAccuracy < 0)
  {
    return NO;
  }
  
  // Filter out points that are out of order
  NSTimeInterval secondsSinceLastPoint =
  [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
  
  if (secondsSinceLastPoint < 0)
  {
    return NO;
  }
  
  // Filter out points created before the manager was initialized
  NSTimeInterval secondsSinceManagerStarted =
  [newLocation.timestamp timeIntervalSinceDate:locationManagerStart];
  
  if (secondsSinceManagerStarted < 0)
  {
    return NO;
  }
  
  // The newLocation is good to use
  return YES;
}

- (void)currentLocationIsInsideBox:(NSString *)box withResultBlock:(void (^)(BOOL result))resultBlock {
  //    box = "26.2167,57.8833,27.2167,58.8833";
  NSArray *boxObjects = [box componentsSeparatedByString:@","];
  if ([boxObjects count] != 4) {
    MSLog(@"Wrong number of box objects. Have %d, need 4. String: %@", [boxObjects count], box);
    resultBlock(NO);
  }

  double topLeftX = [[boxObjects objectAtIndex:0] doubleValue];
  double topLeftY = [[boxObjects objectAtIndex:1] doubleValue];
  double botRightX = [[boxObjects objectAtIndex:2] doubleValue];
  double botRightY = [[boxObjects objectAtIndex:3] doubleValue];
  double boxWidth = botRightX - topLeftX;
  double boxHeight = botRightY - topLeftY;
  
  MKMapRect mapRect = MKMapRectMake(topLeftX, topLeftY, boxWidth, boxHeight);
  
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    MKMapPoint currentPoint = MKMapPointForCoordinate(location.coordinate);
    BOOL isInsideBox = MKMapRectContainsPoint(mapRect, currentPoint);
    resultBlock(isInsideBox);
  } errorBlock:^(NSError *error) {
    resultBlock(NO);
  }];
}


+(NSString*) getPhoneLanguage {
  NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
  if (language.length >= 2) {
    return [language substringToIndex:2];
  } else {
    return nil;
  }
}

@end
