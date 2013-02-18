// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WPField.m instead.

#import "_WPField.h"

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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"maxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"minValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic edit_instructions;






@dynamic field_name;






@dynamic label;






@dynamic max;



- (short)maxValue {
	NSNumber *result = [self max];
	return [result shortValue];
}

- (void)setMaxValue:(short)value_ {
	[self setMax:[NSNumber numberWithShort:value_]];
}

- (short)primitiveMaxValue {
	NSNumber *result = [self primitiveMax];
	return [result shortValue];
}

- (void)setPrimitiveMaxValue:(short)value_ {
	[self setPrimitiveMax:[NSNumber numberWithShort:value_]];
}





@dynamic min;



- (short)minValue {
	NSNumber *result = [self min];
	return [result shortValue];
}

- (void)setMinValue:(short)value_ {
	[self setMin:[NSNumber numberWithShort:value_]];
}

- (short)primitiveMinValue {
	NSNumber *result = [self primitiveMin];
	return [result shortValue];
}

- (void)setPrimitiveMinValue:(short)value_ {
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
	





@end
