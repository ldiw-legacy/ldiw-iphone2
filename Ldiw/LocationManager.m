//
//  LocationManager.m
//  Munizapp
//
//  Created by Lauri Eskor on 11/12/12.
//
//

#import "LocationManager.h"
#import "Database+Server.h"
#import "Database+User.h"
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
    [locManager startMonitoringSignificantLocationChanges];
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
    [[Database sharedInstance] setUserCurrentLocation:newLocation];
    if (_locationBlock) {
      _locationBlock(newLocation);
      _locationBlock = nil;
    } else {
      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserDidExitRegion object:newLocation];
    }
    [locManager stopUpdatingLocation];           
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

- (BOOL)location:(CLLocation *)location IsInsideBox:(NSString *)box {
  
  NSArray *boxObjects = [box componentsSeparatedByString:@","];
  if ([boxObjects count] != 4) {
    MSLog(@"Wrong number of box objects. Have %d, need 4. String: %@", [boxObjects count], box);
    return NO;
  }
  
  double topLeftX = [[boxObjects objectAtIndex:0] doubleValue];
  double topLeftY = [[boxObjects objectAtIndex:1] doubleValue];
  double botRightX = [[boxObjects objectAtIndex:2] doubleValue];
  double botRightY = [[boxObjects objectAtIndex:3] doubleValue];

  BOOL betweenXCoordinates = ( ((topLeftX < location.coordinate.latitude) && (location.coordinate.latitude < botRightX)) || ((topLeftX > location.coordinate.latitude) && (location.coordinate.latitude > botRightX)) );
  
  BOOL betweenYCoordinates = ( ((topLeftY < location.coordinate.longitude) && (location.coordinate.longitude < botRightY)) || ((topLeftY > location.coordinate.longitude) && (location.coordinate.longitude > botRightY)) );

  BOOL isInsideBox = (betweenXCoordinates && betweenYCoordinates);
  return isInsideBox;
}

- (void)currentLocationIsInsideBox:(NSString *)box withResultBlock:(void (^)(BOOL result))resultBlock {
  //    box = "26.2167,57.8833,27.2167,58.8833";
    BOOL isInsideBox = [self location:[[Database sharedInstance] currentUserLocation] IsInsideBox:box];
    resultBlock(isInsideBox);
}


+(NSString*) getPhoneLanguage {
  NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
  if (language.length >= 2) {
    return [language substringToIndex:2];
  } else {
    return nil;
  }
}

- (BOOL)locationServicesEnabled {
  if (([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)) {
    return YES;
  } else {
    return NO;
  }
}

- (void)stopLocationManager {
  [locManager stopMonitoringSignificantLocationChanges];
  [locManager stopUpdatingLocation];
}

- (NSString *)currentBoundingBox {
  CLLocationCoordinate2D currentCoordinate = [[[Database sharedInstance] currentUserLocation] coordinate];
  MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
  
  CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(currentCoordinate.latitude - span.latitudeDelta, currentCoordinate.longitude - span.longitudeDelta);
  CLLocationCoordinate2D botRight = CLLocationCoordinate2DMake(currentCoordinate.latitude + span.latitudeDelta, currentCoordinate.longitude + span.longitudeDelta);
  NSString *bBoxString = [NSString stringWithFormat:@"%g,%g,%g,%g", topLeft.longitude, topLeft.latitude, botRight.longitude, botRight.latitude];
  return bBoxString;
}

@end
