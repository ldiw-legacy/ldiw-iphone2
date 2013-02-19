//
//  Database+Server.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"

@interface Database (Server)

- (void)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox;
- (NSString *)serverBaseUrl;
- (NSString *)serverSuffix;
- (BOOL)needToLoadServerInfotmation;
@end
