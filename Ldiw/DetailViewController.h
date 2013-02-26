//
//  DetailViewController.h
//  Ldiw
//
//  Created by sander on 2/25/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (weak,nonatomic) id delegate;

@end
