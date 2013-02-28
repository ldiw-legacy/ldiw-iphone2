//
//  FieldView.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/27/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WPField.h"
@interface FieldView : UIView

@property (nonatomic, strong) WPField *wastePointField;

- (id)initWithWPField:(WPField *)field;

@end
