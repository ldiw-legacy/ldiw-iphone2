//
//  Constants.h
//  Ldiw
//
//  Created by Lauri Eskor on 2/18/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#ifndef Ldiw_Constants_h
#define Ldiw_Constants_h
#endif

#if DEBUG
#define MSLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define MSLog(s, ...) //
#endif

#define kFirstServerUrl @"http://intranet.letsdoitworld.org/"
#define kServerRequestPath  @"?q=get-api-base-url.json"
