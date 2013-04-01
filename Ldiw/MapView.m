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

#define kscaleConstantForMapView 100000
@implementation MapView
@synthesize annotationDelegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
   [self setup];
  }
  return self;
}

- (void)setup {
  [self setDelegate:self];
  [self setShowsUserLocation:YES];
}

- (void)centerToUserLocation {
  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [self createMapViewWithCoordinate:location];
  } errorBlock:^(NSError *error) {
    MSLog(@"Could not get location for map");
  }];
}

- (void)centerToLocation:(CLLocation *)center {
  [self setUserTrackingMode:MKUserTrackingModeNone];
  [self createMapViewWithCoordinate:center];
}

- (void)createMapViewWithCoordinate:(CLLocation *)location {
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(self.frame.size.width / kscaleConstantForMapView, self.frame.size.width / kscaleConstantForMapView);
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  
  static NSString *identifier = @"MyLoc";
  if (annotation != self.userLocation) {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
      annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
      annotationView.annotation = annotation;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;

    if (annotationDelegate) {
      UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      [rightButton setTitle:annotation.title forState:UIControlStateNormal];
      [annotationView setRightCalloutAccessoryView:rightButton];
    }
    
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
  if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure) {
    MapAnnotation *annotation = (MapAnnotation *)view.annotation;
    WastePoint *wp = annotation.wastePoint;
    [annotationDelegate pressedAnnotationForWastePoint:wp];
  }
}

-(void)mapView:(MapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [mapView loadPoints];
}

@end
