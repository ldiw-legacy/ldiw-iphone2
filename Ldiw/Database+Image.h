//
//  Database+Image.h
//  Ldiw
//
//  Created by Lauri Eskor on 3/1/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database.h"
#import "Image.h"

@interface Database (Image)

- (Image *)newImageWithLocalUrl:(NSString*)localURL;
- (Image *)imageWithRemoteUrl:(NSString *)remoteUrl;

@end
