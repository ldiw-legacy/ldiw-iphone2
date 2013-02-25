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

- (NSArray *)WPListFromData:(NSData *)csvData;
- (WastePoint *)wastepointWithId:(NSString *)remoteId;

@end
