//
//  MapView.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MapView.h"
#import "LocationManager.h"
#import "WastepointRequest.h"
#import "MapAnnotation.h"
#import "WastePoint.h"

@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setDelegate:self];
    [self setShowsUserLocation:YES];
  }
  return self;
}

- (void)centerToUserLocation {
  MSLog(@"Center mapview to user location");
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [self createMapViewWithCoordinate:location];
  } errorBlock:^(NSError *error) {
    MSLog(@"Could not get location for map");
  }];
}

- (void)centerToLocation:(CLLocation *)center {
  MSLog(@"Center mapview to wastepoint location");
  [self setUserTrackingMode:MKUserTrackingModeNone];
  [self createMapViewWithCoordinate:center];
}

- (void)createMapViewWithCoordinate:(CLLocation *)location {
  MSLog(@"Zoom map to region");
  //  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.002, 0.004);
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.01, 0.01);
  MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location.coordinate, mapSpan);
  [self setRegion:mapRegion animated:NO];
  [self loadPoints];
}

- (void)loadPoints {
  [WastepointRequest getWPListForArea:self.region withSuccess:^(NSArray* responseArray) {
    MSLog(@"Response array count: %i", responseArray.count);
    [self createAnnotationsWithArray:responseArray];
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
  }];
}

- (void)createAnnotationsWithArray:(NSArray *)WPArray {
  NSMutableArray *tmpAnnotationsArray = [NSMutableArray array];
  for (WastePoint *point in WPArray) {
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithWastePoint:point];
    [tmpAnnotationsArray addObject:annotation];
  }
  [self addAnnotations:tmpAnnotationsArray];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
  MSLog(@"Mapview changed user tracking mode to %d", mode);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  MSLog(@"Mapview didUpdateUserLocation");  
}
@end
