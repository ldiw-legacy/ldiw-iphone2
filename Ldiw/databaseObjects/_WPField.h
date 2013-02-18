// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WPField.h instead.

#import <CoreData/CoreData.h>


extern const struct WPFieldAttributes {
	__unsafe_unretained NSString *edit_instructions;
	__unsafe_unretained NSString *field_name;
	__unsafe_unretained NSString *label;
	__unsafe_unretained NSString *max;
	__unsafe_unretained NSString *min;
	__unsafe_unretained NSString *suffix;
	__unsafe_unretained NSString *type;
} WPFieldAttributes;

extern const struct WPFieldRelationships {
	__unsafe_unretained NSString *typicalValues;
	__unsafe_unretained NSString *wastePoint;
} WPFieldRelationships;

extern const struct WPFieldFetchedProperties {
} WPFieldFetchedProperties;

@class TypicalValues;
@class WastePoint;









@interface WPFieldID : NSManagedObjectID {}
@end

@interface _WPField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WPFieldID*)objectID;





@property (nonatomic, strong) NSString* edit_instructions;



//- (BOOL)validateEdit_instructions:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* field_name;



//- (BOOL)validateField_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* label;



//- (BOOL)validateLabel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* max;



@property int16_t maxValue;
- (int16_t)maxValue;
- (void)setMaxValue:(int16_t)value_;

//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* min;



@property int16_t minValue;
- (int16_t)minValue;
- (void)setMinValue:(int16_t)value_;

//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* suffix;



//- (BOOL)validateSuffix:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *typicalValues;

- (NSMutableSet*)typicalValuesSet;




@property (nonatomic, strong) WastePoint *wastePoint;

//- (BOOL)validateWastePoint:(id*)value_ error:(NSError**)error_;





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

- (int16_t)primitiveMaxValue;
- (void)setPrimitiveMaxValue:(int16_t)value_;




- (NSNumber*)primitiveMin;
- (void)setPrimitiveMin:(NSNumber*)value;

- (int16_t)primitiveMinValue;
- (void)setPrimitiveMinValue:(int16_t)value_;




- (NSString*)primitiveSuffix;
- (void)setPrimitiveSuffix:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (NSMutableSet*)primitiveTypicalValues;
- (void)setPrimitiveTypicalValues:(NSMutableSet*)value;



- (WastePoint*)primitiveWastePoint;
- (void)setPrimitiveWastePoint:(WastePoint*)value;


@end
