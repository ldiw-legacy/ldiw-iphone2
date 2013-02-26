//
//  ActivityViewController.m
//  Ldiw
//
//  Created by sander on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//
#import "DetailViewController.h"
#import "ActivityViewController.h"
#import "HeaderView.h"
#import "Database+Server.h"
#import "Database+WPField.h"
#import "WastepointRequest.h"
#import "ActivityCustomCell.h"
#import "BaseUrlRequest.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DesignHelper.h"

#define kTitlePositionAdjustment 8.0
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
  [self setUpTabbar];


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

  MSLog(@"%@", [[Database sharedInstance] listAllWPFields]);

  
  //Tabelview
  UINib *myNib = [UINib nibWithNibName:@"ActivityCustomCell" bundle:nil];
  [self.tableView registerNib:myNib forCellReuseIdentifier:@"Cell"];

  [self loadServerInformation];
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

- (void) setUpTabbar {

  UITabBar *tabbar = self.tabBarController.tabBar;
  tabbar.clipsToBounds = NO;

  UIImage *selectedImage0 = [UIImage imageNamed:@"tab_feed_pressed"];
  UIImage *unselctedImage0 = [UIImage imageNamed:@"tab_feed_normal"];

  UIImage *selectedImage1 = [UIImage imageNamed:@"tab_addpoint_pressed"];
  UIImage *unselctedImage1 = [UIImage imageNamed:@"tab_addpoint_normal"];

  UIImage *selectedImage2 = [UIImage imageNamed:@"tab_account_pressed"];
  UIImage *unselctedImage2 = [UIImage imageNamed:@"tab_account_normal"];

  UITabBarItem *item0 = [tabbar.items objectAtIndex:0];
  UITabBarItem *item1 = [tabbar.items objectAtIndex:1];
  UITabBarItem *item2 = [tabbar.items objectAtIndex:2];
  [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselctedImage0];
  [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselctedImage1];
  [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselctedImage2];


  item0.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item1.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item2.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item0.title = NSLocalizedString(@"tabBar.activityTabName", nil);
  item1.title = NSLocalizedString(@"tabBar.newPointTabText", nil);
  item2.title = NSLocalizedString(@"tabBar.myAccountTabText", nil);
  self.tabBarController.delegate=self;
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
  if (buttonIndex==3) {
    self.tabBarController.selectedIndex=0;
  } else if (buttonIndex==1)
  {
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
      [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary]; }

    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
  } else if (buttonIndex==2)

  { UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
  } else {
    DetailViewController *detail=[[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *cameraImage=[info objectForKey:UIImagePickerControllerOriginalImage];
  [self dismissViewControllerAnimated:YES completion:Nil];
  CFUUIDRef newUniqueID=CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString=CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  NSString *key=(__bridge NSString *)newUniqueIDString;

  //ToDo: resize image

  //ToDo: set image imageview on detailview:

  //ToDo: save image to database with unique key

  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  NSLog(@"AAA");
  [self dismissViewControllerAnimated:YES completion:nil];
  
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
  MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
  MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, span);
  
  [WastepointRequest getWPListForArea:region withSuccess:^(NSArray* responseArray) {
    MSLog(@"Response array count: %i", responseArray.count);
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
  }];
}

- (void)loadServerInformation {
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

@end
