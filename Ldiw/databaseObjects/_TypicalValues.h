// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TypicalValues.h instead.

#import <CoreData/CoreData.h>


extern const struct TypicalValuesAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} TypicalValuesAttributes;

extern const struct TypicalValuesRelationships {
	__unsafe_unretained NSString *wpField;
} TypicalValuesRelationships;

extern const struct TypicalValuesFetchedProperties {
} TypicalValuesFetchedProperties;

@class WPField;




@interface TypicalValuesID : NSManagedObjectID {}
@end

@interface _TypicalValues : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TypicalValuesID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WPField *wpField;

//- (BOOL)validateWpField:(id*)value_ error:(NSError**)error_;





@end

@interface _TypicalValues (CoreDataGeneratedAccessors)

@end

@interface _TypicalValues (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;





- (WPField*)primitiveWpField;
- (void)setPrimitiveWpField:(WPField*)value;


@end
