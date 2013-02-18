// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WPField.m instead.

#import "_WPField.h"

const struct WPFieldAttributes WPFieldAttributes = {
	.edit_instructions = @"edit_instructions",
	.field_name = @"field_name",
	.label = @"label",
	.max = @"max",
	.min = @"min",
	.suffix = @"suffix",
	.type = @"type",
};

const struct WPFieldRelationships WPFieldRelationships = {
	.typicalValues = @"typicalValues",
	.wastePoint = @"wastePoint",
};

const struct WPFieldFetchedProperties WPFieldFetchedProperties = {
};

@implementation WPFieldID
@end

@implementation _WPField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WPField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WPField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WPField" inManagedObjectContext:moc_];
}

- (WPFieldID*)objectID {
	return (WPFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"maxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic edit_instructions;






@dynamic field_name;






@dynamic label;






@dynamic max;



- (int16_t)maxValue {
	NSNumber *result = [self max];
	return [result shortValue];
}

- (void)setMaxValue:(int16_t)value_ {
	[self setMax:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMaxValue {
	NSNumber *result = [self primitiveMax];
	return [result shortValue];
}

- (void)setPrimitiveMaxValue:(int16_t)value_ {
	[self setPrimitiveMax:[NSNumber numberWithShort:value_]];
}





@dynamic min;



- (int16_t)minValue {
	NSNumber *result = [self min];
	return [result shortValue];
}

- (void)setMinValue:(int16_t)value_ {
	[self setMin:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMinValue {
	NSNumber *result = [self primitiveMin];
	return [result shortValue];
}

- (void)setPrimitiveMinValue:(int16_t)value_ {
	[self setPrimitiveMin:[NSNumber numberWithShort:value_]];
}





@dynamic suffix;






@dynamic type;






@dynamic typicalValues;

	
- (NSMutableSet*)typicalValuesSet {
	[self willAccessValueForKey:@"typicalValues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"typicalValues"];
  
	[self didAccessValueForKey:@"typicalValues"];
	return result;
}
	

@dynamic wastePoint;

	






@end
