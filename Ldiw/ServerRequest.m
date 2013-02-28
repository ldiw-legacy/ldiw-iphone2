//
//  ServerRequest.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "ServerRequest.h"
#import "Database+Server.h"
#import "Database+WPField.h"
#import "Server.h"

#define kGetWPFieldsPath @"waste-point-extra-fields.json"

@implementation ServerRequest

+ (void)getWPFieldsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
  // URL: GET <api_base_url>/waste-point-extra-fields.json
  [[self sharedHTTPClient] getPath:kGetWPFieldsPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSError *jsonError;
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
    Server *server = [[Database sharedInstance] currentServer];
    
    for (NSDictionary *wpDict in responseArray ) {
      NSString *fieldName = [wpDict objectForKey:kFieldNameKey];
      NSString *editInstructions = [wpDict objectForKey:kEditInstructionsKey];
      NSString *label = [wpDict objectForKey:kLabelKey];
      NSString *suffix = [wpDict objectForKey:kSuffixKey];
      NSString *type = [wpDict objectForKey:kTypeKey];
      NSNumber *max = [wpDict objectForKey:kMaxKey];
      NSNumber *mix = [wpDict objectForKey:kMinKey];
      NSArray *typicalValues = [wpDict objectForKey:kTypicalValuesKey];
      NSArray *allowedValues = [wpDict objectForKey:kAllowedValuesKey];
      
      WPField *fieldToAdd = [[Database sharedInstance] createWPFieldWithFieldName:fieldName andEditInstructions:editInstructions andLabel:label andMaxValue:max andMinValue:mix andSuffix:suffix andType:type andTypicalValues:typicalValues andAllowedValues:allowedValues];
      [server addFieldsObject:fieldToAdd];
    }
    
    success(responseArray);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
  
}

@end
