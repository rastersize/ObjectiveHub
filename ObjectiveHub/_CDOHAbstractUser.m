// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHAbstractUser.m instead.

#import "_CDOHAbstractUser.h"

const struct CDOHAbstractUserAttributes CDOHAbstractUserAttributes = {
	.authenticated = @"authenticated",
	.collaborators = @"collaborators",
	.company = @"company",
	.createdAt = @"createdAt",
	.diskUsage = @"diskUsage",
	.email = @"email",
	.followersCount = @"followersCount",
	.followingCount = @"followingCount",
	.gravatarID = @"gravatarID",
	.identifier = @"identifier",
	.location = @"location",
	.login = @"login",
	.name = @"name",
	.p_avatarURL = @"p_avatarURL",
	.p_blogURL = @"p_blogURL",
	.p_userHTMLProfileURL = @"p_userHTMLProfileURL",
	.privateGistsCount = @"privateGistsCount",
	.privateRepositoriesCount = @"privateRepositoriesCount",
	.privateRepositoriesOwnedCount = @"privateRepositoriesOwnedCount",
	.publicGistsCount = @"publicGistsCount",
	.publicRepositoriesCount = @"publicRepositoriesCount",
	.type = @"type",
};

const struct CDOHAbstractUserRelationships CDOHAbstractUserRelationships = {
	.plan = @"plan",
	.repositories = @"repositories",
};

const struct CDOHAbstractUserFetchedProperties CDOHAbstractUserFetchedProperties = {
};

@implementation CDOHAbstractUserID
@end

@implementation _CDOHAbstractUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHAbstractUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHAbstractUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHAbstractUser" inManagedObjectContext:moc_];
}

- (CDOHAbstractUserID*)objectID {
	return (CDOHAbstractUserID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"authenticatedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"authenticated"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"collaboratorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"collaborators"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"diskUsageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"diskUsage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"followersCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followersCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"followingCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followingCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"privateGistsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"privateGistsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"privateRepositoriesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"privateRepositoriesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"privateRepositoriesOwnedCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"privateRepositoriesOwnedCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"publicGistsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"publicGistsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"publicRepositoriesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"publicRepositoriesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic authenticated;



- (BOOL)authenticatedValue {
	NSNumber *result = [self authenticated];
	return [result boolValue];
}

- (void)setAuthenticatedValue:(BOOL)value_ {
	[self setAuthenticated:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAuthenticatedValue {
	NSNumber *result = [self primitiveAuthenticated];
	return [result boolValue];
}

- (void)setPrimitiveAuthenticatedValue:(BOOL)value_ {
	[self setPrimitiveAuthenticated:[NSNumber numberWithBool:value_]];
}





@dynamic collaborators;



- (int64_t)collaboratorsValue {
	NSNumber *result = [self collaborators];
	return [result longLongValue];
}

- (void)setCollaboratorsValue:(int64_t)value_ {
	[self setCollaborators:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveCollaboratorsValue {
	NSNumber *result = [self primitiveCollaborators];
	return [result longLongValue];
}

- (void)setPrimitiveCollaboratorsValue:(int64_t)value_ {
	[self setPrimitiveCollaborators:[NSNumber numberWithLongLong:value_]];
}





@dynamic company;






@dynamic createdAt;






@dynamic diskUsage;



- (int64_t)diskUsageValue {
	NSNumber *result = [self diskUsage];
	return [result longLongValue];
}

- (void)setDiskUsageValue:(int64_t)value_ {
	[self setDiskUsage:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveDiskUsageValue {
	NSNumber *result = [self primitiveDiskUsage];
	return [result longLongValue];
}

- (void)setPrimitiveDiskUsageValue:(int64_t)value_ {
	[self setPrimitiveDiskUsage:[NSNumber numberWithLongLong:value_]];
}





@dynamic email;






@dynamic followersCount;



- (int32_t)followersCountValue {
	NSNumber *result = [self followersCount];
	return [result intValue];
}

- (void)setFollowersCountValue:(int32_t)value_ {
	[self setFollowersCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowersCountValue {
	NSNumber *result = [self primitiveFollowersCount];
	return [result intValue];
}

- (void)setPrimitiveFollowersCountValue:(int32_t)value_ {
	[self setPrimitiveFollowersCount:[NSNumber numberWithInt:value_]];
}





@dynamic followingCount;



- (int32_t)followingCountValue {
	NSNumber *result = [self followingCount];
	return [result intValue];
}

- (void)setFollowingCountValue:(int32_t)value_ {
	[self setFollowingCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowingCountValue {
	NSNumber *result = [self primitiveFollowingCount];
	return [result intValue];
}

- (void)setPrimitiveFollowingCountValue:(int32_t)value_ {
	[self setPrimitiveFollowingCount:[NSNumber numberWithInt:value_]];
}





@dynamic gravatarID;






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





@dynamic location;






@dynamic login;






@dynamic name;






@dynamic p_avatarURL;






@dynamic p_blogURL;






@dynamic p_userHTMLProfileURL;






@dynamic privateGistsCount;



- (int32_t)privateGistsCountValue {
	NSNumber *result = [self privateGistsCount];
	return [result intValue];
}

- (void)setPrivateGistsCountValue:(int32_t)value_ {
	[self setPrivateGistsCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePrivateGistsCountValue {
	NSNumber *result = [self primitivePrivateGistsCount];
	return [result intValue];
}

- (void)setPrimitivePrivateGistsCountValue:(int32_t)value_ {
	[self setPrimitivePrivateGistsCount:[NSNumber numberWithInt:value_]];
}





@dynamic privateRepositoriesCount;



- (int32_t)privateRepositoriesCountValue {
	NSNumber *result = [self privateRepositoriesCount];
	return [result intValue];
}

- (void)setPrivateRepositoriesCountValue:(int32_t)value_ {
	[self setPrivateRepositoriesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePrivateRepositoriesCountValue {
	NSNumber *result = [self primitivePrivateRepositoriesCount];
	return [result intValue];
}

- (void)setPrimitivePrivateRepositoriesCountValue:(int32_t)value_ {
	[self setPrimitivePrivateRepositoriesCount:[NSNumber numberWithInt:value_]];
}





@dynamic privateRepositoriesOwnedCount;



- (int32_t)privateRepositoriesOwnedCountValue {
	NSNumber *result = [self privateRepositoriesOwnedCount];
	return [result intValue];
}

- (void)setPrivateRepositoriesOwnedCountValue:(int32_t)value_ {
	[self setPrivateRepositoriesOwnedCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePrivateRepositoriesOwnedCountValue {
	NSNumber *result = [self primitivePrivateRepositoriesOwnedCount];
	return [result intValue];
}

- (void)setPrimitivePrivateRepositoriesOwnedCountValue:(int32_t)value_ {
	[self setPrimitivePrivateRepositoriesOwnedCount:[NSNumber numberWithInt:value_]];
}





@dynamic publicGistsCount;



- (int32_t)publicGistsCountValue {
	NSNumber *result = [self publicGistsCount];
	return [result intValue];
}

- (void)setPublicGistsCountValue:(int32_t)value_ {
	[self setPublicGistsCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePublicGistsCountValue {
	NSNumber *result = [self primitivePublicGistsCount];
	return [result intValue];
}

- (void)setPrimitivePublicGistsCountValue:(int32_t)value_ {
	[self setPrimitivePublicGistsCount:[NSNumber numberWithInt:value_]];
}





@dynamic publicRepositoriesCount;



- (int32_t)publicRepositoriesCountValue {
	NSNumber *result = [self publicRepositoriesCount];
	return [result intValue];
}

- (void)setPublicRepositoriesCountValue:(int32_t)value_ {
	[self setPublicRepositoriesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePublicRepositoriesCountValue {
	NSNumber *result = [self primitivePublicRepositoriesCount];
	return [result intValue];
}

- (void)setPrimitivePublicRepositoriesCountValue:(int32_t)value_ {
	[self setPrimitivePublicRepositoriesCount:[NSNumber numberWithInt:value_]];
}





@dynamic type;






@dynamic plan;

	

@dynamic repositories;

	
- (NSMutableSet*)repositoriesSet {
	[self willAccessValueForKey:@"repositories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"repositories"];
  
	[self didAccessValueForKey:@"repositories"];
	return result;
}
	






@end
