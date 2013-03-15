//
//  Database+Image.m
//  Ldiw
//
//  Created by Lauri Eskor on 3/1/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+Image.h"

@implementation Database (Image)

- (Image *)findImageWIthRemoteUrl:(NSString *)remoteUrl {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteURL == %@", remoteUrl];
  return [self findCoreDataObjectNamed:@"Image" withPredicate:predicate];
}

- (Image *)newImageWithLocalUrl:(NSString*)localURL {
  Image *img = [Image insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
  img.localURL = localURL;
  return img;
}

- (Image *)imageWithRemoteUrl:(NSString*)remoteUrl {
  Image *image = [self findImageWIthRemoteUrl:remoteUrl];
  if (!image) {
    image = [Image insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
    [image setRemoteURL:remoteUrl];
  }
  return image;
}

@end
