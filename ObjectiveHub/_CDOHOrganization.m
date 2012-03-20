// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHOrganization.m instead.

#import "_CDOHOrganization.h"

const struct CDOHOrganizationAttributes CDOHOrganizationAttributes = {
};

const struct CDOHOrganizationRelationships CDOHOrganizationRelationships = {
	.teams = @"teams",
};

const struct CDOHOrganizationFetchedProperties CDOHOrganizationFetchedProperties = {
};

@implementation CDOHOrganizationID
@end

@implementation _CDOHOrganization

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHOrganization" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHOrganization";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHOrganization" inManagedObjectContext:moc_];
}

- (CDOHOrganizationID*)objectID {
	return (CDOHOrganizationID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic teams;

	
- (NSMutableSet*)teamsSet {
	[self willAccessValueForKey:@"teams"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teams"];
  
	[self didAccessValueForKey:@"teams"];
	return result;
}
	






@end
