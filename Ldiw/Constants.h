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
  #define kFirstServerUrl @"http://test.letsdoitworld.org/"
#else
  #define kFirstServerUrl @"http://api.letsdoitworld.org/"
  #define MSLog(s, ...) //
#endif

#define kServerRequestPath  @"?q=get-api-base-url.json"

#define kLanguageCodeKey @"language_code"

#define kNotifycationUserDidExitRegion @"kNotifycatoinUserDidExitRegion"

#define kAccessTokenKey @"access_token"
#define kFBUIDKey @"fb_uid"

#define kUserAlreadyLoggedInErrorCode 406

// Dictionary keys
#define kFieldNameKey @"field_name"
#define kLabelKey @"label"
#define kMaxKey @"max"
#define kMinKey @"min"
#define kSuffixKey @"suffix"
#define kTypeKey @"type"
#define kEditInstructionsKey @"edit_instructions"
#define kTypicalValuesKey @"typical_values"
#define kAllowedValuesKey @"allowed_values"

// FONTS
#define kFontNameBold @"HelveticaNeue-Bold"
#define kFontName @"HelveticaNeue"
#define kWPLabelTextSize 13
#define kWPDescripttionTextSize 11

// COLORS
#define kWPFieldBgColor [UIColor colorWithRed:0.886 green:0.886 blue:0.886 alpha:1]

#define kNotificationShowHud @"showHud"
#define kNotificationRemoveHud @"removeHud"
