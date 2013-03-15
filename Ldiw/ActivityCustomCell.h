//
//  ActivityCustomCell.h
//  Ldiw
//
//  Created by sander on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCustomCell : UITableViewCell
@property (strong, nonatomic) UILabel *cellNameTitleLabel;
@property (strong, nonatomic) UILabel *cellSubtitleLabel;
@property (strong, nonatomic) UILabel *cellTitleLabel;
@property (strong, nonatomic) UILabel *cellLocationLabel;
@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UIImageView *wastePointImageView;
@property (strong, nonatomic)  UIActivityIndicatorView *spinner;
@property (nonatomic) double height;

@end
