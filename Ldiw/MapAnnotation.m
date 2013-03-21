//
//  MapAnnotation.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize wastePoint;

- (id)initWithWastePoint:(WastePoint *)aWastePoint {
  self = [super init];
  if (self) {
    [self setWastePoint:aWastePoint];
  }
  return self;
}

#pragma mark - MKAnnotation delegate
- (NSString *)title {
  return [NSString stringWithFormat:@"%d", wastePoint.idValue];
}

- (CLLocationCoordinate2D)coordinate {
  return CLLocationCoordinate2DMake(wastePoint.latitudeValue, wastePoint.longitudeValue);
}

@end
