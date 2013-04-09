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
#import "Database+User.h"
#import "Database+WP.h"
#import "WastepointRequest.h"
#import "WastePointCell.h"
#import "BaseUrlRequest.h"
#import "DesignHelper.h"
#import "FBHelper.h"
#import "MBProgressHUD.h"
#import "WastePoint.h"
#import "Image.h"
#import "SuccessView.h"
#import "Constants.h"
#import "WastePointUploader.h"
#import "Image.h"
#import "CustomValue.h"
#import "PictureHelper.h"

#define kCellHeightWithPicture 160
#define kCellHeightNoPicture 80

@interface ActivityViewController ()
@property (strong, nonatomic) HeaderView *headerView;
@property (strong, nonatomic) SuccessView *successView;
@property (strong, nonatomic) NSArray *wastePointsArray;
@end

@implementation ActivityViewController
@synthesize tableView, headerView, successView, wastePointsArray, mapview, refreshHeaderView;

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
  [self setupPullToRefresh];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableview) name:kNotificationUploadsComplete object:nil];
  
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
  
  //Tableview
  UINib *myNib = [UINib nibWithNibName:@"WastePointCell" bundle:nil];
  [self.tableView registerNib:myNib forCellReuseIdentifier:@"Cell"];
  [[[LocationManager sharedManager] locManager] startUpdatingLocation];
  [self setWastePointsArray:[[Database sharedInstance] listWastepointsWithViewType:ViewTypeList]];
  [self.tableView reloadData];
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

- (void)setupPullToRefresh {
  self.refreshHeaderView.delegate = self;
  [self.tableView addSubview:self.refreshHeaderView];
  [self.refreshHeaderView refreshLastUpdatedDate];
  [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
  if (!userLoggedIn) {
    MSLog(@"User not logged in. Open login screen");
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [loginVC setDelegate:self];
    [self presentViewController:loginVC animated:YES completion:nil];
  } else {
    [self reloadTableview];
  }
}

- (CGRect)tableViewRect
{
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat tableviewheight = screenHeight - self.navigationController.navigationBar.bounds.size.height-self.tabBarController.tabBar.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.headerView.bounds.size.height;
  CGRect rect = CGRectMake(0, self.headerView.bounds.size.height, screenRect.size.width, tableviewheight);
  return rect;
}

- (void)setUpTableview
{
  if (!tableView) {
    self.tableView = [[UITableView alloc] initWithFrame:[self tableViewRect]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:tableView];
    UINib *myNib = [UINib nibWithNibName:@"WastePointCell" bundle:nil];
    [self.tableView registerNib:myNib forCellReuseIdentifier:@"Cell"];
    self.tableView.backgroundColor = kDarkBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupPullToRefresh];
  }
}

- (void)nearbyPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected = YES;
  self.headerView.friendsButton.selected = NO;
  self.headerView.showMapButton.selected = NO;
  [mapview setHidden:YES];
  [tableView setHidden:NO];
  [self setUpTableview];
}

- (void)setUpMapView
{
  if (!mapview) {
    self.mapview = [[MapView alloc] initWithFrame:[self tableViewRect]];
    [self.view addSubview:mapview];
    [mapview setViewType:ViewTypeLargeMap];
    [mapview setAnnotationDelegate:self];
    [mapview centerToUserLocation];
  }
}

- (void)friendsPressed:(UIButton *)sender
{
  self.headerView.nearbyButton.selected = NO;
  self.headerView.friendsButton.selected = YES;
  self.headerView.showMapButton.selected = NO;
}

- (void)showMapPressed:(UIButton *)sender
{
  if ([[LocationManager sharedManager] locationServicesEnabled])
  {
    self.headerView.nearbyButton.selected = NO;
    self.headerView.friendsButton.selected = NO;
    self.headerView.showMapButton.selected = YES;
    [self setUpMapView];
    [tableView setHidden:YES];
    [mapview setHidden:NO];
  } else {
    [self showHudWarning];
  }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
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
    self.tabBarController.selectedIndex = 0;
    [self presentViewController:picker animated:YES completion:nil];
  } else if (buttonIndex == 2) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
    self.tabBarController.selectedIndex = 0;
  } else if (buttonIndex != 3) {
    self.tabBarController.selectedIndex = 0;
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionamm
{
  return wastePointsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WastePoint *selectedPoint = [wastePointsArray objectAtIndex:indexPath.row];
  DetailViewController *detailView = [[DetailViewController alloc] initWithWastePoint:selectedPoint andEnableEditing:NO];
  [self.navigationController pushViewController:detailView animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  WastePointCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (!cell) {
    cell = [[WastePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  WastePoint *point = [wastePointsArray objectAtIndex:indexPath.row];
  [cell setWastePoint:point];
  return cell;
}

- (void)showHudWarning
{
  MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.tabBarController.selectedViewController.view];
  
  [self.tabBarController.selectedViewController.view addSubview:hud];
  hud.delegate = self;
  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_1"]];
  hud.mode = MBProgressHUDModeCustomView;
  hud.opacity = 0.8;
  hud.color=[UIColor colorWithRed:0.75 green:0.75 blue:0.72 alpha:1];
  hud.detailsLabelText = @"LDIW needs permission to see your location to add/see wastepoints";
  hud.detailsLabelFont = [UIFont fontWithName:kFontNameBold size:17];
  [hud showWhileExecuting:@selector(waitForSomeSeconds) onTarget:self withObject:nil animated:YES];
}

- (void)waitForSomeSeconds {
  sleep(3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  WastePoint *point = [wastePointsArray objectAtIndex:indexPath.row];
  if ([point.images count] > 0) {
    return kCellHeightWithPicture;
  } else {
    return kCellHeightNoPicture;
  }
}

- (void)reloadTableview {
  [self setWastePointsArray:[[Database sharedInstance] listWastepointsWithViewType:ViewTypeList]];
  [self.tableView reloadData];
}

- (void)loadWastePointList {
  [self showHudWithText:NSLocalizedString(@"first.loading.wastepoints", nil)];
  [WastepointRequest getWPListForCurrentAreaForViewType:ViewTypeList withSuccess:^(NSArray* responseArray) {
    MSLog(@"Response array count: %i", responseArray.count);
    [self reloadTableview];
    [self doneLoadingTableViewData];
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
    [self doneLoadingTableViewData];
  }];
}

- (void)showHudWithText:(NSString *)text {
  MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
  if (!hud) {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  }
  if ([text length] > 0) {
    [hud setLabelText:text];
  }
}

- (void)removeHud {
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - AnnotationDelegate
- (void)pressedAnnotationForWastePoint:(WastePoint *)wastePoint {
  DetailViewController *detailView = [[DetailViewController alloc] initWithWastePoint:wastePoint andEnableEditing:NO];
  [self.navigationController pushViewController:detailView animated:YES];
}

-(void)mapView:(MapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  [mapView loadPoints];
}

#pragma mark - EGORefreshTableHeaderView delegate
- (EGORefreshTableHeaderView *)refreshHeaderView
{
  if (!refreshHeaderView){
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
  }
  return refreshHeaderView;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
  [self loadWastePointList];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
  return [NSDate date];
}

- (void)doneLoadingTableViewData {
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
  [self removeHud];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - Login Delegate
- (void)loginSuccessful {
  [self dismissViewControllerAnimated:YES completion:^(void){
    [self loadWastePointList];
  }];
}

- (void)loginFailed {
  MSLog(@"Login Failed");
}
@end
