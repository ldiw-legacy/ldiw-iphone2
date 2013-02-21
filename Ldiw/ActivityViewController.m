//
//  ActivityViewController.m
//  Ldiw
//
//  Created by sander on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ActivityViewController.h"
#import "HeaderView.h"
#import "Database+Server.h"
#import "WastepointRequest.h"
#import "ActivityCustomCell.h"
#import "BaseUrlRequest.h"

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
  self.headerView =[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, image2.size.width, image2.size.height)];
  [self.view addSubview:self.headerView];
  [self.headerView.nearbyButton addTarget:self action:@selector(nearbyPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.friendsButton addTarget:self action:@selector(friendsPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.showMapButton addTarget:self action:@selector(showMapPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  self.headerView.nearbyButton.selected = YES;
<<<<<<< HEAD
  self.tableView.backgroundColor=kDarkBackgroundColor;
  MSLog(@"%@", [[Database sharedInstance] listAllWPFields]);
=======

>>>>>>> 36c19086db04426b11fa20b37d4b8ca30b464b0f
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
  cell.cellNameTitleLabel.text=@"John Smith";
  cell.cellSubtitleLabel.text=@"2 days ago, 3km from here";
  cell.cellTitleLabel.text=@"added wastepoint";
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 150;
}

- (void)loadWastePointList {
  [WastepointRequest getWPList:^(NSArray* responseArray) {
    MSLog(@"Response array %@", responseArray);
  } failure:^(NSError *error){
    MSLog(@"Failed to load WP list");
  }];
}

- (void)loadServerInformation {
  [[Database sharedInstance] needToLoadServerInfotmationWithBlock:^(BOOL result) {
    if (result) {
      MSLog(@"Need to load base server information");
      [BaseUrlRequest loadServerInfoForCurrentLocationWithSuccess:^(void) {
//        [self loadWastePointList];
        
      } failure:^(void) {
        MSLog(@"Server info loading fail");
      }];
    }
  }];
}

@end
