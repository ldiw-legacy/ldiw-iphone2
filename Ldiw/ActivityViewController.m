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

#define kTitlePositionAdjustment 8.0

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
 
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"titlebar_bg"]]];
  UIImage *image = [UIImage imageNamed:@"logo_titlebar"];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];

  //Segmented control in headerview
 
  UIImage *image2=[UIImage imageNamed:@"feed_subtab_bg"];
  self.headerView =[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, image2.size.width, image2.size.height)];
  [self.view addSubview:self.headerView];
  [self.headerView.nearbyButton addTarget:self action:@selector(nearbyPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.friendsButton addTarget:self action:@selector(friendsPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.headerView.showMapButton addTarget:self action:@selector(showMapPressed:) forControlEvents:UIControlEventTouchUpInside];
  MSLog(@"%@", [[Database sharedInstance] listAllWPFields]);
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

  UITabBar *tabbar=self.tabBarController.tabBar;
  tabbar.clipsToBounds=NO;

  UIImage *selectedImage0=[UIImage imageNamed:@"tab_feed_pressed"];
  UIImage *unselctedImage0=[UIImage imageNamed:@"tab_feed_normal"];

  UIImage *selectedImage1=[UIImage imageNamed:@"tab_addpoint_pressed"];
  UIImage *unselctedImage1=[UIImage imageNamed:@"tab_addpoint_normal"];

  UIImage *selectedImage2=[UIImage imageNamed:@"tab_account_pressed"];
  UIImage *unselctedImage2=[UIImage imageNamed:@"tab_account_normal"];

  UITabBarItem *item0 = [tabbar.items objectAtIndex:0];
  UITabBarItem *item1 = [tabbar.items objectAtIndex:1];
  UITabBarItem *item2 = [tabbar.items objectAtIndex:2];
  [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselctedImage0];
  [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselctedImage1];
  [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselctedImage2];


  item0.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item1.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item2.titlePositionAdjustment = UIOffsetMake(0, -kTitlePositionAdjustment);
  item0.title = NSLocalizedString(@"Activity", nil);
  item1.title = NSLocalizedString(@"NewPoint", nil);
  item2.title = NSLocalizedString(@"My Account", nil);
}
- (void)didReceiveMemoryWarning
  
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}
- (IBAction)segmentedControl:(id)sender {
}
@end
