// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHUser.h instead.

#import <CoreData/CoreData.h>
#import "CDOHAbstractUser.h"

extern const struct CDOHUserAttributes {
	__unsafe_unretained NSString *biography;
	__unsafe_unretained NSString *hireable;
} CDOHUserAttributes;

extern const struct CDOHUserRelationships {
	__unsafe_unretained NSString *teams;
	__unsafe_unretained NSString *watchedRepositories;
} CDOHUserRelationships;

extern const struct CDOHUserFetchedProperties {
} CDOHUserFetchedProperties;

@class CDOHOrganizationTeam;
@class CDOHRepository;




@interface CDOHUserID : NSManagedObjectID {}
@end

@interface _CDOHUser : CDOHAbstractUser {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHUserID*)objectID;




@property (nonatomic, strong) NSString * biography;


//- (BOOL)validateBiography:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber * hireable;


@property BOOL hireableValue;
- (BOOL)hireableValue;
- (void)setHireableValue:(BOOL)value_;

//- (BOOL)validateHireable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* teams;

- (NSMutableSet*)teamsSet;




@property (nonatomic, strong) NSSet* watchedRepositories;

- (NSMutableSet*)watchedRepositoriesSet;





@end

@interface _CDOHUser (CoreDataGeneratedAccessors)

- (void)addTeams:(NSSet*)value_;
- (void)removeTeams:(NSSet*)value_;
- (void)addTeamsObject:(CDOHOrganizationTeam*)value_;
- (void)removeTeamsObject:(CDOHOrganizationTeam*)value_;

- (void)addWatchedRepositories:(NSSet*)value_;
- (void)removeWatchedRepositories:(NSSet*)value_;
- (void)addWatchedRepositoriesObject:(CDOHRepository*)value_;
- (void)removeWatchedRepositoriesObject:(CDOHRepository*)value_;

@end

@interface _CDOHUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString *)primitiveBiography;
- (void)setPrimitiveBiography:(NSString *)value;




- (NSNumber *)primitiveHireable;
- (void)setPrimitiveHireable:(NSNumber *)value;

- (BOOL)primitiveHireableValue;
- (void)setPrimitiveHireableValue:(BOOL)value_;





- (NSMutableSet*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet*)value;



- (NSMutableSet*)primitiveWatchedRepositories;
- (void)setPrimitiveWatchedRepositories:(NSMutableSet*)value;


@end
