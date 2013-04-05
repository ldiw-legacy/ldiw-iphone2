//
//  FBHelper.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/26/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface FBHelper : NSObject

+ (BOOL)FBSessionOpen;
+ (void)openSession;

@end
