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
#import "Database+WP.h"
#import "WastepointRequest.h"
#import "ActivityCustomCell.h"
#import "BaseUrlRequest.h"
#import "LoginViewController.h"
#import "DesignHelper.h"
#import "FBHelper.h"
#import "MBProgressHUD.h"
#import "WastePoint.h"
#import "WastePoint.h"
#import "Image.h"
#import "SuccessView.h"
#import "Constants.h"
#import "WastePointUploader.h"
#import "Image.h"
#import "CustomValue.h"
#import "PictureHelper.h"

#define kCellHeightWithPicture 186
#define kCellHeightNoPicture 86

@interface ActivityViewController ()
@property (strong, nonatomic) HeaderView *headerView;
@property (strong, nonatomic) SuccessView *successView;
@property (strong, nonatomic) NSArray *wastPointResultsArray;
@property (strong, nonatomic) NSMutableArray *cellHeightArray;
@end

@implementation ActivityViewController
@synthesize tableView, headerView, successView,wastPointResultsArray;

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHud) name:kNotificationShowHud object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeHud) name:kNotificationRemoveHud object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeViewController) name:kNotificationDismissLoginView object:nil];
  
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
  
  
  [self loadServerInformation];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = NO;
  self.tabBarController.tabBar.hidden = NO;
  if (self.wastePointAddedSuccessfully) {
    [self showSuccessBanner];
  }
  [self showLoginViewIfNeeded]; 
}

-(void)showSuccessBanner
{
  self.wastePointAddedSuccessfully = NO;
  self.navigationController.navigationBarHidden = YES;
  self.tabBarController.tabBar.hidden = YES;
  [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:[[UIScreen mainScreen] bounds]];
  if (!successView) {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    successView = [[SuccessView alloc] initWithFrame:screenRect];
    successView.controller = self;
  }
  [self.view addSubview:self.successView];
  MSLog(@"Added wastepoint to DB: %@", [[Database sharedInstance] listWastePointsWithNoId]);
}

- (void)showLoginViewIfNeeded {
  BOOL userLoggedIn = [[Database sharedInstance] userIsLoggedIn];
  BOOL FBSessionOpen = [FBHelper FBSessionOpen];
  BOOL openLoginView = !(userLoggedIn || FBSessionOpen);
  if (openLoginView) {
    MSLog(@"User logged in %d, FBsessionOpen %d, open login view", userLoggedIn, FBSessionOpen);
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
  }
}

- (void)setUpTabelview
{
  CGRect tableframe = CGRectMake(0, 49, 320, 499);
  self.tableView = [[UITableView alloc]initWithFrame:tableframe];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.view addSubview:tableView];
  UINib *myNib = [UINib nibWithNibName:@"ActivityCustomCell" bundle:nil];
  [self.tableView registerNib:myNib forCellReuseIdentifier:@"Cell"];
  self.tableView.backgroundColor = kDarkBackgroundColor;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableView reloadData];
}

- (void)nearbyPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected = YES;
  self.headerView.friendsButton.selected = NO;
  self.headerView.showMapButton.selected = NO;
  if (!self.tableView) {
    [self setUpTabelview];
  }
}

- (void)setUpMapView
{
  CGRect mapRect = CGRectMake(0, 49, 320, 449);
  MapView *mapview = [[MapView alloc] initWithFrame:mapRect];
  [self.view addSubview:mapview];
}

- (void)friendsPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected = NO;
  self.headerView.friendsButton.selected = YES;
  self.headerView.showMapButton.selected = NO;
}

- (void)showMapPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected = NO;
  self.headerView.friendsButton.selected = NO;
  self.headerView.showMapButton.selected = YES;
  [self.tableView removeFromSuperview];
  self.tableView=nil;
  [self setUpMapView];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if (viewController==[tabBarController.viewControllers objectAtIndex:1]) {
    {
      if ([[LocationManager sharedManager] locationServicesEnabled]) {
      UIActionSheet  *sheet = [[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"pleaseAddPhotoTitle", nil)
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"cancel",nil) destructiveButtonTitle:NSLocalizedString(@"skipPhoto",nil)
                                 otherButtonTitles:NSLocalizedString(@"takePhoto",nil),NSLocalizedString(@"chooseFromLibrary",nil), nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [sheet showInView:self.tabBarController.tabBar];
      } else {
        [self showHudWarning];
      }
      
    }
    return NO;
  }
  return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  //self.tabBarController.selectedIndex = 0;
  if (buttonIndex == 1) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
      [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  } else if (buttonIndex == 2) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
  } else if (buttonIndex != 3) {
    [self openDetailViewWithImage:nil];
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  DetailViewController *detail = [[DetailViewController alloc] initWithImage:cameraImage];
  detail.controller = self;
  [self.navigationController pushViewController:detail animated:NO];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openDetailViewWithImage:(UIImage *)image {
  DetailViewController *detail = [[DetailViewController alloc] initWithImage:image];
  detail.takePictureButton.alpha = 1.0;
  detail.controller = self;
  [self.navigationController pushViewController:detail animated:NO];
}

- (void)didReceiveMemoryWarning

{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.wastPointResultsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WastePoint *selectedPoint = [self.wastPointResultsArray objectAtIndex:indexPath.row];
  DetailViewController *detailView = [[DetailViewController alloc] initWithWastePoint:selectedPoint];
  [self.navigationController pushViewController:detailView animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ActivityCustomCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"Cell"forIndexPath:indexPath];
  if (!cell) {
    cell = [[ActivityCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  cell.userImageView.image = [DesignHelper userIconImage:[UIImage imageNamed:@"someface.jpg"]];

  WastePoint *point=[self.wastPointResultsArray objectAtIndex:indexPath.row];
  NSString *wastpointID = [NSString stringWithFormat:@"%@",point.id];
  cell.cellNameTitleLabel.text = wastpointID;
  [cell.cellNameTitleLabel sizeToFit];


  //Description
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fieldName == %@", @"description"];
  NSSet *set = [point.customValues filteredSetUsingPredicate:predicate];
  CustomValue *customvalue;
  if (set.count == 1) {
    customvalue = [set anyObject];
  }
  
  NSString *descript= customvalue.value;
  cell.cellSubtitleLabel.text = descript;
  [cell.cellSubtitleLabel sizeToFit];
  if (cell.cellSubtitleLabel.frame.size.width > 300) {
    cell.cellSubtitleLabel.frame = CGRectMake(cell.cellSubtitleLabel.frame.origin.x, cell.cellSubtitleLabel.frame.origin.y,300, cell.cellSubtitleLabel.frame.size.height) ;
  }
  
  //Country
  NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"fieldName == %@", @"geo_areas_json"];
  NSSet *set2 = [point.customValues filteredSetUsingPredicate:predicate2];
  CustomValue *cv;
  if (set2.count == 1) {
    cv = [set2 anyObject];
  }
  NSError *error;
  NSData *data = [cv.value dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary* json = [NSJSONSerialization
                        JSONObjectWithData:data

                        options:kNilOptions
                        error:&error];
  NSString *country = [json objectForKey:@"Country"];

  cell.cellTitleLabel.text = country;
  [cell.cellTitleLabel sizeToFit];

  //Thumbinal for view
      [cell.spinner startAnimating];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    UIImage *thumbinal = [PictureHelper thumbinalForWastePoint:point];
    dispatch_async(dispatch_get_main_queue(), ^{
      cell.wastePointImageView.image = thumbinal;
      [cell.spinner stopAnimating];
    });
  });

  cell.wastePointImageView.image=nil;
  return cell;
}


- (void)showHudWarning
{
  MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
  
  [self.view addSubview:hud];
  hud.delegate = self;
  hud.customView = [[UIImageView alloc] initWithImage:
                    [UIImage imageNamed:@"pin_1"]];
  hud.mode = MBProgressHUDModeCustomView;
  hud.opacity = 0.8;
  hud.color=[UIColor colorWithRed:0.75 green:0.75 blue:0.72 alpha:1];
  hud.detailsLabelText = @"LDIW needs permission to see your location to add wastepoint";
  hud.detailsLabelFont = [UIFont fontWithName:kFontNameBold size:17];
  [hud showWhileExecuting:@selector(waitForSomeSeconds)
                 onTarget:self withObject:nil animated:YES];
  
}

- (void)waitForSomeSeconds {
  sleep(3);
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
    //MSLog(@"Response array first object %@", [responseArray objectAtIndex:1] );
    self.wastPointResultsArray=[[NSArray alloc] initWithArray:responseArray];
    [self.tableView reloadData];
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
  }];
}

- (void)loadServerInformation {
  //  if ([[Database sharedInstance] userIsLoggedIn]) {
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
  //  }
}

- (void)showHud {
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)removeHud {
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)removeViewController {
  [self dismissViewControllerAnimated:YES completion:^(void){}];
}

@end
