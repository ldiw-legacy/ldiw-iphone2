//
//  MapAnnotation.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithWastePoint:(WastePoint *)wastePoint {
  self = [super init];
  if (self) {
    [self setTitle:[NSString stringWithFormat:@"%d", wastePoint.idValue]];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(wastePoint.latitudeValue, wastePoint.longitudeValue);
    [self setCoordinate:coordinate];
  }
  return self;
}

@end
