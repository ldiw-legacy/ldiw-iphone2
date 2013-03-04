//
//  FieldDelegate.h
//  Ldiw
//
//  Created by Lauri Eskor on 3/4/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FieldDelegate <NSObject>

- (void)checkedValue:(NSString *)value forField:(NSString *)fieldName;
- (void)addDataPressedForField:(NSString *)fieldName;

@end
