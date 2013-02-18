// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WastePoint.h instead.

#import <CoreData/CoreData.h>


extern const struct WastePointAttributes {
	__unsafe_unretained NSString *comp_biodegradable;
	__unsafe_unretained NSString *comp_construction;
	__unsafe_unretained NSString *comp_dagerous;
	__unsafe_unretained NSString *comp_large;
	__unsafe_unretained NSString *comp_other;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *wp_description;
} WastePointAttributes;

extern const struct WastePointRelationships {
	__unsafe_unretained NSString *wpfields;
} WastePointRelationships;

extern const struct WastePointFetchedProperties {
} WastePointFetchedProperties;

@class WPField;











@interface WastePointID : NSManagedObjectID {}
@end

@interface _WastePoint : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WastePointID*)objectID;





@property (nonatomic, strong) NSNumber* comp_biodegradable;



@property int16_t comp_biodegradableValue;
- (int16_t)comp_biodegradableValue;
- (void)setComp_biodegradableValue:(int16_t)value_;

//- (BOOL)validateComp_biodegradable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* comp_construction;



@property int16_t comp_constructionValue;
- (int16_t)comp_constructionValue;
- (void)setComp_constructionValue:(int16_t)value_;

//- (BOOL)validateComp_construction:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* comp_dagerous;



@property int16_t comp_dagerousValue;
- (int16_t)comp_dagerousValue;
- (void)setComp_dagerousValue:(int16_t)value_;

//- (BOOL)validateComp_dagerous:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* comp_large;



@property int16_t comp_largeValue;
- (int16_t)comp_largeValue;
- (void)setComp_largeValue:(int16_t)value_;

//- (BOOL)validateComp_large:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* comp_other;



@property int16_t comp_otherValue;
- (int16_t)comp_otherValue;
- (void)setComp_otherValue:(int16_t)value_;

//- (BOOL)validateComp_other:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wp_description;



//- (BOOL)validateWp_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *wpfields;

- (NSMutableSet*)wpfieldsSet;





@end

@interface _WastePoint (CoreDataGeneratedAccessors)

- (void)addWpfields:(NSSet*)value_;
- (void)removeWpfields:(NSSet*)value_;
- (void)addWpfieldsObject:(WPField*)value_;
- (void)removeWpfieldsObject:(WPField*)value_;

@end

@interface _WastePoint (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveComp_biodegradable;
- (void)setPrimitiveComp_biodegradable:(NSNumber*)value;

- (int16_t)primitiveComp_biodegradableValue;
- (void)setPrimitiveComp_biodegradableValue:(int16_t)value_;




- (NSNumber*)primitiveComp_construction;
- (void)setPrimitiveComp_construction:(NSNumber*)value;

- (int16_t)primitiveComp_constructionValue;
- (void)setPrimitiveComp_constructionValue:(int16_t)value_;




- (NSNumber*)primitiveComp_dagerous;
- (void)setPrimitiveComp_dagerous:(NSNumber*)value;

- (int16_t)primitiveComp_dagerousValue;
- (void)setPrimitiveComp_dagerousValue:(int16_t)value_;




- (NSNumber*)primitiveComp_large;
- (void)setPrimitiveComp_large:(NSNumber*)value;

- (int16_t)primitiveComp_largeValue;
- (void)setPrimitiveComp_largeValue:(int16_t)value_;




- (NSNumber*)primitiveComp_other;
- (void)setPrimitiveComp_other:(NSNumber*)value;

- (int16_t)primitiveComp_otherValue;
- (void)setPrimitiveComp_otherValue:(int16_t)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveWp_description;
- (void)setPrimitiveWp_description:(NSString*)value;





- (NSMutableSet*)primitiveWpfields;
- (void)setPrimitiveWpfields:(NSMutableSet*)value;


@end
