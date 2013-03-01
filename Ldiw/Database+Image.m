//
//  Database+Image.m
//  Ldiw
//
//  Created by Lauri Eskor on 3/1/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+Image.h"

@implementation Database (Image)

- (Image *)newImageWithLocalUrl:(NSString*)localURL {
  Image *img = [Image insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  img.localURL = localURL;
  return img;
}

@end
