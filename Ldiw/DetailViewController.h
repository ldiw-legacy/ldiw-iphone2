//
//  DetailViewController.h
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
