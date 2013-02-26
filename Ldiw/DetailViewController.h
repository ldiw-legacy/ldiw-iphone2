//
//  DetailViewController.h
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <UINavigationBarDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;

- (IBAction)takePicture:(id)sender;

@end
