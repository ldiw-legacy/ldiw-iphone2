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
#import "PictureHelper.h"
#import "Image.h"

#define kViewBackroundColor [UIColor colorWithRed:0.894 green:0.894 blue:0.894 alpha:1] /*#e4e4e4*/
#define kButtonBackgroundColor [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1] /*#d2d2d2*/

@implementation DetailViewController
@synthesize scrollView, imageView, mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil usingImage:(UIImage*)image
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.wastePoint = [WastePoint newWastePointUsingImage:image];
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
  self.view.backgroundColor = kViewBackroundColor;
  self.imageView.backgroundColor = kButtonBackgroundColor;
  UIImage *image = [UIImage imageNamed:@"cancel_normal.png"];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
  [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_pressed.png"] forState:UIControlStateHighlighted];
  [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitle:NSLocalizedString(@"cancel",nil) forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:cancelButton];

  UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  self.navigationItem.leftBarButtonItem = cancelBarButton;
  
  UIImage *addimage = [UIImage imageNamed:@"blue_normal.png"];
  UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
  addButton.bounds = CGRectMake( 0, 0, addimage.size.width, addimage.size.height );
  [addButton setBackgroundImage:addimage forState:UIControlStateNormal];
  [addButton setBackgroundImage:[UIImage imageNamed:@"blue_pressed.png"] forState:UIControlStateHighlighted];
  [addButton addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
  [addButton setTitle:NSLocalizedString(@"add", nil)  forState:UIControlStateNormal];
  [DesignHelper setBarButtonTitleAttributes:addButton];

  UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
  self.navigationItem.rightBarButtonItem = addBarButton;

  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
  title.text = NSLocalizedString(@"addNewTitle", nil);
  [DesignHelper setNavigationTitleStyle:title];
  [title sizeToFit];
  self.navigationItem.titleView = title;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setTakePictureButton:nil];
  [super viewDidUnload];
}

- (IBAction)cancelPressed:(id)sender
{
  //Do some cleaning here
  [self.navigationController popViewControllerAnimated:YES];
  self.tabBarController.tabBar.hidden = NO;
  self.tabBarController.selectedIndex = 0;
}
- (IBAction)addPressed:(id)sender
{

}

- (IBAction)takePicture:(id)sender {

  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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


  UIImage *resizedImage = [DesignHelper resizeImage:cameraImage];
  NSData *dataForJpg = UIImageJPEGRepresentation(resizedImage, 0.7);


  //ToDo: save to documents

  //ToDo: save image to database with unique key

  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  [self dismissViewControllerAnimated:YES completion:nil];
  self.imageView.image = cameraImage;
  self.takePictureButton.alpha = 0;
  
  
}


@end
