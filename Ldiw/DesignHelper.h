//
//  DesignHelper.h
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

@interface DesignHelper : NSObject

+(void)setUpHeaderViewButton:(UIButton *)button;
+(void)setLoginButtonTitle:(UIButton *)button;
+(void)setActivityViewSubtitle:(UILabel *)label;
+(void)setActivityViewNametitle:(UILabel *)label;
+(void)setActivityViewActiontitle:(UILabel *)label;
+(void)setActivityViewLocationtitle:(UILabel *)label;
+(void)setBarButtonTitleAttributes:(UIButton *)button;

+(UIImage *)userIconImage:(UIImage *)image;
+(UIImage *)wastePointImage:(UIImage *)image;
+(UIImage *)resizeImage:(UIImage *)image;

+(UITabBarController*) createTabBarController;
@end
