// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WastePoint.h instead.

#import <CoreData/CoreData.h>


@class WastePoint;











@interface WastePointID : NSManagedObjectID {}
@end

@interface _WastePoint : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WastePointID*)objectID;




@property (nonatomic, strong) NSNumber *comp_biodegradable;


@property short comp_biodegradableValue;
- (short)comp_biodegradableValue;
- (void)setComp_biodegradableValue:(short)value_;

//- (BOOL)validateComp_biodegradable:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *comp_construction;


@property short comp_constructionValue;
- (short)comp_constructionValue;
- (void)setComp_constructionValue:(short)value_;

//- (BOOL)validateComp_construction:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *comp_dagerous;


@property short comp_dagerousValue;
- (short)comp_dagerousValue;
- (void)setComp_dagerousValue:(short)value_;

//- (BOOL)validateComp_dagerous:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *comp_large;


@property short comp_largeValue;
- (short)comp_largeValue;
- (void)setComp_largeValue:(short)value_;

//- (BOOL)validateComp_large:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *comp_other;


@property short comp_otherValue;
- (short)comp_otherValue;
- (void)setComp_otherValue:(short)value_;

//- (BOOL)validateComp_other:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *id;


@property int idValue;
- (int)idValue;
- (void)setIdValue:(int)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *latitude;


@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *longitude;


@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *wp_description;


//- (BOOL)validateWp_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* wpfields;

- (NSMutableSet*)wpfieldsSet;




@end

@interface _WastePoint (CoreDataGeneratedAccessors)

- (void)addWpfields:(NSSet*)value_;
- (void)removeWpfields:(NSSet*)value_;
- (void)addWpfieldsObject:(WastePoint*)value_;
- (void)removeWpfieldsObject:(WastePoint*)value_;

@end

@interface _WastePoint (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveComp_biodegradable;
- (void)setPrimitiveComp_biodegradable:(NSNumber*)value;

- (short)primitiveComp_biodegradableValue;
- (void)setPrimitiveComp_biodegradableValue:(short)value_;




- (NSNumber*)primitiveComp_construction;
- (void)setPrimitiveComp_construction:(NSNumber*)value;

- (short)primitiveComp_constructionValue;
- (void)setPrimitiveComp_constructionValue:(short)value_;




- (NSNumber*)primitiveComp_dagerous;
- (void)setPrimitiveComp_dagerous:(NSNumber*)value;

- (short)primitiveComp_dagerousValue;
- (void)setPrimitiveComp_dagerousValue:(short)value_;




- (NSNumber*)primitiveComp_large;
- (void)setPrimitiveComp_large:(NSNumber*)value;

- (short)primitiveComp_largeValue;
- (void)setPrimitiveComp_largeValue:(short)value_;




- (NSNumber*)primitiveComp_other;
- (void)setPrimitiveComp_other:(NSNumber*)value;

- (short)primitiveComp_otherValue;
- (void)setPrimitiveComp_otherValue:(short)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int)primitiveIdValue;
- (void)setPrimitiveIdValue:(int)value_;




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
