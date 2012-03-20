// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHAbstractUser.h instead.

#import <CoreData/CoreData.h>
#import "CDOHResource.h"

extern const struct CDOHAbstractUserAttributes {
	__unsafe_unretained NSString *collaborators;
	__unsafe_unretained NSString *company;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *diskUsage;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *followersCount;
	__unsafe_unretained NSString *followingCount;
	__unsafe_unretained NSString *gravatarID;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *login;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *p_avatarURL;
	__unsafe_unretained NSString *p_blogURL;
	__unsafe_unretained NSString *p_userHTMLProfileURL;
	__unsafe_unretained NSString *privateGistsCount;
	__unsafe_unretained NSString *privateRepositoriesCount;
	__unsafe_unretained NSString *privateRepositoriesOwnedCount;
	__unsafe_unretained NSString *publicGistsCount;
	__unsafe_unretained NSString *publicRepositoriesCount;
	__unsafe_unretained NSString *type;
} CDOHAbstractUserAttributes;

extern const struct CDOHAbstractUserRelationships {
	__unsafe_unretained NSString *plan;
	__unsafe_unretained NSString *repositories;
} CDOHAbstractUserRelationships;

extern const struct CDOHAbstractUserFetchedProperties {
} CDOHAbstractUserFetchedProperties;

@class CDOHPLan;
@class CDOHRepository;













@class NSObject;
@class NSObject;
@class NSObject;







@interface CDOHAbstractUserID : NSManagedObjectID {}
@end

@interface _CDOHAbstractUser : CDOHResource {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHAbstractUserID*)objectID;




@property (nonatomic, strong) NSNumber * collaborators;


@property int64_t collaboratorsValue;
- (int64_t)collaboratorsValue;
- (void)setCollaboratorsValue:(int64_t)value_;

//- (BOOL)validateCollaborators:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * company;


//- (BOOL)validateCompany:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate * createdAt;


//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * diskUsage;


@property int64_t diskUsageValue;
- (int64_t)diskUsageValue;
- (void)setDiskUsageValue:(int64_t)value_;

//- (BOOL)validateDiskUsage:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * email;


//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * followersCount;


@property int32_t followersCountValue;
- (int32_t)followersCountValue;
- (void)setFollowersCountValue:(int32_t)value_;

//- (BOOL)validateFollowersCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * followingCount;


@property int32_t followingCountValue;
- (int32_t)followingCountValue;
- (void)setFollowingCountValue:(int32_t)value_;

//- (BOOL)validateFollowingCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * gravatarID;


//- (BOOL)validateGravatarID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * identifier;


@property int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * location;


//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * login;


//- (BOOL)validateLogin:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_avatarURL;


//- (BOOL)validateP_avatarURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_blogURL;


//- (BOOL)validateP_blogURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) id p_userHTMLProfileURL;


//- (BOOL)validateP_userHTMLProfileURL:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * privateGistsCount;


@property int32_t privateGistsCountValue;
- (int32_t)privateGistsCountValue;
- (void)setPrivateGistsCountValue:(int32_t)value_;

//- (BOOL)validatePrivateGistsCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * privateRepositoriesCount;


@property int32_t privateRepositoriesCountValue;
- (int32_t)privateRepositoriesCountValue;
- (void)setPrivateRepositoriesCountValue:(int32_t)value_;

//- (BOOL)validatePrivateRepositoriesCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * privateRepositoriesOwnedCount;


@property int32_t privateRepositoriesOwnedCountValue;
- (int32_t)privateRepositoriesOwnedCountValue;
- (void)setPrivateRepositoriesOwnedCountValue:(int32_t)value_;

//- (BOOL)validatePrivateRepositoriesOwnedCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * publicGistsCount;


@property int32_t publicGistsCountValue;
- (int32_t)publicGistsCountValue;
- (void)setPublicGistsCountValue:(int32_t)value_;

//- (BOOL)validatePublicGistsCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * publicRepositoriesCount;


@property int32_t publicRepositoriesCountValue;
- (int32_t)publicRepositoriesCountValue;
- (void)setPublicRepositoriesCountValue:(int32_t)value_;

//- (BOOL)validatePublicRepositoriesCount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString * type;


//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) CDOHPLan* plan;

//- (BOOL)validatePlan:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* repositories;

- (NSMutableSet*)repositoriesSet;





@end

@interface _CDOHAbstractUser (CoreDataGeneratedAccessors)

- (void)addRepositories:(NSSet*)value_;
- (void)removeRepositories:(NSSet*)value_;
- (void)addRepositoriesObject:(CDOHRepository*)value_;
- (void)removeRepositoriesObject:(CDOHRepository*)value_;

@end

@interface _CDOHAbstractUser (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber *)primitiveCollaborators;
- (void)setPrimitiveCollaborators:(NSNumber *)value;

- (int64_t)primitiveCollaboratorsValue;
- (void)setPrimitiveCollaboratorsValue:(int64_t)value_;




- (NSString *)primitiveCompany;
- (void)setPrimitiveCompany:(NSString *)value;




- (NSDate *)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate *)value;




- (NSNumber *)primitiveDiskUsage;
- (void)setPrimitiveDiskUsage:(NSNumber *)value;

- (int64_t)primitiveDiskUsageValue;
- (void)setPrimitiveDiskUsageValue:(int64_t)value_;




- (NSString *)primitiveEmail;
- (void)setPrimitiveEmail:(NSString *)value;




- (NSNumber *)primitiveFollowersCount;
- (void)setPrimitiveFollowersCount:(NSNumber *)value;

- (int32_t)primitiveFollowersCountValue;
- (void)setPrimitiveFollowersCountValue:(int32_t)value_;




- (NSNumber *)primitiveFollowingCount;
- (void)setPrimitiveFollowingCount:(NSNumber *)value;

- (int32_t)primitiveFollowingCountValue;
- (void)setPrimitiveFollowingCountValue:(int32_t)value_;




- (NSString *)primitiveGravatarID;
- (void)setPrimitiveGravatarID:(NSString *)value;




- (NSNumber *)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber *)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;




- (NSString *)primitiveLocation;
- (void)setPrimitiveLocation:(NSString *)value;




- (NSString *)primitiveLogin;
- (void)setPrimitiveLogin:(NSString *)value;




- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;




- (id)primitiveP_avatarURL;
- (void)setPrimitiveP_avatarURL:(id)value;




- (id)primitiveP_blogURL;
- (void)setPrimitiveP_blogURL:(id)value;




- (id)primitiveP_userHTMLProfileURL;
- (void)setPrimitiveP_userHTMLProfileURL:(id)value;




- (NSNumber *)primitivePrivateGistsCount;
- (void)setPrimitivePrivateGistsCount:(NSNumber *)value;

- (int32_t)primitivePrivateGistsCountValue;
- (void)setPrimitivePrivateGistsCountValue:(int32_t)value_;




- (NSNumber *)primitivePrivateRepositoriesCount;
- (void)setPrimitivePrivateRepositoriesCount:(NSNumber *)value;

- (int32_t)primitivePrivateRepositoriesCountValue;
- (void)setPrimitivePrivateRepositoriesCountValue:(int32_t)value_;




- (NSNumber *)primitivePrivateRepositoriesOwnedCount;
- (void)setPrimitivePrivateRepositoriesOwnedCount:(NSNumber *)value;

- (int32_t)primitivePrivateRepositoriesOwnedCountValue;
- (void)setPrimitivePrivateRepositoriesOwnedCountValue:(int32_t)value_;




- (NSNumber *)primitivePublicGistsCount;
- (void)setPrimitivePublicGistsCount:(NSNumber *)value;

- (int32_t)primitivePublicGistsCountValue;
- (void)setPrimitivePublicGistsCountValue:(int32_t)value_;




- (NSNumber *)primitivePublicRepositoriesCount;
- (void)setPrimitivePublicRepositoriesCount:(NSNumber *)value;

- (int32_t)primitivePublicRepositoriesCountValue;
- (void)setPrimitivePublicRepositoriesCountValue:(int32_t)value_;




- (NSString *)primitiveType;
- (void)setPrimitiveType:(NSString *)value;





- (CDOHPLan*)primitivePlan;
- (void)setPrimitivePlan:(CDOHPLan*)value;



- (NSMutableSet*)primitiveRepositories;
- (void)setPrimitiveRepositories:(NSMutableSet*)value;


@end
