// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHRepository.m instead.

#import "_CDOHRepository.h"

const struct CDOHRepositoryAttributes CDOHRepositoryAttributes = {
	.createdAt = @"createdAt",
	.defaultBranch = @"defaultBranch",
	.fork = @"fork",
	.forksCount = @"forksCount",
	.hasDownloads = @"hasDownloads",
	.hasIssues = @"hasIssues",
	.hasWiki = @"hasWiki",
	.identifier = @"identifier",
	.language = @"language",
	.name = @"name",
	.openIssuesCount = @"openIssuesCount",
	.p_cloneURL = @"p_cloneURL",
	.p_gitURL = @"p_gitURL",
	.p_homepageURL = @"p_homepageURL",
	.p_mirrorURL = @"p_mirrorURL",
	.p_repositoryHTMLURL = @"p_repositoryHTMLURL",
	.p_sshURL = @"p_sshURL",
	.p_svnURL = @"p_svnURL",
	.private = @"private",
	.pushedAt = @"pushedAt",
	.repositoryDescription = @"repositoryDescription",
	.size = @"size",
	.updatedAt = @"updatedAt",
	.watchersCount = @"watchersCount",
};

const struct CDOHRepositoryRelationships CDOHRepositoryRelationships = {
	.forks = @"forks",
	.organization = @"organization",
	.owner = @"owner",
	.parent = @"parent",
	.source = @"source",
	.watchers = @"watchers",
};

const struct CDOHRepositoryFetchedProperties CDOHRepositoryFetchedProperties = {
};

@implementation CDOHRepositoryID
@end

@implementation _CDOHRepository

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHRepository" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHRepository";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHRepository" inManagedObjectContext:moc_];
}

- (CDOHRepositoryID*)objectID {
	return (CDOHRepositoryID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"forkValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fork"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"forksCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"forksCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"hasDownloadsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasDownloads"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"hasIssuesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasIssues"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"hasWikiValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasWiki"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"openIssuesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"openIssuesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"privateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"private"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"watchersCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"watchersCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic defaultBranch;






@dynamic fork;



- (BOOL)forkValue {
	NSNumber *result = [self fork];
	return [result boolValue];
}

- (void)setForkValue:(BOOL)value_ {
	[self setFork:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveForkValue {
	NSNumber *result = [self primitiveFork];
	return [result boolValue];
}

- (void)setPrimitiveForkValue:(BOOL)value_ {
	[self setPrimitiveFork:[NSNumber numberWithBool:value_]];
}





@dynamic forksCount;



- (int32_t)forksCountValue {
	NSNumber *result = [self forksCount];
	return [result intValue];
}

- (void)setForksCountValue:(int32_t)value_ {
	[self setForksCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveForksCountValue {
	NSNumber *result = [self primitiveForksCount];
	return [result intValue];
}

- (void)setPrimitiveForksCountValue:(int32_t)value_ {
	[self setPrimitiveForksCount:[NSNumber numberWithInt:value_]];
}





@dynamic hasDownloads;



- (BOOL)hasDownloadsValue {
	NSNumber *result = [self hasDownloads];
	return [result boolValue];
}

- (void)setHasDownloadsValue:(BOOL)value_ {
	[self setHasDownloads:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHasDownloadsValue {
	NSNumber *result = [self primitiveHasDownloads];
	return [result boolValue];
}

- (void)setPrimitiveHasDownloadsValue:(BOOL)value_ {
	[self setPrimitiveHasDownloads:[NSNumber numberWithBool:value_]];
}





@dynamic hasIssues;



- (BOOL)hasIssuesValue {
	NSNumber *result = [self hasIssues];
	return [result boolValue];
}

- (void)setHasIssuesValue:(BOOL)value_ {
	[self setHasIssues:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHasIssuesValue {
	NSNumber *result = [self primitiveHasIssues];
	return [result boolValue];
}

- (void)setPrimitiveHasIssuesValue:(BOOL)value_ {
	[self setPrimitiveHasIssues:[NSNumber numberWithBool:value_]];
}





@dynamic hasWiki;



- (BOOL)hasWikiValue {
	NSNumber *result = [self hasWiki];
	return [result boolValue];
}

- (void)setHasWikiValue:(BOOL)value_ {
	[self setHasWiki:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHasWikiValue {
	NSNumber *result = [self primitiveHasWiki];
	return [result boolValue];
}

- (void)setPrimitiveHasWikiValue:(BOOL)value_ {
	[self setPrimitiveHasWiki:[NSNumber numberWithBool:value_]];
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





@dynamic language;






@dynamic name;






@dynamic openIssuesCount;



- (int32_t)openIssuesCountValue {
	NSNumber *result = [self openIssuesCount];
	return [result intValue];
}

- (void)setOpenIssuesCountValue:(int32_t)value_ {
	[self setOpenIssuesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveOpenIssuesCountValue {
	NSNumber *result = [self primitiveOpenIssuesCount];
	return [result intValue];
}

- (void)setPrimitiveOpenIssuesCountValue:(int32_t)value_ {
	[self setPrimitiveOpenIssuesCount:[NSNumber numberWithInt:value_]];
}





@dynamic p_cloneURL;






@dynamic p_gitURL;






@dynamic p_homepageURL;






@dynamic p_mirrorURL;






@dynamic p_repositoryHTMLURL;






@dynamic p_sshURL;






@dynamic p_svnURL;






@dynamic private;



- (BOOL)privateValue {
	NSNumber *result = [self private];
	return [result boolValue];
}

- (void)setPrivateValue:(BOOL)value_ {
	[self setPrivate:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePrivateValue {
	NSNumber *result = [self primitivePrivate];
	return [result boolValue];
}

- (void)setPrimitivePrivateValue:(BOOL)value_ {
	[self setPrimitivePrivate:[NSNumber numberWithBool:value_]];
}





@dynamic pushedAt;






@dynamic repositoryDescription;






@dynamic size;



- (int64_t)sizeValue {
	NSNumber *result = [self size];
	return [result longLongValue];
}

- (void)setSizeValue:(int64_t)value_ {
	[self setSize:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveSizeValue {
	NSNumber *result = [self primitiveSize];
	return [result longLongValue];
}

- (void)setPrimitiveSizeValue:(int64_t)value_ {
	[self setPrimitiveSize:[NSNumber numberWithLongLong:value_]];
}





@dynamic updatedAt;






@dynamic watchersCount;



- (int32_t)watchersCountValue {
	NSNumber *result = [self watchersCount];
	return [result intValue];
}

- (void)setWatchersCountValue:(int32_t)value_ {
	[self setWatchersCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveWatchersCountValue {
	NSNumber *result = [self primitiveWatchersCount];
	return [result intValue];
}

- (void)setPrimitiveWatchersCountValue:(int32_t)value_ {
	[self setPrimitiveWatchersCount:[NSNumber numberWithInt:value_]];
}





@dynamic forks;

	
- (NSMutableSet*)forksSet {
	[self willAccessValueForKey:@"forks"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"forks"];
  
	[self didAccessValueForKey:@"forks"];
	return result;
}
	

@dynamic organization;

	

@dynamic owner;

	

@dynamic parent;

	

@dynamic source;

	

@dynamic watchers;

	
- (NSMutableSet*)watchersSet {
	[self willAccessValueForKey:@"watchers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"watchers"];
  
	[self didAccessValueForKey:@"watchers"];
	return result;
}
	






@end
