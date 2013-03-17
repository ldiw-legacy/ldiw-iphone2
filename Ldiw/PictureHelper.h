//
//  PictureHelper.h
//  Ldiw
//
//  Created by Johannes Vainikko on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WastePoint.h"


@interface PictureHelper : NSObject

+ (UIImage*) saveImage:(UIImage*)image forWastePoint:(WastePoint*)wp;
+ (UIImage *)loadImageForWP:(WastePoint*)wp;
+ (void) saveImage:(UIImage *)image withFileName:(NSString *)imageName;
+ (UIImage *)thumbinalForWastePoint:(WastePoint *)point;

@end
