// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHResource.h instead.

#import <CoreData/CoreData.h>


extern const struct CDOHResourceAttributes {
	__unsafe_unretained NSString *p_resourceURL;
} CDOHResourceAttributes;

extern const struct CDOHResourceRelationships {
} CDOHResourceRelationships;

extern const struct CDOHResourceFetchedProperties {
} CDOHResourceFetchedProperties;


@class NSObject;

@interface CDOHResourceID : NSManagedObjectID {}
@end

@interface _CDOHResource : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHResourceID*)objectID;




@property (nonatomic, strong) id p_resourceURL;


//- (BOOL)validateP_resourceURL:(id*)value_ error:(NSError**)error_;






@end

@interface _CDOHResource (CoreDataGeneratedAccessors)

@end

@interface _CDOHResource (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveP_resourceURL;
- (void)setPrimitiveP_resourceURL:(id)value;




@end
