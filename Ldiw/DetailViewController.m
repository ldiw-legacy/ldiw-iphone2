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
#import "UIImageView+AFNetworkingJSAdditions.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface DetailViewController ()
@property (strong, nonatomic) UITextField *textInputField;
@property (strong, nonatomic) UITextView *myTextInputView;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UILabel *insertTextLabel;
@property (strong, nonatomic) NSString *selectedFieldName;
@property (strong, nonatomic) NSDictionary *picInfo;

@end

@implementation DetailViewController

@synthesize scrollView, imageView, mapView, textInputField, dimView, myTextInputView, insertTextLabel, wastePoint, selectedFieldName, wastePointViews, editingMode, spinner, takePictureButton, picInfo;


- (id)initWithImageInfo:(NSDictionary *)info {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    [self setEditingMode:YES];
    self.wastePoint = [[Database sharedInstance] addWastePointUsingImage:nil];
    [self.wastePoint setId:nil];
    if (info) {
      self.picInfo = info;
      
      UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
      [self addImageAsynchronously:image];
      
    }
  }
  
  
  return self;
}


- (void) setWPLocationFromPictureInfo:(NSDictionary*)info {
  NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
  
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  
  __block WastePoint *bWastepoint = wastePoint;
  __block MapView *bMapView = mapView;
  
  [library assetForURL:assetURL
           resultBlock:^(ALAsset *asset)  {
             NSDictionary *metadata = asset.defaultRepresentation.metadata;
             NSDictionary *gps = [metadata objectForKey:@"{GPS}"];
             if (gps) {
               bWastepoint.latitude = [gps objectForKey:@"Latitude"];
               bWastepoint.longitude = [gps objectForKey:@"Longitude"];
               MSLog(@"GPS location detected from image, latitude:%@, longitude: %@",[gps objectForKey:@"Latitude"], [gps objectForKey:@"Longitude"]);
               CLLocation *loc = [[CLLocation alloc] initWithLatitude:[bWastepoint.latitude doubleValue] longitude:[bWastepoint.longitude doubleValue]];
               [bMapView centerToLocation:loc];
             } else MSLog(@"NO GPS data detected from image");
           }
          failureBlock:^(NSError *error) {
          }];
}

- (id)initWithWastePoint:(WastePoint *)point andEnableEditing:(BOOL)editingAllowed {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    [self setWastePoint:point];
    [self setEditingMode:editingAllowed];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationItem setHidesBackButton:YES];
  self.tabBarController.tabBar.hidden = YES;
  [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:[[UIScreen mainScreen] bounds]];
  [spinner stopAnimating];
  
  if (wastePoint.id) {
    [takePictureButton setHidden:YES];
    [self displayImage];
  }

  if ([spinner isAnimating]) {
    [self pictureLoadingAppearance];
  }
}

- (void)displayImage {
  UIImage *placeholder = [UIImage imageNamed:@"Default"];
  [imageView setImage:placeholder];
  __weak UIImageView *blockSelf = imageView;
  NSURL *imageUrl = [wastePoint imageRemoteUrl];
  if (imageUrl) {
    [spinner startAnimating];
    [imageView setImageWithURL:imageUrl placeholderImage:placeholder fadeIn:YES finished:^(UIImage *image) {
      MSLog(@"Image loaded %@", imageUrl);
      [spinner stopAnimating];
      
      // TODO: Why this is necessary???
      [blockSelf setImage:image];
    }];
  }
}

- (void) pictureLoadingAppearance {
  self.takePictureButton.alpha = 0;
  [spinner startAnimating];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = kViewBackroundColor;
  
  self.imageView.backgroundColor = kButtonBackgroundColor;
  
  if (!editingMode) {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    title.text = NSLocalizedString(@"wastespot",nil);
    [DesignHelper setNavigationTitleStyle:title];
    [title sizeToFit];
    self.navigationItem.titleView = title;
    [self.navigationItem setHidesBackButton:NO];
    
    UIImage *image = [UIImage imageNamed:@"back_normal.png"];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"back_pressed.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:NSLocalizedString(@"back",nil) forState:UIControlStateNormal];
    [DesignHelper setBarButtonTitleAttributes:cancelButton];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
  } else {
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
  
  [self addWastePointViews];
  [mapView setViewType:ViewTypeSmallMap];
  [mapView setUserInteractionEnabled:NO];
  
  [self setMapviewPosition];
  
}

-(void) setMapviewPosition {
  if (wastePoint.id) {
    [mapView centerToLocation:wastePoint.location];
  } else {
    if ( self.picInfo && self.wastePoint.latitudeValue != 0 && self.wastePoint.longitudeValue != 0) {
      [self setWPLocationFromPictureInfo:picInfo];
    } else {
      [mapView centerToUserLocation];
    }
    
  }
}

- (void) addImageAsynchronouslyShowingSpinner:(UIImage*)image {
  [self pictureLoadingAppearance];
  [self addImageAsynchronously:image];
}

- (void) addImageAsynchronously:(UIImage*)image {
  [spinner startAnimating];
  __block DetailViewController *blockSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *smallImage = [PictureHelper saveImage:image forWastePoint:self.wastePoint];
    MSLog(@"IMGGG%@", image);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      [blockSelf setImageinImageView:smallImage];
      [spinner stopAnimating];
    });
  });
}

-(void) setImageinImageView:(UIImage*) image {
  self.imageView.image = image;
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
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
  [self.navigationController popViewControllerAnimated:NO];
  [self unHideTabbar];
}

- (IBAction)backPressed:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
  [self unHideTabbar];
}

- (void)unHideTabbar {
  self.tabBarController.tabBar.hidden = NO;
  self.tabBarController.selectedIndex = 0;
}

- (IBAction)addPressed:(id)sender
{
  if (self.wastePoint.latitudeValue != 0 && self.wastePoint.longitudeValue != 0) {
    [WastePointUploader uploadAllLocalWPs];
    self.controller.wastePointAddedSuccessfully = YES;
    [self.navigationController popViewControllerAnimated:NO];
  } else if ([[LocationManager sharedManager] locationServicesEnabled]) {
    __block WastePoint *blockWastepoint = wastePoint;
    __block DetailViewController *blockSelf = self;
    
    [[LocationManager sharedManager] locationWithBlock:^(CLLocation *location) {
      [blockWastepoint setLatitudeValue:location.coordinate.latitude];
      [blockWastepoint setLongitudeValue:location.coordinate.longitude];
      [WastePointUploader uploadAllLocalWPs];
      blockSelf.controller.wastePointAddedSuccessfully = YES;
      [blockSelf.navigationController popViewControllerAnimated:NO];
    } errorBlock:^(NSError *error) {
      MSLog(@"Could not get location for map");
      [blockSelf.navigationController popViewControllerAnimated:NO];
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
  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_1"]];
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
  
  self.picInfo = info;
  [self setWPLocationFromPictureInfo:info];
  
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
