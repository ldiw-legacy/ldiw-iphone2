//
//  MapView.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WastePoint.h"

@protocol AnnotationDelegate <NSObject>

- (void)pressedAnnotationForWastePoint:(WastePoint *)wastePoint;

@end

@interface MapView : MKMapView <MKMapViewDelegate>
@property (nonatomic, assign) ViewType viewType;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, assign) id <AnnotationDelegate> annotationDelegate;

- (void)centerToLocation:(CLLocation *)center;
- (void)centerToUserLocation;

- (void)loadPoints;
@end
