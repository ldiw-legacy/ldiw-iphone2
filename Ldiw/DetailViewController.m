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
@interface DetailViewController ()
@property (strong, nonatomic) UITextField *textInputField;
@property (strong, nonatomic) UITextView *myTextInputView;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UILabel *insertTextLabel;
@end


@implementation DetailViewController 


@synthesize scrollView, imageView, mapView, textInputField, dimView,myTextInputView;

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

  UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
  title.text=NSLocalizedString(@"addNewTitle", nil);
  [DesignHelper setNavigationTitleStyle:title];
  [title sizeToFit];
  self.navigationItem.titleView = title;

  



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
  //Do some cleaning here
  [self.navigationController popViewControllerAnimated:YES];
  self.tabBarController.tabBar.hidden = NO;
  self.tabBarController.selectedIndex = 0;
}
- (IBAction)addPressed:(id)sender
{
  /*
  UITextField *textfield=[[UITextField alloc] init];
  textfield.delegate=self;
  [self.view addSubview:textfield];
  //[self showCustomKeyboard:textfield];
  [self showCustomNumPad:textfield];
  */
  UITextView *textview=[[UITextView alloc]init];
  textview.delegate=self;
  [self.view addSubview:textview];
  [self showCustomTextPad:textview];
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


- (UIView *)keyboardAccessoryView {
  //Leftimage
  CGRect leftRect = CGRectMake(0, 0, 215, 100);
  CGRect rect = CGRectMake( 0, 0, 320, 100);
  UIToolbar *tbar = [[UIToolbar alloc] initWithFrame:rect];
  UIImageView *lefbar = [[UIImageView alloc]initWithFrame:leftRect];
  lefbar.image = [UIImage imageNamed:@"inputfield_element"];
  [tbar addSubview:lefbar];

  //Dim
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  self.dimView = [[UIView alloc] initWithFrame:screenRect];
  self.dimView.backgroundColor = [UIColor blackColor];
  [self.view addSubview:self.dimView];
  dimView.alpha = 0;
  [UIView animateWithDuration:0.5
                   animations:^{self.dimView.alpha = 0.75;}
                   completion:^(BOOL finished) {

                   }];

  self.navigationController.navigationBarHidden = YES;

  self.insertTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 100)];
  [self.view addSubview:self.insertTextLabel];
  self.insertTextLabel.text = @"Enter Comment";
  self.insertTextLabel.textColor = [UIColor whiteColor];
  self.insertTextLabel.font = [UIFont fontWithName:@"Caecilia-Heavy" size:28];
  self.insertTextLabel.textAlignment = UITextAlignmentCenter;
  self.insertTextLabel.backgroundColor = [UIColor clearColor];


  //Button
  UIImage *confirmImage = [UIImage imageNamed:@"confirm_input_normal.png"];
  UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmButton.frame = CGRectMake(216, 0, confirmImage.size.width, confirmImage.size.height);
  [confirmButton setBackgroundImage:confirmImage forState:UIControlStateNormal];
  [confirmButton setBackgroundImage:[UIImage imageNamed:@"confirm_input_pressed.png"] forState:UIControlStateHighlighted];
  [confirmButton addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];

  [tbar addSubview:confirmButton];
  return tbar;
  
}

- (void)showCustomNumPad:(UITextField *)textfield
{
  UIView *mytoolbar=[self keyboardAccessoryView];
  textfield.inputAccessoryView = mytoolbar;
  [textfield becomeFirstResponder];
  textfield.keyboardType=UIKeyboardTypeDecimalPad;
  self.insertTextLabel.text = @"Enter value";
  self.textInputField = [[UITextField alloc]init];
  textInputField.font = [UIFont fontWithName:@"Caecilia-Heavy" size:38];
  textInputField.adjustsFontSizeToFitWidth = YES;
  textInputField.delegate = self;
  textInputField.frame = CGRectMake(25, 25, 175, 60);
  textInputField.keyboardType = UIKeyboardTypeDecimalPad;
  textInputField.keyboardAppearance = UIKeyboardAppearanceDefault;
  [mytoolbar addSubview:textInputField];
  [textInputField becomeFirstResponder];
}

- (void)showCustomTextPad:(UITextView *)textView
{
  UIView *mytoolbar=[self keyboardAccessoryView];
  textView.inputAccessoryView = mytoolbar;
  [textView becomeFirstResponder];
  self.myTextInputView = [[UITextView alloc]init];
  self.myTextInputView.delegate = self;
  self.myTextInputView.keyboardType=UIKeyboardTypeDefault;
  self.myTextInputView.frame = CGRectMake(15, 20, 175, 50);
  self.myTextInputView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
  [mytoolbar addSubview:myTextInputView];
  [self.myTextInputView becomeFirstResponder];
  [textView resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  NSLog(@"textInputView %@",myTextInputView.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSLog(@"textInputField %@",textInputField.text);
}


-(IBAction)confirmPressed:(id)sender {

  self.navigationController.navigationBarHidden = NO;
  self.navigationController.navigationBar.alpha = 1;
  [self.insertTextLabel removeFromSuperview];
  [self.dimView removeFromSuperview];
  [textInputField resignFirstResponder];
  [myTextInputView resignFirstResponder];

}


@end
