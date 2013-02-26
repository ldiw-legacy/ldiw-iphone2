//
//  ActivityViewController.m
//  Ldiw
//
//  Created by sander on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "HeaderView.h"
#import "Database+Server.h"
#import "Database+WPField.h"
#import "WastepointRequest.h"
#import "ActivityCustomCell.h"
#import "BaseUrlRequest.h"
#import "LoginViewController.h"
#import "DesignHelper.h"

#define kDarkBackgroundColor [UIColor colorWithRed:0.153 green:0.141 blue:0.125 alpha:1] /*#272420*/


@interface ActivityViewController ()
@property (strong, nonatomic) HeaderView *headerView;
@end

@implementation ActivityViewController
@synthesize tableView, headerView
;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tabBarController setDelegate:self];
  
  UIImage *image = [UIImage imageNamed:@"logo_titlebar"];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];

  //Segmented control in headerview
 
  UIImage *image2 = [UIImage imageNamed:@"feed_subtab_bg"];
  self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, image2.size.width, image2.size.height)];
  [self.view addSubview:self.headerView];
  [self.headerView.nearbyButton addTarget:self action:@selector(nearbyPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.friendsButton addTarget:self action:@selector(friendsPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.showMapButton addTarget:self action:@selector(showMapPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  self.headerView.nearbyButton.selected = YES;
  self.tableView.backgroundColor = kDarkBackgroundColor;

  //Tabelview
  UINib *myNib = [UINib nibWithNibName:@"ActivityCustomCell" bundle:nil];
  [self.tableView registerNib:myNib forCellReuseIdentifier:@"Cell"];

  [self showLoginViewIfNeeded];
  [self loadServerInformation];
}
- (void)viewWillAppear:(BOOL)animated
{
  self.tabBarController.tabBar.hidden = NO;
}

- (void)showLoginViewIfNeeded {
  if (![[Database sharedInstance] userIsLoggedIn]) {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
  }
}

- (void)nearbyPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected=YES;
  self.headerView.friendsButton.selected=NO;
  self.headerView.showMapButton.selected=NO;
}

- (void)friendsPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected=NO;
  self.headerView.friendsButton.selected=YES;
  self.headerView.showMapButton.selected=NO;
}

- (void)showMapPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected=NO;
  self.headerView.friendsButton.selected=NO;
  self.headerView.showMapButton.selected=YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if (viewController==[tabBarController.viewControllers objectAtIndex:1]) {
    {
      UIActionSheet  *sheet = [[UIActionSheet alloc]
                               initWithTitle:NSLocalizedString(@"pleaseAddPhotoTitle", nil)
                               delegate:self
                               cancelButtonTitle:NSLocalizedString(@"cancel",nil)                                   destructiveButtonTitle:NSLocalizedString(@"skipPhoto",nil)
                               otherButtonTitles:NSLocalizedString(@"takePhoto",nil),NSLocalizedString(@"chooseFromLibrary",nil), nil];
      [sheet showFromTabBar:self.tabBarController.tabBar];
    }
    return NO;
  }
  return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
  NSLog(@"Buttonindex %i",buttonIndex);
  if (buttonIndex == 3) {
    self.tabBarController.selectedIndex=0;
  } else if (buttonIndex == 1)
  {
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
      [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary]; }

    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  } else if (buttonIndex == 2)

  { UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
  } else {
    DetailViewController *detail =[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
    detail.takePictureButton.alpha = 1.0;
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  DetailViewController *detail =[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
  [self.navigationController pushViewController:detail animated:YES];
  UIImage *cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  //Unique Key

  NSString *key = (__bridge NSString *)newUniqueIDString;

  UIImage *resizedImage = [DesignHelper resizeImage:cameraImage];
  NSData *dataForJpg = UIImageJPEGRepresentation(resizedImage, 0.7);
  

  //ToDo: save to documents

  //ToDo: save image to database with unique key

  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  [self dismissViewControllerAnimated:YES completion:nil];
  detail.imageView.image = cameraImage;
  detail.takePictureButton.alpha = 0;

  
}



- (void)didReceiveMemoryWarning
  
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 18;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  ActivityCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (!cell) {
    cell = [[ActivityCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
    cell.wastePointImageView.image = nil;
    cell.userImageView.image = [UIImage imageNamed:@"pointmarker_feed"];
  
  if (indexPath.row == 0) {
    cell.cellNameTitleLabel.text = @"Mike Rubbish";
    cell.wastePointImageView.image = [UIImage imageNamed:@"garbage005.jpg"];
    cell.wastePointImageView.image = [DesignHelper wastePointImage:[UIImage imageNamed:@"garbage005.jpg"]];
    NSLog(@"Wastepoint Image on %@",cell.wastePointImageView.image);
    cell.userImageView.image = [DesignHelper userIconImage:[UIImage imageNamed:@"someface2.jpg"]];
  } else if (indexPath.row == 1) {
    cell.cellNameTitleLabel.text = @"Missis Smith";
       cell.wastePointImageView.image = [DesignHelper wastePointImage:[UIImage imageNamed:@"garbage01.jpg"]];
      cell.userImageView.image = [DesignHelper userIconImage:[UIImage imageNamed:@"someface.jpg"]];
  } else {
    cell.cellNameTitleLabel.text = @"John Smith";
   // ToDo cell height
  }

  [cell.wastePointImageView  sizeToFit];
//  NSLog(@"wastepointView %@",NSStringFromCGRect(cell.wastePointImageView.frame));
  [cell.cellNameTitleLabel sizeToFit];
  cell.cellSubtitleLabel.text = @"2 days ago, 3km from here";
  [cell.cellSubtitleLabel sizeToFit];
  cell.cellTitleLabel.text = @"added wastepoint";
  [cell.cellTitleLabel sizeToFit];

  //ToDo cell height

 // CGFloat height = 5 + cell.userImageView.bounds.size.height + 6 + cell.cellSubtitleLabel.bounds.size.height + 5 + cell.wastePointImageView.bounds.size.height;
 // NSLog(@"cellheight %f", height);

  //cell.height=height;
 
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //To Do cell height
    return 186;
}

- (void)loadWastePointList {
  CLLocation *currentLocation = [[Database sharedInstance] currentLocation];
  MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
  MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, span);
  
  [WastepointRequest getWPListForArea:region withSuccess:^(NSArray* responseArray) {
    MSLog(@"Response array count: %i", responseArray.count);
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
  }];
}

- (void)loadServerInformation {
  if ([[Database sharedInstance] userIsLoggedIn]) {
    [[Database sharedInstance] needToLoadServerInfotmationWithBlock:^(BOOL result) {
      if (result) {
        MSLog(@"Need to load base server information");
        [BaseUrlRequest loadServerInfoForCurrentLocationWithSuccess:^(void) {
          [self loadWastePointList];
          
        } failure:^(void) {
          MSLog(@"Server info loading fail");
        }];
      }
    }];
  }
}

@end
