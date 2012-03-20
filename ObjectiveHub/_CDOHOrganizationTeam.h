// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHOrganizationTeam.h instead.

#import <CoreData/CoreData.h>
#import "CDOHResource.h"

extern const struct CDOHOrganizationTeamAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *membersCount;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *permission;
	__unsafe_unretained NSString *repositoriesCount;
} CDOHOrganizationTeamAttributes;

extern const struct CDOHOrganizationTeamRelationships {
	__unsafe_unretained NSString *members;
	__unsafe_unretained NSString *organization;
} CDOHOrganizationTeamRelationships;

extern const struct CDOHOrganizationTeamFetchedProperties {
} CDOHOrganizationTeamFetchedProperties;

@class CDOHUser;
@class CDOHOrganization;







@interface CDOHOrganizationTeamID : NSManagedObjectID {}
@end

@interface _CDOHOrganizationTeam : CDOHResource {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHOrganizationTeamID*)objectID;




@property (nonatomic, strong) NSNumber * identifier;


@property int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * membersCount;


@property int32_t membersCountValue;
- (int32_t)membersCountValue;
- (void)setMembersCountValue:(int32_t)value_;

//- (BOOL)validateMembersCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * permission;


//- (BOOL)validatePermission:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * repositoriesCount;


@property int32_t repositoriesCountValue;
- (int32_t)repositoriesCountValue;
- (void)setRepositoriesCountValue:(int32_t)value_;

//- (BOOL)validateRepositoriesCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* members;

- (NSMutableSet*)membersSet;




@property (nonatomic, strong) CDOHOrganization* organization;

//- (BOOL)validateOrganization:(id*)value_ error:(NSError**)error_;





@end

@interface _CDOHOrganizationTeam (CoreDataGeneratedAccessors)

- (void)addMembers:(NSSet*)value_;
- (void)removeMembers:(NSSet*)value_;
- (void)addMembersObject:(CDOHUser*)value_;
- (void)removeMembersObject:(CDOHUser*)value_;

@end

@interface _CDOHOrganizationTeam (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber *)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;




- (NSNumber *)primitiveMembersCount;
- (void)setPrimitiveMembersCount:(NSNumber *)value;

- (int32_t)primitiveMembersCountValue;
- (void)setPrimitiveMembersCountValue:(int32_t)value_;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (NSString *)primitivePermission;
- (void)setPrimitivePermission:(NSString *)value;




- (NSNumber *)primitiveRepositoriesCount;
- (void)setPrimitiveRepositoriesCount:(NSNumber *)value;

- (int32_t)primitiveRepositoriesCountValue;
- (void)setPrimitiveRepositoriesCountValue:(int32_t)value_;





- (NSMutableSet*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet*)value;



- (CDOHOrganization*)primitiveOrganization;
- (void)setPrimitiveOrganization:(CDOHOrganization*)value;


@end
