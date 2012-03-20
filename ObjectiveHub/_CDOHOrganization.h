// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHOrganization.h instead.

#import <CoreData/CoreData.h>
#import "CDOHAbstractUser.h"

extern const struct CDOHOrganizationAttributes {
} CDOHOrganizationAttributes;

extern const struct CDOHOrganizationRelationships {
	__unsafe_unretained NSString *teams;
} CDOHOrganizationRelationships;

extern const struct CDOHOrganizationFetchedProperties {
} CDOHOrganizationFetchedProperties;

@class CDOHOrganizationTeam;


@interface CDOHOrganizationID : NSManagedObjectID {}
@end

@interface _CDOHOrganization : CDOHAbstractUser {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CDOHOrganizationID*)objectID;





@property (nonatomic, strong) NSSet* teams;

- (NSMutableSet*)teamsSet;





@end

@interface _CDOHOrganization (CoreDataGeneratedAccessors)

- (void)addTeams:(NSSet*)value_;
- (void)removeTeams:(NSSet*)value_;
- (void)addTeamsObject:(CDOHOrganizationTeam*)value_;
- (void)removeTeamsObject:(CDOHOrganizationTeam*)value_;

@end

@interface _CDOHOrganization (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet*)value;


@end
