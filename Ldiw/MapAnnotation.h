//
//  MapAnnotation.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WastePoint.h"
@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) WastePoint *wastePoint;

- (id)initWithWastePoint:(WastePoint *)wastePoint;
@end
