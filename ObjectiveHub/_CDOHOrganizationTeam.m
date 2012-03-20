// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHOrganizationTeam.m instead.

#import "_CDOHOrganizationTeam.h"

const struct CDOHOrganizationTeamAttributes CDOHOrganizationTeamAttributes = {
	.identifier = @"identifier",
	.membersCount = @"membersCount",
	.name = @"name",
	.permission = @"permission",
	.repositoriesCount = @"repositoriesCount",
};

const struct CDOHOrganizationTeamRelationships CDOHOrganizationTeamRelationships = {
	.members = @"members",
	.organization = @"organization",
};

const struct CDOHOrganizationTeamFetchedProperties CDOHOrganizationTeamFetchedProperties = {
};

@implementation CDOHOrganizationTeamID
@end

@implementation _CDOHOrganizationTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHOrganizationTeam" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHOrganizationTeam";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHOrganizationTeam" inManagedObjectContext:moc_];
}

- (CDOHOrganizationTeamID*)objectID {
	return (CDOHOrganizationTeamID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"membersCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"membersCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"repositoriesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"repositoriesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic identifier;



- (int64_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result longLongValue];
}

- (void)setIdentifierValue:(int64_t)value_ {
	[self setIdentifier:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result longLongValue];
}

- (void)setPrimitiveIdentifierValue:(int64_t)value_ {
	[self setPrimitiveIdentifier:[NSNumber numberWithLongLong:value_]];
}





@dynamic membersCount;



- (int32_t)membersCountValue {
	NSNumber *result = [self membersCount];
	return [result intValue];
}

- (void)setMembersCountValue:(int32_t)value_ {
	[self setMembersCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMembersCountValue {
	NSNumber *result = [self primitiveMembersCount];
	return [result intValue];
}

- (void)setPrimitiveMembersCountValue:(int32_t)value_ {
	[self setPrimitiveMembersCount:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic permission;






@dynamic repositoriesCount;



- (int32_t)repositoriesCountValue {
	NSNumber *result = [self repositoriesCount];
	return [result intValue];
}

- (void)setRepositoriesCountValue:(int32_t)value_ {
	[self setRepositoriesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRepositoriesCountValue {
	NSNumber *result = [self primitiveRepositoriesCount];
	return [result intValue];
}

- (void)setPrimitiveRepositoriesCountValue:(int32_t)value_ {
	[self setPrimitiveRepositoriesCount:[NSNumber numberWithInt:value_]];
}





@dynamic members;

	
- (NSMutableSet*)membersSet {
	[self willAccessValueForKey:@"members"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];
  
	[self didAccessValueForKey:@"members"];
	return result;
}
	

@dynamic organization;

	






@end
