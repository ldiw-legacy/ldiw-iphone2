//
//  WastePointUploader.h
//  Ldiw
//
//  Created by Johannes Vainikko on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "WastePoint.h"

@interface WastePointUploader : NSObject;

+ (void)uploadWP:(WastePoint *)point withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

+ (void)uploadAllLocalWPs;

@end
