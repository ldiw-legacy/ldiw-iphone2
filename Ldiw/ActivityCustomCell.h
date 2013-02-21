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
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@end
