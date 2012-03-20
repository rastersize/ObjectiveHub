// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CDOHResource.m instead.

#import "_CDOHResource.h"

const struct CDOHResourceAttributes CDOHResourceAttributes = {
	.p_resourceURL = @"p_resourceURL",
};

const struct CDOHResourceRelationships CDOHResourceRelationships = {
};

const struct CDOHResourceFetchedProperties CDOHResourceFetchedProperties = {
};

@implementation CDOHResourceID
@end

@implementation _CDOHResource

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CDOHResource" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CDOHResource";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CDOHResource" inManagedObjectContext:moc_];
}

- (CDOHResourceID*)objectID {
	return (CDOHResourceID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic p_resourceURL;











@end
