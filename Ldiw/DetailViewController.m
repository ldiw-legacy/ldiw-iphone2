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
#import "WastePointViews.h"
#import "Database+WP.h"
#import "Database+WPField.h"
#import "WastePointUploader.h"
#import "Database+Server.h"
#import "Constants.h"
#import "CustomValue.h"

@interface DetailViewController ()
@property (strong, nonatomic) UITextField *textInputField;
@property (strong, nonatomic) UITextView *myTextInputView;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UILabel *insertTextLabel;
@property (strong, nonatomic) NSString *selectedFieldName;
@property (strong, nonatomic) UIActivityIndicatorView *pictureLoading;

@end

@implementation DetailViewController

@synthesize scrollView, imageView, mapView, textInputField, dimView, myTextInputView, insertTextLabel, wastePoint, selectedFieldName, wastePointViews, pictureLoading;

- (id)initWithImage:(UIImage *)image {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.wastePoint = [[Database sharedInstance] addWastePointUsingImage:nil];
    [self.wastePoint setIdValue:0];
    self.view.backgroundColor = kViewBackroundColor;
    if (image) {
      [self addImageAsynchronously:image];
      self.pictureLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
  }
  return self;
}

- (id)initWithWastePoint:(WastePoint *)point {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    [self setWastePoint:point];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationItem setHidesBackButton:YES];
  self.tabBarController.tabBar.hidden=YES;
  [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:[[UIScreen mainScreen] bounds]];
  
  if (self.pictureLoading) {
    [self pictureLoadingAppearance];
  }
}

- (void) pictureLoadingAppearance {
  self.takePictureButton.alpha = 0;
  if (!self.pictureLoading) {
    self.pictureLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  }
  self.pictureLoading.frame = self.imageView.frame;
  [self.imageView addSubview:self.pictureLoading];
  [self.pictureLoading startAnimating];
}

- (void) pictureLoaded {
  if (self.pictureLoading) {
    [self.pictureLoading stopAnimating];
    [self.pictureLoading removeFromSuperview];
    self.pictureLoading = nil;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
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
  
  [self addWastePointViews];
  
  if (wastePoint.idValue != 0) {
    [mapView centerToLocation:wastePoint.location];
  } else {
    [mapView centerToUserLocation];
  }
}


- (void) addImageAsynchronouslyShowingSpinner:(UIImage*)image {
  [self pictureLoadingAppearance];
  [self addImageAsynchronously:image];
}

- (void) addImageAsynchronously:(UIImage*)image {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *smallImage = [PictureHelper saveImage:image forWastePoint:self.wastePoint];
    dispatch_sync(dispatch_get_main_queue(), ^{
      [self setImageinImageView:smallImage];
      [self pictureLoaded];
    });
  });
}

-(void) setImageinImageView:(UIImage*) image {
  self.imageView.image = image;
  self.takePictureButton.alpha = 0;
}


- (void)addWastePointViews {
  WastePointViews *wpViews = [[WastePointViews alloc] initWithWastePoint:wastePoint andDelegate:self];
  CGRect wpViewsRect = CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height, wpViews.frame.size.width, wpViews.frame.size.height);
  [wpViews setFrame:wpViewsRect];
  [scrollView addSubview:wpViews];
  
  CGSize oldSize = scrollView.contentSize;
  CGSize newSize = CGSizeMake(oldSize.width, oldSize.height + wpViews.frame.size.height + wpViews.frame.origin.y);
  [self.scrollView setContentSize:newSize];
  [self.scrollView addSubview:wpViews];
  [self setWastePointViews:wpViews];
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
  [self.navigationController popViewControllerAnimated:NO];
  self.tabBarController.tabBar.hidden = NO;
  self.tabBarController.selectedIndex = 0;
}

- (IBAction)addPressed:(id)sender
{
  if ([[LocationManager sharedManager] locationServicesEnabled]) {
    [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
      [wastePoint setLatitudeValue:location.coordinate.latitude];
      [wastePoint setLongitudeValue:location.coordinate.longitude];
      [WastePointUploader uploadAllLocalWPs];
      self.controller.wastePointAddedSuccessfully = YES;
      [self.navigationController popViewControllerAnimated:NO];      
    } errorBlock:^(NSError *error) {
      MSLog(@"Could not get location for map");
      [self.navigationController popViewControllerAnimated:NO];
    }];
  } else {
    [self showHudWarning];
  }
}

- (void)showHudWarning
{
  MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
  
  [self.view addSubview:hud];
  hud.delegate = self;
  hud.customView = [[UIImageView alloc] initWithImage:
                    [UIImage imageNamed:@"pin_1"]];
  hud.mode = MBProgressHUDModeCustomView;
  hud.opacity = 0.5;
  hud.detailsLabelText = @"LDIW needs permission to see your location to add wastepoint";
  [hud showWhileExecuting:@selector(waitForSomeSeconds)
                 onTarget:self withObject:nil animated:YES];
}

- (void)waitForSomeSeconds {
  sleep(3);
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
  
  [self dismissViewControllerAnimated:YES completion:nil];
  [self addImageAsynchronouslyShowingSpinner:cameraImage];
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


-(IBAction)confirmPressed:(id)sender {
  [self.wastePointViews deselectAllTicsForField:self.selectedFieldName];
  self.navigationController.navigationBarHidden = NO;
  self.navigationController.navigationBar.alpha = 1;
  [self.insertTextLabel removeFromSuperview];
  [self.dimView removeFromSuperview];
  
  if ([self.myTextInputView isFirstResponder]) {
    NSString *str = [self.wastePoint setValue:self.myTextInputView.text forCustomField:self.selectedFieldName];
    [self.wastePointViews setValue:str forField:selectedFieldName];
    [myTextInputView resignFirstResponder];
  } else {
    NSString *str = [self.wastePoint setValue:self.textInputField.text forCustomField:self.selectedFieldName];
    [self.wastePointViews setValue:str forField:selectedFieldName];
    [textInputField resignFirstResponder];
  }
  
  textInputField=nil;
  myTextInputView=nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:(BOOL)animated];
  
  textInputField = nil;
  myTextInputView = nil;
  dimView = nil;
  insertTextLabel = nil;
}


- (void)showCustomNumPad {
  UITextField *textfield = [[UITextField alloc] init];
  textfield.delegate = self;
  [self.view addSubview:textfield];
  
  UIView *mytoolbar = [self keyboardAccessoryView];
  textfield.inputAccessoryView = mytoolbar;
  [textfield becomeFirstResponder];
  textfield.keyboardType = UIKeyboardTypeDecimalPad;
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

- (void)showCustomTextPad {
  UITextView *textView = [[UITextView alloc]init];
  textView.delegate = self;
  [self.view addSubview:textView];
  
  UIView *mytoolbar = [self keyboardAccessoryView];
  textView.inputAccessoryView = mytoolbar;
  [textView becomeFirstResponder];
  if (!myTextInputView) {
    self.myTextInputView = [[UITextView alloc]init];
  }
  self.myTextInputView.delegate = self;
  self.myTextInputView.scrollEnabled = YES;
  self.myTextInputView.keyboardType = UIKeyboardTypeDefault;
  self.myTextInputView.frame = CGRectMake(15, 20, 185, 50);
  
  self.myTextInputView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
  [mytoolbar addSubview:myTextInputView];
  [self.myTextInputView becomeFirstResponder];
  [textView resignFirstResponder];
}

#pragma mark - FieldDelegate
- (void)checkedValue:(NSString *)value forField:(NSString *)fieldName {
  NSString *str = [wastePoint setValue:value forCustomField:fieldName];
  [self.wastePointViews setValue:str forField:fieldName];
}

- (void)addDataPressedForField:(NSString *)fieldName {
  [self setSelectedFieldName:fieldName];
  WPField *field = [[Database sharedInstance] findWPFieldWithFieldName:fieldName orLabel:nil];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fieldName == %@", fieldName];
  NSSet *s = [self.wastePoint.customValues filteredSetUsingPredicate:predicate];
  CustomValue *cv;
  if (s.count == 1) {
    cv = [s anyObject];
  }
  
  if ([field.type isEqualToString:@"text"]) {
    [self showCustomTextPad];
    self.myTextInputView.text = cv.value;
  } else {
    [self showCustomNumPad];
    self.textInputField.text = cv.value;
  }
}

@end
