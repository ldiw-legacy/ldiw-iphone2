//
//  DetailViewController.m
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationManager.h"

@implementation DetailViewController
@synthesize scrollView, imageView, mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.

  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [self createMapViewWithCoordinate:location];
  } errorBlock:^(NSError *error) {
    
  }];
}

- (void)createMapViewWithCoordinate:(CLLocation *)location {
  MSLog(@"Zoom map to region");
  // TODO: Why is mapview frame height zero??
//  [mapView setFrame:CGRectMake(166, 15, 140, 140)];
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.002, 0.004);
  MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location.coordinate, mapSpan);
  [mapView setRegion:mapRegion animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
  MSLog(@"new mapView to new region");
  MKCoordinateRegion region = aMapView.region;
  MSLog(@"Mapview region delta: %g %g", region.span.latitudeDelta, region.span.longitudeDelta);
}
@end
