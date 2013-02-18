// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TypicalValues.m instead.

#import "_TypicalValues.h"

@implementation TypicalValuesID
@end

@implementation _TypicalValues

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TypicalValues" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TypicalValues";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TypicalValues" inManagedObjectContext:moc_];
}

- (TypicalValuesID*)objectID {
	return (TypicalValuesID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic key;






@dynamic value;






@dynamic wpField;

	
- (NSMutableSet*)wpFieldSet {
	[self willAccessValueForKey:@"wpField"];
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"wpField"];
	[self didAccessValueForKey:@"wpField"];
	return result;
}
	





@end
