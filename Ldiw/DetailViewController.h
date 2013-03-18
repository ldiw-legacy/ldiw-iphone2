//
//  DetailViewController.h
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>
#import "WastePoint.h"
#import "ActivityViewController.h"
#import "WastePointViews.h"
#import "FieldView.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate,UITextFieldDelegate, UITextViewDelegate, FieldDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic, strong) WastePoint *wastePoint;
@property (weak, nonatomic) ActivityViewController *controller;
@property (nonatomic, strong) WastePointViews *wastePointViews;
@property (nonatomic, assign) BOOL editingMode;

- (IBAction)takePicture:(id)sender;

- (id)initWithImage:(UIImage *)image;
- (id)initWithWastePoint:(WastePoint *)point andEnableEditing:(BOOL)editingAllowed;

@end
