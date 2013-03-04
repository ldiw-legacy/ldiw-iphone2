//
//  Database+WPField.m
//  Ldiw
//
//  Created by Lauri Eskor on 2/20/13.
//  Copyright (c) 2013 Mobi Solutions. All rights reserved.
//

#import "Database+WPField.h"
#import "AllowedValue.h"
#import "TypicalValue.h"

@implementation Database (WPField)

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
        // Check value
        if([[array objectAtIndex:0] isKindOfClass:[NSNumber class]])
        {
          value = [[array objectAtIndex:0] stringValue];
        }
        else if ([[array objectAtIndex:0] isKindOfClass:[NSString class]])
        {
          value = [array objectAtIndex:0];
        }
        
        // Check key
        if([[array objectAtIndex:1] isKindOfClass:[NSNumber class]])
        {
          key = [[array objectAtIndex:1] stringValue];
        }
        else if ([[array objectAtIndex:1] isKindOfClass:[NSString class]])
        {
          key = [array objectAtIndex:1];
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

- (AllowedValue *)createAllowedValueWithKey:(NSString *)key andValue:(NSString *)value forWPField:(WPField *)wpField
{
  AllowedValue *aValue = [AllowedValue insertInManagedObjectContext:self.managedObjectContext];
  [aValue setKey:key];
  [aValue setValue:value];
  [aValue setWpField:wpField];
  return aValue;
}

- (TypicalValue *)createTypicalValueWithKey:(NSString *)key andValue:(NSString *)value forWPField:(WPField *)wpField
{
  TypicalValue *tValue = [TypicalValue insertInManagedObjectContext:self.managedObjectContext];
  [tValue setKey:key];
  [tValue setValue:value];
  [tValue setWpField:wpField];
  return tValue;
}

- (NSArray *)listAllWPFields {
  NSArray *returnArray = [self listCoreObjectsNamed:@"WPField"];
  return returnArray;
}

- (NSArray *)listFieldsWithComposition:(BOOL)composition {
  NSArray *allFields = [self listAllWPFields];
  NSMutableArray *resultArray = [NSMutableArray array];
  for (WPField *field in allFields) {
    if ([field isCompositionField:composition]) {
      [resultArray addObject:field];
    }
  }
  
  NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSString *first = [(WPField *)a label];
    NSString *second = [(WPField *)b label];
    return [first compare:second];
  }];
  
  return sortedArray;
}

- (NSArray *)listAllCompositionFields {
  return [self listFieldsWithComposition:YES];
}

- (NSArray *)listAllNonCompositionFields {
  return [self listFieldsWithComposition:NO];
}

- (NSArray *)typicalValuesForField:(WPField *)field {
  NSArray *sortedArray = [[field.typicalValues allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSString *first = [(TypicalValue*)a value];
    NSString *second = [(TypicalValue*)b value];
    return [first compare:second options:NSNumericSearch];
  }];
  return sortedArray;
}

- (NSArray *)allowedValuesForField:(WPField *)field {
  NSArray *sortedArray = [[field.allowedValues allObjects] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSString *first = [(AllowedValue*)a value];
    NSString *second = [(AllowedValue*)b value];
    return [first compare:second options:NSNumericSearch];
  }];
  return sortedArray;
}

@end
