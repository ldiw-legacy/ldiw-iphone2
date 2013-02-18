// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TypicalValues.h instead.

#import <CoreData/CoreData.h>


@class WPField;




@interface TypicalValuesID : NSManagedObjectID {}
@end

@interface _TypicalValues : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TypicalValuesID*)objectID;




@property (nonatomic, strong) NSString *key;


//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *value;


//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* wpField;

- (NSMutableSet*)wpFieldSet;




@end

@interface _TypicalValues (CoreDataGeneratedAccessors)

- (void)addWpField:(NSSet*)value_;
- (void)removeWpField:(NSSet*)value_;
- (void)addWpFieldObject:(WPField*)value_;
- (void)removeWpFieldObject:(WPField*)value_;

@end

@interface _TypicalValues (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;





- (NSMutableSet*)primitiveWpField;
- (void)setPrimitiveWpField:(NSMutableSet*)value;


@end
