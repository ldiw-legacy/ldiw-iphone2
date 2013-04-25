//
//  CompositionView.h
//  Ldiw
//
//  Created by Lauri Eskor on 3/1/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPField.h"
#import "FieldDelegate.h"
#import "CustomValue.h"

@interface CompositionView : UIView

@property (nonatomic, assign) id<FieldDelegate> delegate;
@property (nonatomic, strong) WPField *field;
@property (nonatomic, strong) NSMutableArray *tickButtonArray;

- (id)initWithField:(WPField *)field;

@end
