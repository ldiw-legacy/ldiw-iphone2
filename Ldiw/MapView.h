//
//  MapView.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapView : MKMapView <MKMapViewDelegate>
- (void)centerToLocation:(CLLocation *)center;
- (void)centerToUserLocation;

- (void)loadPoints;
@end
