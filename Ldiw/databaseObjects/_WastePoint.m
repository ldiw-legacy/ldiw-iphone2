// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WastePoint.m instead.

#import "_WastePoint.h"

@implementation WastePointID
@end

@implementation _WastePoint

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WastePoint" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WastePoint";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WastePoint" inManagedObjectContext:moc_];
}

- (WastePointID*)objectID {
	return (WastePointID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"comp_biodegradableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comp_biodegradable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"comp_constructionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comp_construction"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"comp_dagerousValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comp_dagerous"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"comp_largeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comp_large"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"comp_otherValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"comp_other"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic comp_biodegradable;



- (short)comp_biodegradableValue {
	NSNumber *result = [self comp_biodegradable];
	return [result shortValue];
}

- (void)setComp_biodegradableValue:(short)value_ {
	[self setComp_biodegradable:[NSNumber numberWithShort:value_]];
}

- (short)primitiveComp_biodegradableValue {
	NSNumber *result = [self primitiveComp_biodegradable];
	return [result shortValue];
}

- (void)setPrimitiveComp_biodegradableValue:(short)value_ {
	[self setPrimitiveComp_biodegradable:[NSNumber numberWithShort:value_]];
}





@dynamic comp_construction;



- (short)comp_constructionValue {
	NSNumber *result = [self comp_construction];
	return [result shortValue];
}

- (void)setComp_constructionValue:(short)value_ {
	[self setComp_construction:[NSNumber numberWithShort:value_]];
}

- (short)primitiveComp_constructionValue {
	NSNumber *result = [self primitiveComp_construction];
	return [result shortValue];
}

- (void)setPrimitiveComp_constructionValue:(short)value_ {
	[self setPrimitiveComp_construction:[NSNumber numberWithShort:value_]];
}





@dynamic comp_dagerous;



- (short)comp_dagerousValue {
	NSNumber *result = [self comp_dagerous];
	return [result shortValue];
}

- (void)setComp_dagerousValue:(short)value_ {
	[self setComp_dagerous:[NSNumber numberWithShort:value_]];
}

- (short)primitiveComp_dagerousValue {
	NSNumber *result = [self primitiveComp_dagerous];
	return [result shortValue];
}

- (void)setPrimitiveComp_dagerousValue:(short)value_ {
	[self setPrimitiveComp_dagerous:[NSNumber numberWithShort:value_]];
}





@dynamic comp_large;



- (short)comp_largeValue {
	NSNumber *result = [self comp_large];
	return [result shortValue];
}

- (void)setComp_largeValue:(short)value_ {
	[self setComp_large:[NSNumber numberWithShort:value_]];
}

- (short)primitiveComp_largeValue {
	NSNumber *result = [self primitiveComp_large];
	return [result shortValue];
}

- (void)setPrimitiveComp_largeValue:(short)value_ {
	[self setPrimitiveComp_large:[NSNumber numberWithShort:value_]];
}





@dynamic comp_other;



- (short)comp_otherValue {
	NSNumber *result = [self comp_other];
	return [result shortValue];
}

- (void)setComp_otherValue:(short)value_ {
	[self setComp_other:[NSNumber numberWithShort:value_]];
}

- (short)primitiveComp_otherValue {
	NSNumber *result = [self primitiveComp_other];
	return [result shortValue];
}

- (void)setPrimitiveComp_otherValue:(short)value_ {
	[self setPrimitiveComp_other:[NSNumber numberWithShort:value_]];
}





@dynamic id;



- (int)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}





@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}





@dynamic wp_description;






@dynamic wpfields;

	
- (NSMutableSet*)wpfieldsSet {
	[self willAccessValueForKey:@"wpfields"];
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"wpfields"];
	[self didAccessValueForKey:@"wpfields"];
	return result;
}
	





@end
