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

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic, strong) WastePoint *wastePoint;
@property (weak, nonatomic) ActivityViewController *controller;


- (IBAction)takePicture:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil usingImage:(UIImage*)image;

@end
