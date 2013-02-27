//
//  PictureHelper.m
//  Ldiw
//
//  Created by Johannes Vainikko on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "PictureHelper.h"
#import "DesignHelper.h"
#import "Image.h"

@implementation PictureHelper

+ (void)saveImage:(UIImage*)image forWastePoint:(WastePoint*)wp {
  CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  //Unique Key
  
  NSString *key = (__bridge NSString *)newUniqueIDString;
  
  NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  
  NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", docDir, key];
  
  MSLog(@"SAVED IMAGE TO: %@", imageFilePath);
  
  
  
  UIImage *resizedImage = [DesignHelper resizeImage:image];
  NSData *dataForJpg = UIImageJPEGRepresentation(resizedImage, 0.7f);
  
  [dataForJpg writeToFile:imageFilePath atomically:YES];
  
  if (wp.image) {
    wp.image.localURL = imageFilePath;
  } else {
    wp.image = [Image newImageWithLocalUrl:imageFilePath];
  }
  
  
  
  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
}


+ (UIImage *)loadImageForWP:(WastePoint*)wp {
  NSData *imgData = [NSData dataWithContentsOfFile:wp.image.localURL];
  return [UIImage imageWithData:imgData];
}



@end
