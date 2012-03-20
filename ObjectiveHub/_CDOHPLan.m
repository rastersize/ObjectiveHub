// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHPLan.m instead.

#import "_CDOHPLan.h"

const struct CDOHPLanAttributes CDOHPLanAttributes = {
	.collaborators = @"collaborators",
	.name = @"name",
	.privateRepositories = @"privateRepositories",
	.space = @"space",
};

const struct CDOHPLanRelationships CDOHPLanRelationships = {
	.users = @"users",
};

const struct CDOHPLanFetchedProperties CDOHPLanFetchedProperties = {
};

@implementation CDOHPLanID
@end

@implementation _CDOHPLan

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHPLan" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHPLan";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHPLan" inManagedObjectContext:moc_];
}

- (CDOHPLanID*)objectID {
	return (CDOHPLanID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"collaboratorsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"collaborators"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"privateRepositoriesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"privateRepositories"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"spaceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"space"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic collaborators;



- (int32_t)collaboratorsValue {
	NSNumber *result = [self collaborators];
	return [result intValue];
}

- (void)setCollaboratorsValue:(int32_t)value_ {
	[self setCollaborators:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCollaboratorsValue {
	NSNumber *result = [self primitiveCollaborators];
	return [result intValue];
}

- (void)setPrimitiveCollaboratorsValue:(int32_t)value_ {
	[self setPrimitiveCollaborators:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic privateRepositories;



- (int32_t)privateRepositoriesValue {
	NSNumber *result = [self privateRepositories];
	return [result intValue];
}

- (void)setPrivateRepositoriesValue:(int32_t)value_ {
	[self setPrivateRepositories:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePrivateRepositoriesValue {
	NSNumber *result = [self primitivePrivateRepositories];
	return [result intValue];
}

- (void)setPrimitivePrivateRepositoriesValue:(int32_t)value_ {
	[self setPrimitivePrivateRepositories:[NSNumber numberWithInt:value_]];
}





@dynamic space;



- (int64_t)spaceValue {
	NSNumber *result = [self space];
	return [result longLongValue];
}

- (void)setSpaceValue:(int64_t)value_ {
	[self setSpace:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveSpaceValue {
	NSNumber *result = [self primitiveSpace];
	return [result longLongValue];
}

- (void)setPrimitiveSpaceValue:(int64_t)value_ {
	[self setPrimitiveSpace:[NSNumber numberWithLongLong:value_]];
}





@dynamic users;

	
- (NSMutableSet*)usersSet {
	[self willAccessValueForKey:@"users"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"users"];
  
	[self didAccessValueForKey:@"users"];
	return result;
}
	






@end
