// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WPField.h instead.

#import <CoreData/CoreData.h>


@class TypicalValues;









@interface WPFieldID : NSManagedObjectID {}
@end

@interface _WPField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WPFieldID*)objectID;




@property (nonatomic, strong) NSString *edit_instructions;


//- (BOOL)validateEdit_instructions:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *field_name;


//- (BOOL)validateField_name:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *label;


//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *max;


@property short maxValue;
- (short)maxValue;
- (void)setMaxValue:(short)value_;

//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *min;


@property short minValue;
- (short)minValue;
- (void)setMinValue:(short)value_;

//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *suffix;


//- (BOOL)validateSuffix:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *type;


//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* typicalValues;

- (NSMutableSet*)typicalValuesSet;




@end

@interface _WPField (CoreDataGeneratedAccessors)

- (void)addTypicalValues:(NSSet*)value_;
- (void)removeTypicalValues:(NSSet*)value_;
- (void)addTypicalValuesObject:(TypicalValues*)value_;
- (void)removeTypicalValuesObject:(TypicalValues*)value_;

@end

@interface _WPField (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEdit_instructions;
- (void)setPrimitiveEdit_instructions:(NSString*)value;




- (NSString*)primitiveField_name;
- (void)setPrimitiveField_name:(NSString*)value;




- (NSString*)primitiveLabel;
- (void)setPrimitiveLabel:(NSString*)value;




- (NSNumber*)primitiveMax;
- (void)setPrimitiveMax:(NSNumber*)value;

- (short)primitiveMaxValue;
- (void)setPrimitiveMaxValue:(short)value_;




- (NSNumber*)primitiveMin;
- (void)setPrimitiveMin:(NSNumber*)value;

- (short)primitiveMinValue;
- (void)setPrimitiveMinValue:(short)value_;




- (NSString*)primitiveSuffix;
- (void)setPrimitiveSuffix:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (NSMutableSet*)primitiveTypicalValues;
- (void)setPrimitiveTypicalValues:(NSMutableSet*)value;


@end
