#import "WastePoint.h"
#import "CustomValue.h"
#import "Database.h"
#import "Database+WP.h"
#import "Database+WPField.h"
#import "Database+User.h"
#import "WPField.h"
#import "Image.h"

@implementation WastePoint


-(long) capInt:(long)num from:(long)min toMax:(long)max {
  
  if (num >= max) {
    num = max;
  } else if (num <= min) {
    num = min;
  }
  return num;
}


-(float)capFloat:(float)num from:(float)min toMax:(float)max {
  if (num >= max) {
    num = max;
  } else if (num <= min) {
    num = min;
  }
  return num;
}



// Custom logic goes here.
- (NSString*)setValue:(NSString *)newValue forCustomField:(NSString *)fieldName {
  
  WPField *wpF = [[Database sharedInstance] findWPFieldWithFieldName:fieldName orLabel:nil];
  NSString *returnString = newValue;
  
  if ([wpF.type isEqualToString:@"integer"]) {
    int num = [newValue intValue];
    if (wpF.min || wpF.max) {
      num = [self capInt:num from:wpF.minValue toMax:wpF.maxValue];
    }
    returnString = [NSString stringWithFormat:@"%d", num];
  } else if ([wpF.type isEqualToString:@"float"]) {
    NSString *replacedString = [newValue stringByReplacingOccurrencesOfString:@"," withString:@"."];
    float num = [replacedString floatValue];
    if (wpF.min || wpF.max) {
      num = [self capFloat:num from:[wpF.min floatValue] toMax:[wpF.max floatValue]];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:5];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    returnString = [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
  }
  
  NSString *valueString = [returnString stringByReplacingOccurrencesOfString:@"," withString:@"."];
  for (CustomValue* value in self.customValues) {
    if ([value.fieldName isEqualToString:fieldName]) {
      MSLog(@"Change value for field '%@' to '%@'", fieldName, valueString);
      [value setValue:valueString];
      return newValue;
    }
  }
  
  CustomValue *value = [[Database sharedInstance] customValueWithKey:fieldName andValue:valueString];
  [self addCustomValuesObject:value];
  MSLog(@"Added new customValue '%@' to point", fieldName);
  
  return returnString;
}

- (NSString *)description {
  NSString *returnString = [NSString stringWithFormat:@"id = %@\nlat = %f\nlon = %f\nnrPhotos = %d\nDistance = %f\nnrNodes = %d\nviewType = %d", self.id, self.latitudeValue, self.longitudeValue, [self.images count], self.distanceValue, self.nrOfNodesValue, self.viewTypeValue];
  NSMutableString *customValuesString = [NSMutableString string];
  
  for (CustomValue *value in self.customValues) {
    [customValuesString appendString:[NSString stringWithFormat:@"%@ = %@\n", value.fieldName, value.value]];
  }
  return [NSString stringWithFormat:@"%@\n%@", returnString, customValuesString];
}

- (CLLocation *)location {
  CLLocation *returnLocation = [[CLLocation alloc] initWithLatitude:self.latitudeValue longitude:self.longitudeValue];
  return returnLocation;
}

- (NSString *)displayDescription {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fieldName == %@", @"description"];
  NSSet *set = [self.customValues filteredSetUsingPredicate:predicate];
  CustomValue *customvalue;
  if (set.count == 1) {
    customvalue = [set anyObject];
  }
  return customvalue.value;
}

- (NSString *)country {
  NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"fieldName == %@", @"geo_areas_json"];
  NSSet *set2 = [self.customValues filteredSetUsingPredicate:predicate2];
  NSString *country = nil;
  CustomValue *cv;
  if (set2.count == 1) {
    cv = [set2 anyObject];
    NSError *error;
    NSData *data = [cv.value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    country = [json objectForKey:@"Country"];
  }
  return country;
}

- (NSURL *)imageRemoteUrl {
  Image *wpImage = [self.images anyObject];
  if (wpImage.remoteURL) {
    NSString *imageUrlString = [kFirstServerUrl stringByAppendingString:[kImageURLPath stringByAppendingString:self.id]];
    NSString *imageUrlExtended = [imageUrlString stringByAppendingString:@"/"];
    NSString *imageUrlFullString = [imageUrlExtended stringByAppendingString:wpImage.remoteURL];
    NSString *escapedUrl = [imageUrlFullString stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    NSURL *imageUrl = [NSURL URLWithString:escapedUrl];
    return imageUrl;
  } else {
    return nil;
  }
}

- (NSComparisonResult)sortByDistance:(WastePoint *)otherPoint {
  return self.distanceValue > otherPoint.distanceValue;
}

- (NSString *)distanceString {
  return [NSString stringWithFormat:@"%1.0f m", self.distanceValue];
}

@end
