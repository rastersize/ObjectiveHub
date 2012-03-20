// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHPLan.h instead.

#import <CoreData/CoreData.h>
#import "CDOHResource.h"

extern const struct CDOHPLanAttributes {
	__unsafe_unretained NSString *collaborators;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *privateRepositories;
	__unsafe_unretained NSString *space;
} CDOHPLanAttributes;

extern const struct CDOHPLanRelationships {
	__unsafe_unretained NSString *users;
} CDOHPLanRelationships;

extern const struct CDOHPLanFetchedProperties {
} CDOHPLanFetchedProperties;

@class CDOHAbstractUser;






@interface CDOHPLanID : NSManagedObjectID {}
@end

@interface _CDOHPLan : CDOHResource {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHPLanID*)objectID;




@property (nonatomic, strong) NSNumber * collaborators;


@property int32_t collaboratorsValue;
- (int32_t)collaboratorsValue;
- (void)setCollaboratorsValue:(int32_t)value_;

//- (BOOL)validateCollaborators:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * privateRepositories;


@property int32_t privateRepositoriesValue;
- (int32_t)privateRepositoriesValue;
- (void)setPrivateRepositoriesValue:(int32_t)value_;

//- (BOOL)validatePrivateRepositories:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * space;


@property int64_t spaceValue;
- (int64_t)spaceValue;
- (void)setSpaceValue:(int64_t)value_;

//- (BOOL)validateSpace:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* users;

- (NSMutableSet*)usersSet;





@end

@interface _CDOHPLan (CoreDataGeneratedAccessors)

- (void)addUsers:(NSSet*)value_;
- (void)removeUsers:(NSSet*)value_;
- (void)addUsersObject:(CDOHAbstractUser*)value_;
- (void)removeUsersObject:(CDOHAbstractUser*)value_;

@end

@interface _CDOHPLan (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveCollaborators;
- (void)setPrimitiveCollaborators:(NSNumber *)value;

- (int32_t)primitiveCollaboratorsValue;
- (void)setPrimitiveCollaboratorsValue:(int32_t)value_;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (NSNumber *)primitivePrivateRepositories;
- (void)setPrimitivePrivateRepositories:(NSNumber *)value;

- (int32_t)primitivePrivateRepositoriesValue;
- (void)setPrimitivePrivateRepositoriesValue:(int32_t)value_;




- (NSNumber *)primitiveSpace;
- (void)setPrimitiveSpace:(NSNumber *)value;

- (int64_t)primitiveSpaceValue;
- (void)setPrimitiveSpaceValue:(int64_t)value_;





- (NSMutableSet*)primitiveUsers;
- (void)setPrimitiveUsers:(NSMutableSet*)value;


@end
