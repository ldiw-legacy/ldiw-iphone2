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
    [self setupMapView];
  }
  return self;
}

- (void)setupMapView {
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [self createMapViewWithCoordinate:location];
  } errorBlock:^(NSError *error) {
    MSLog(@"Could not get location for map");
  }];
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

@end
