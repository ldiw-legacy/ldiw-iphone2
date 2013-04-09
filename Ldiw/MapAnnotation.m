//
//  MapAnnotation.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MapAnnotation.h"
#import "WastePoint.h"

@implementation MapAnnotation
@synthesize titleString, latitude, longitude, pointId;

- (id)initWithWastePoint:(WastePoint *)aWastePoint {
  self = [super init];
  if (self) {
    if (aWastePoint.nrOfNodesValue > 0) {
      [self setTitleString:[NSString stringWithFormat:@"Node count %d", aWastePoint.nrOfNodesValue]];
    } else {
      [self setTitleString:[NSString stringWithFormat:@"Id %@", aWastePoint.id]];
    }
    [self setPointId:aWastePoint.id];
    self.longitude = aWastePoint.longitudeValue;
    self.latitude = aWastePoint.latitudeValue;
    self.nrOfNodes = aWastePoint.nrOfNodesValue;
  }
  return self;
}

#pragma mark - MKAnnotation delegate
- (NSString *)title {
  return titleString;
}

- (CLLocationCoordinate2D)coordinate {
  CLLocationCoordinate2D returnCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
  if (CLLocationCoordinate2DIsValid(returnCoordinate)) {
    return returnCoordinate;
  } else {
    MSLog(@"Not-valid coordinate");
    return CLLocationCoordinate2DMake(0, 0);
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"lat:%g lon:%g title: %@", latitude, longitude, titleString];
}

@end
