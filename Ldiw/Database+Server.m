//
//  Database+Server.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/19/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+Server.h"
#import "Server.h"
#import "LocationManager.h"

@implementation Database (Server)

- (void)addServerWithBaseUrl:(NSString *)baseUrl andSafeBBox:(NSString *)safeBBox {
  MSLog(@"Save server with baseUrl %@ and bbox %@", baseUrl, safeBBox);
  [self deleteAllWPFields];
  
  // Note that returned api_base_url may or may not include a query portion ('?').
  // This requires correct handling for functions needing GET parameters:
  // if api_base_url includes '?', then additional GET parameters must be appended to URL using '&';
  // otherwise, the first GET parameter must be appended using '?'.
  
  NSString *suffix = @"?";
  NSArray *urlPartsArray = [baseUrl componentsSeparatedByString:@"?"];
  if ([urlPartsArray count] > 1) {
    suffix = [NSString stringWithFormat:@"?%@", [urlPartsArray objectAtIndex:1]];
    baseUrl = [urlPartsArray objectAtIndex:0];
  }
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"baseUrl == %@", baseUrl];
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:predicate];

  if (server) {
    [self.managedObjectContext deleteObject:server];
    
    
  }
  
  server = [Server insertInManagedObjectContext:self.managedObjectContext];
  [server setBaseUrlSuffix:suffix];
  [server setBaseUrl:baseUrl];
  [server setSafeBBox:safeBBox];
  [self saveContext];
}

- (NSString *)serverBaseUrl {
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:nil];
  return server.baseUrl;
}

- (NSString *)serverSuffix {
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:nil];
  return server.baseUrlSuffix;
}

- (NSString *)bBox {
  Server *server = [self findCoreDataObjectNamed:@"Server" withPredicate:nil];
  return server.safeBBox;
}

- (void)deleteAllWPFields {
  NSArray *fields = [self listAllWPFields];
  for (WPField *field in fields) {
    [self.managedObjectContext deleteObject:field];
  }
}

- (WPField *)createWPFieldWithFieldName:(NSString *)fieldName andEditInstructions:(NSString *)editInstructions andLabel:(NSString *)label andMaxValue:(NSNumber *)max andMinValue:(NSNumber *)min andSuffix:(NSString *)suffix andType:(NSString *)type andTypicalValues:(NSArray *)typicalValues andAllowedValues:(NSArray *)allowedValues {
  WPField *wpField = [self findWPFieldWithFieldName:(NSString *)fieldName orLabel:(NSString *)label];
  
  if (!wpField) {
    wpField = [WPField insertInManagedObjectContext:[self managedObjectContext]];
    [wpField setField_name:fieldName];
    [wpField setEdit_instructions:editInstructions];
    [wpField setLabel:label];
    [wpField setMax:max];
    [wpField setMin:min];
    [wpField setSuffix:suffix];
    [wpField setType:type];
    
    if (typicalValues) {
      for (NSArray *array in typicalValues) {
        NSString *key;
        NSString *value;
        // Check key
        if([[array objectAtIndex:0] isKindOfClass:[NSNumber class]])
        {
          key = [[array objectAtIndex:0] stringValue];
        }
        else if ([[array objectAtIndex:0] isKindOfClass:[NSString class]])
        {
          key = [array objectAtIndex:0];
        }
        
        // Check value
        if([[array objectAtIndex:1] isKindOfClass:[NSNumber class]])
        {
          value = [[array objectAtIndex:1] stringValue];
        }
        else if ([[array objectAtIndex:1] isKindOfClass:[NSString class]])
        {
          value = [array objectAtIndex:1];
        }
        [self createTypicalValueWithKey:key andValue:value forWPField:wpField];
      }
    }
    
    if (allowedValues) {
      for (NSArray *array in allowedValues) {
        NSString *key;
        NSString *value;
        // Check key
        if([[array objectAtIndex:0] isKindOfClass:[NSNumber class]])
        {
          key = [[array objectAtIndex:0] stringValue];
        }
        else if ([[array objectAtIndex:0] isKindOfClass:[NSString class]])
        {
          key = [array objectAtIndex:0];
        }
        
        // Check value
        if([[array objectAtIndex:1] isKindOfClass:[NSNumber class]])
        {
          value = [[array objectAtIndex:1] stringValue];
        }
        else if ([[array objectAtIndex:1] isKindOfClass:[NSString class]])
        {
          value = [array objectAtIndex:1];
        }
        
        [self createAllowedValueWithKey:key andValue:value forWPField:wpField];
      }
    }
    [self saveContext];
  }
  
  return wpField;
}

- (WPField *)findWPFieldWithFieldName:(NSString *)fieldName orLabel:(NSString *)label 
{
  if (!fieldName) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label == %@", label];
    WPField *wpField = [self findCoreDataObjectNamed:@"WPField" withPredicate:predicate];
    return wpField;
  } else {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"field_name == %@", fieldName];
    WPField *wpField = [self findCoreDataObjectNamed:@"WPField" withPredicate:predicate];
    return wpField;
  }
}

- (TypicalValue *)createTypicalValueWithKey:(NSString *)key andValue:(NSString *)value forWPField:(WPField *)wpField
{
  TypicalValue *tValue = [TypicalValue insertInManagedObjectContext:self.managedObjectContext];
  [tValue setKey:key];
  [tValue setValue:value];
  [tValue setWpField:wpField];
  return tValue;
}

- (AllowedValue *)createAllowedValueWithKey:(NSString *)key andValue:(NSString *)value forWPField:(WPField *)wpField
{
  AllowedValue *aValue = [AllowedValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setKey:key];
  [aValue setValue:value];
  [aValue setWpField:wpField];
  return aValue;
}

- (NSArray *)listAllWPFields {
  NSArray *returnArray = [self listCoreObjectsNamed:@"WPField"];
  return returnArray;
}

- (void)needToLoadServerInfotmationWithBlock:(void (^)(BOOL))resultBlock {
  [[LocationManager sharedManager] currentLocationIsInsideBox:[self bBox] withResultBlock:^(BOOL locationIsInsideBox) {
    NSString *baseUrl = [self serverBaseUrl];
    BOOL serverInfoIsAvailable = (baseUrl.length == 0);
    BOOL needToLoadServerInfo = !serverInfoIsAvailable || !locationIsInsideBox;
    resultBlock(needToLoadServerInfo);
  }];
}

@end
