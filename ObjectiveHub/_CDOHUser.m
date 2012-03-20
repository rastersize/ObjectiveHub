// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHUser.m instead.

#import "_CDOHUser.h"

const struct CDOHUserAttributes CDOHUserAttributes = {
	.biography = @"biography",
	.hireable = @"hireable",
};

const struct CDOHUserRelationships CDOHUserRelationships = {
	.teams = @"teams",
	.watchedRepositories = @"watchedRepositories",
};

const struct CDOHUserFetchedProperties CDOHUserFetchedProperties = {
};

@implementation CDOHUserID
@end

@implementation _CDOHUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHUser" inManagedObjectContext:moc_];
}

- (CDOHUserID*)objectID {
	return (CDOHUserID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"hireableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hireable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic biography;






@dynamic hireable;



- (BOOL)hireableValue {
	NSNumber *result = [self hireable];
	return [result boolValue];
}

- (void)setHireableValue:(BOOL)value_ {
	[self setHireable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHireableValue {
	NSNumber *result = [self primitiveHireable];
	return [result boolValue];
}

- (void)setPrimitiveHireableValue:(BOOL)value_ {
	[self setPrimitiveHireable:[NSNumber numberWithBool:value_]];
}





@dynamic teams;

	
- (NSMutableSet*)teamsSet {
	[self willAccessValueForKey:@"teams"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teams"];
  
	[self didAccessValueForKey:@"teams"];
	return result;
}
	

@dynamic watchedRepositories;

	
- (NSMutableSet*)watchedRepositoriesSet {
	[self willAccessValueForKey:@"watchedRepositories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"watchedRepositories"];
  
	[self didAccessValueForKey:@"watchedRepositories"];
	return result;
}
	






@end
