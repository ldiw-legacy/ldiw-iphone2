//
//  DetailViewController.m
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationManager.h"
#import "DesignHelper.h"
#define kViewBackroundColor [UIColor colorWithRed:0.894 green:0.894 blue:0.894 alpha:1] /*#e4e4e4*/
#define kButtonBackgroundColor [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1] /*#d2d2d2*/

@implementation DetailViewController
@synthesize scrollView, imageView, mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationItem setHidesBackButton:YES];
  
}

- (void)viewDidLoad
{
  
  [super viewDidLoad];
  self.tabBarController.tabBar.hidden = YES;
  self.view.backgroundColor=kViewBackroundColor;
  self.imageView.backgroundColor=kButtonBackgroundColor;
  UIImage *image = [UIImage imageNamed:@"cancel_normal.png"];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
  [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_pressed.png"] forState:UIControlStateHighlighted];
  [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:cancelButton];




  UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  self.navigationItem.leftBarButtonItem = cancelBarButton;

  
  UIImage *addimage = [UIImage imageNamed:@"blue_normal.png"];
  UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
  addButton.bounds = CGRectMake( 0, 0, addimage.size.width, addimage.size.height );
  [addButton setBackgroundImage:addimage forState:UIControlStateNormal];
  [addButton setBackgroundImage:[UIImage imageNamed:@"blue_pressed.png"] forState:UIControlStateHighlighted];
  [addButton addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
  [addButton setTitle:@"Add" forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:addButton];

  UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
  self.navigationItem.rightBarButtonItem = addBarButton;



    // Do any additional setup after loading the view from its nib.

  [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
    [self createMapViewWithCoordinate:location];
  } errorBlock:^(NSError *error) {
    
  }];
}

- (void)createMapViewWithCoordinate:(CLLocation *)location {
  MSLog(@"Zoom map to region");
  // TODO: Why is mapview frame height zero??
//  [mapView setFrame:CGRectMake(166, 15, 140, 140)];
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.002, 0.004);
  MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location.coordinate, mapSpan);
  [mapView setRegion:mapRegion animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
  MSLog(@"new mapView to new region");
  MKCoordinateRegion region = aMapView.region;
  MSLog(@"Mapview region delta: %g %g", region.span.latitudeDelta, region.span.longitudeDelta);
}
- (void)viewDidUnload {
  [self setTakePictureButton:nil];
  [super viewDidUnload];
}
- (IBAction)cancelPressed:(id)sender
{
  
}

- (IBAction)addPressed:(id)sender
{

}

- (IBAction)takePicture:(id)sender {

  UIImagePickerController *picker=[[UIImagePickerController alloc] init];
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
  {
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
  } else {[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary]; }

  picker.delegate = self;
  [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  //Unique Key

  NSString *key = (__bridge NSString *)newUniqueIDString;

  //ToDo: resize image

  UIImage *resizedImage = [DesignHelper resizeImage:cameraImage];
  NSData *dataForJpg = UIImageJPEGRepresentation(resizedImage, 0.7);

  //ToDo: set image imageview on detailview:

  //ToDo: save to documents

  //ToDo: save image to database with unique key

  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  [self dismissViewControllerAnimated:YES completion:nil];
  self.imageView.image = cameraImage;
  self.takePictureButton.alpha = 0;
  
  
}


@end
