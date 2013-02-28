//
//  WastePointViews.h
//  Ldiw
//
//  Created by Timo Kallaste on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WastePoint.h"
#import "FieldView.h"

@interface WastePointViews : UIView <FieldDelegate>
@property (nonatomic, strong) WastePoint *wastePoint;

- (id)initWithWastePoint:(WastePoint *)wp;

@end
