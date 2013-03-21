//
//  ActivityViewController.h
//  Ldiw
//
//  Created by sander on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import "MBProgressHUD.h"
#import "MapView.h"
#import "EGORefreshTableHeaderView.h"

@interface ActivityViewController : UIViewController <UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, AnnotationDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MapView *mapview;
@property (nonatomic) BOOL  wastePointAddedSuccessfully;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

@end
