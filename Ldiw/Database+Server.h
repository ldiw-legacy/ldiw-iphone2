//
//  Database+Server.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"
#import "WPField.h"
#import "TypicalValue.h"

@interface Database (Server)

- (void)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox;
- (NSString *)serverBaseUrl;
- (NSString *)serverSuffix;

- (NSArray *)listAllWPFields;
- (WPField *)createWPFieldWithFieldName:(NSString *)fieldName andEditInstructions:(NSString *)editInstructions andLabel:(NSString *)label andMaxValue:(NSNumber *)max andMinValue:(NSNumber *)min andSuffix:(NSString *)suffix andType:(NSString *)type andTypicalValues:(NSArray *)typicalValues;
- (BOOL)needToLoadServerInfotmation;
@end
