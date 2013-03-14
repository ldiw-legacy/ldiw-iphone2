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

@interface WastePointViews : UIView
@property (nonatomic, strong) WastePoint *wastePoint;
@property (nonatomic, strong) id fieldDelegate;
@property (nonatomic, strong) NSMutableDictionary *fieldsDictionary;

- (id)initWithWastePoint:(WastePoint *)wp andDelegate:(id)delegate;
- (void)setValue:(NSString *)value forField:(NSString *)fieldname;
- (void) deselectAllTicsForField:(NSString *)fieldname;

@end
