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

<<<<<<< HEAD
@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate,UITextFieldDelegate,UITextViewDelegate>
=======
@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate,UITextFieldDelegate>

>>>>>>> 76f57a3ec6823a439f3021e835d8d2f81782b034
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic, strong) WastePoint *wastePoint;


- (IBAction)takePicture:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil usingImage:(UIImage*)image;

@end
