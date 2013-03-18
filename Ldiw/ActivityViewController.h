//
//  ActivityViewController.h
//  Ldiw
//
//  Created by sander on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import "MBProgressHUD.h"
#import "MapView.h"
#import <MapKit/MapKit.h>

@interface ActivityViewController : UIViewController <UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic) BOOL  wastePointAddedSuccessfully;

@end
