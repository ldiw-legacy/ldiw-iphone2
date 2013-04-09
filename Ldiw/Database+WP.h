//
//  Database+WP.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"
#import "WastePoint.h"

@interface Database (WP)

- (WastePoint *)addWastePointUsingImage:(UIImage *)image;
- (void)createWastePointWithDictionary:(NSDictionary *)inDict forViewType:(ViewType)viewType;

- (NSArray *)WPListFromData:(NSData *)csvData forViewType:(ViewType)viewType;
- (WastePoint *)wastepointWithId:(NSString *)remoteId;

- (NSArray *)listWastePointsWithNoId;
- (NSArray *)listWastepointsWithViewType:(ViewType)viewType;

- (CustomValue *)addCustomValueWithKey:(NSString *)key andValue:(NSString *)value;
- (CustomValue *)customValueWithKey:(NSString *)fieldName andValue:(NSString *)newValue;

@end
