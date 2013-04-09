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
#import "Database+Image.h"

@implementation PictureHelper

+ (UIImage*) saveImage:(UIImage*)image forWastePoint:(WastePoint*)wp {
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
  
  Image *dbImage = [[Database sharedInstance] newImageWithLocalUrl:imageFilePath];
  [wp addImagesObject:dbImage];
  
  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  return resizedImage;
}

+ (UIImage *)loadImageForWP:(WastePoint*)wp {
  Image *anImage = [wp.images anyObject];
  NSData *imgData = [NSData dataWithContentsOfFile:anImage.localURL];
  return [UIImage imageWithData:imgData];
}

+ (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachePath = [paths objectAtIndex:0];
  [UIImagePNGRepresentation(image) writeToFile:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
  
}

+ (UIImage *)thumbinalForWastePoint:(WastePoint *)point
{
  NSString *wastpointID = [NSString stringWithFormat:@"%@", point.id];
  UIImage *thumbinal = nil;
  NSString *cachedImageName = [wastpointID stringByAppendingString:@".png"];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachePath = [paths objectAtIndex:0];
  NSString *uniquePath = [cachePath stringByAppendingPathComponent:cachedImageName];
  if([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
  {
    thumbinal = [UIImage imageWithContentsOfFile:uniquePath];
  } else {
    Image *wpImage = [point.images anyObject];
    NSString *trimmedString = wpImage.remoteURL;
    if (trimmedString.length > 3) {
      NSString *imageUrlString = [kFirstServerUrl stringByAppendingString:[kImageURLPath stringByAppendingString:wastpointID]];
      NSString *imageUrlExtended = [imageUrlString stringByAppendingString:@"/"];
      NSString *imageUrlFullString = [imageUrlExtended stringByAppendingString:trimmedString];
      NSURL *imageUrl = [NSURL URLWithString:imageUrlFullString];
      NSData *data = [NSData dataWithContentsOfURL:imageUrl];
      UIImage *image = [UIImage imageWithData:data];
      thumbinal = [DesignHelper wastePointImage:image];
      
      [PictureHelper saveImage:thumbinal withFileName:wastpointID];
    }
  }
  return thumbinal;
}

@end
