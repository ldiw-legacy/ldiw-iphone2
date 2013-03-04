//
//  WastePointUploader.h
//  Ldiw
//
//  Created by Johannes Vainikko on 2/28/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "LoginClient.h"
#import "WastePoint.h"

@interface WastePointUploader : LoginClient

+ (void)uploadWP:(WastePoint *)point withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;



@end
