//
//  MySettingsViewController.h
//  Ldiw
//
//  Created by Timo Kallaste on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@interface MySettingsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *uploadSettingTitle;
@property (nonatomic, weak) IBOutlet UILabel *uploadSettingDescritption;
@property (nonatomic, weak) IBOutlet UIView *uploadSettingBaseView;
@property (nonatomic, strong) DCRoundSwitch *uploadSettingSwitch;


@end
