//
//  FGOHUser.m
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  
//  1. Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//  
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//  
//  THIS SOFTWARE IS PROVIDED BY ARON CEDERCRANTZ ''AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
//  EVENT SHALL ARON CEDERCRANTZ OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  
//  The views and conclusions contained in the software and documentation are
//  those of the authors and should not be interpreted as representing official
//  policies, either expressed or implied, of Aron Cedercrantz.
//

#import "FGOHUser.h"
#import "FGOHUserPrivate.h"
#import "FGOHPlanPrivate.h"


#pragma mark Dictionary Keys
NSString *const kFGOHUserDictionaryLoginKey				= @"login";
NSString *const kFGOHUserDictionaryIDKey				= @"id";
NSString *const kFGOHUserDictionaryAvatarURLKey			= @"avatar_url";
NSString *const kFGOHUserDictionaryGravatarIDKey		= @"gravatar_id";
NSString *const kFGOHUserDictionaryNameKey				= @"name";
NSString *const kFGOHUserDictionaryCompanyKey			= @"company";
NSString *const kFGOHUserDictionaryBlogKey				= @"blog";
NSString *const kFGOHUserDictionaryLocationKey			= @"location";
NSString *const kFGOHUserDictionaryEmailKey				= @"email";
NSString *const kFGOHUserDictionaryHireableKey			= @"hireable";
NSString *const kFGOHUserDictionaryBioKey				= @"bio";
NSString *const kFGOHUserDictionaryPublicReposKey		= @"public_repos";
NSString *const kFGOHUserDictionaryPublicGistsKey		= @"public_gists";
NSString *const kFGOHUserDictionaryFollowersKey			= @"followers";
NSString *const kFGOHUserDictionaryFollowingKey			= @"following";
NSString *const kFGOHUserDictionaryHTMLURLKey			= @"html_url";
NSString *const kFGOHUserDictionaryCreatedAtKey			= @"created_at";
NSString *const kFGOHUserDictionaryTypeKey				= @"type";
NSString *const kFGOHUserDictionaryTotalPrivateReposKey	= @"total_private_repos";
NSString *const kFGOHUserDictionaryOwnedPrivateReposKey	= @"owned_private_repos";
NSString *const kFGOHUserDictionaryPrivateGistsKey		= @"private_gists";
NSString *const kFGOHUserDictionaryDiskUsageKey			= @"disk_usage";
NSString *const kFGOHUserDictionaryCollaboratorsKey		= @"collaborators";
NSString *const kFGOHUserDictionaryPlanKey				= @"plan";

NSString *const kFGOHUserDictionaryAuthenticatedKey		= @"internal_authed";
NSString *const kFGOHUserDictionaryAPIURLKey			= @"url";


@interface FGOHUser ()

@property (strong) NSURL *apiResourceUrl;

@end


#pragma mark - FGOHUser Implementation
@implementation FGOHUser

#pragma mark - Synthesizing
@synthesize name = _name;
@synthesize company = _company;
@synthesize email = _email;
@synthesize biography = _biography;
@synthesize location = _location;
@synthesize blogUrl = _blogUrl;
@synthesize authenticated = _authenticated;
@synthesize identifier = _identifier;
@synthesize login = _login;
@synthesize avatarUrl = _avatarUrl;
@synthesize gravatarId = _gravatarId;
@synthesize htmlUrl = _htmlUrl;
@synthesize hireable = _hireable;
@synthesize numberOfPublicRepositories = _numberOfPublicRepositories;
@synthesize numberOfPrivateRepositories = _numberOfPrivateRepositories;
@synthesize numberOfOwnedPrivateRepositories = _numberOfOwnedPrivateRepositories;
@synthesize numberOfPublicGists = _numberOfPublicGists;
@synthesize numberOfPrivateGists = _numberOfPrivateGists;
@synthesize followers = _followers;
@synthesize following = _following;
@synthesize collaborators = _collaborators;
@synthesize createdAt = _createdAt;
@synthesize type = _type;
@synthesize diskUsage = _diskUsage;
@synthesize plan = _plan;

@synthesize apiResourceUrl = _apiResourceUrl;


#pragma mark - Initializing an FGOHUser Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		[self setupUsingDictionary:dictionary];
	}
	
	return self;
}


#pragma mark - Transform Between Instance Variables and Dictionary
- (NSDictionary *)encodeAsDictionary
{
	NSNumber *identifierNumber					= [NSNumber numberWithUnsignedInteger:self.identifier];
	NSNumber *authenticatedNumber				= [NSNumber numberWithBool:self.isAuthenticated];
	NSNumber *hireableNumber					= [NSNumber numberWithBool:self.hireable];
	NSNumber *publicRepositoriesNumber			= [NSNumber numberWithUnsignedInteger:self.numberOfPublicRepositories];
	NSNumber *publicGistsNumber					= [NSNumber numberWithUnsignedInteger:self.numberOfPublicGists];
	NSNumber *privateRepositoriesNumber			= [NSNumber numberWithUnsignedInteger:self.numberOfPrivateRepositories];
	NSNumber *privateOwnedRepositoriesNumber	= [NSNumber numberWithUnsignedInteger:self.numberOfOwnedPrivateRepositories];
	NSNumber *privateGistsNumber				= [NSNumber numberWithUnsignedInteger:self.numberOfPrivateGists];
	NSNumber *followersNumber					= [NSNumber numberWithUnsignedInteger:self.followers];
	NSNumber *followingNumber					= [NSNumber numberWithUnsignedInteger:self.following];
	NSNumber *collaboratorsNumber				= [NSNumber numberWithUnsignedInteger:self.collaborators];
	NSNumber *diskUsageNumber					= [NSNumber numberWithUnsignedInteger:self.diskUsage];
	NSDictionary *planDictionary				= [self.plan encodeAsDictionary];
	
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								self.apiResourceUrl,			kFGOHUserDictionaryAPIURLKey,
								self.login,						kFGOHUserDictionaryLoginKey,
								self.name,						kFGOHUserDictionaryNameKey,
								self.company,					kFGOHUserDictionaryCompanyKey,
								self.email,						kFGOHUserDictionaryEmailKey,
								self.biography,					kFGOHUserDictionaryBioKey,
								self.location,					kFGOHUserDictionaryLocationKey,
								self.blogUrl,					kFGOHUserDictionaryBlogKey,
								self.avatarUrl,					kFGOHUserDictionaryAvatarURLKey,
								self.gravatarId,				kFGOHUserDictionaryGravatarIDKey,
								self.htmlUrl,					kFGOHUserDictionaryHTMLURLKey,
								self.createdAt,					kFGOHUserDictionaryCreatedAtKey,
								self.type,						kFGOHUserDictionaryTypeKey,
								identifierNumber,				kFGOHUserDictionaryIDKey,
								authenticatedNumber,			kFGOHUserDictionaryAuthenticatedKey,
								hireableNumber,					kFGOHUserDictionaryHireableKey,
								publicRepositoriesNumber,		kFGOHUserDictionaryPublicReposKey,
								publicGistsNumber,				kFGOHUserDictionaryPublicGistsKey,
								privateRepositoriesNumber,		kFGOHUserDictionaryTotalPrivateReposKey,
								privateOwnedRepositoriesNumber,	kFGOHUserDictionaryOwnedPrivateReposKey,
								privateGistsNumber,				kFGOHUserDictionaryPrivateGistsKey,
								followersNumber,				kFGOHUserDictionaryFollowersKey,
								followingNumber,				kFGOHUserDictionaryFollowingKey,
								collaboratorsNumber,			kFGOHUserDictionaryCollaboratorsKey,
								diskUsageNumber,				kFGOHUserDictionaryDiskUsageKey,
								planDictionary,					kFGOHUserDictionaryPlanKey,
								nil];
	
	return dictionary;
}

- (void)setupUsingDictionary:(NSDictionary *)dictionary
{
	NSString *login = [dictionary valueForKey:kFGOHUserDictionaryLoginKey];
	_login = [login copy];
	
	NSString *name = [dictionary valueForKey:kFGOHUserDictionaryNameKey];
	_name = [name copy];
	
	NSString *company = [dictionary valueForKey:kFGOHUserDictionaryCompanyKey];
	_company = [company copy];
	
	NSString *email = [dictionary valueForKey:kFGOHUserDictionaryEmailKey];
	_email = [email copy];
	
	NSString *bio = [dictionary valueForKey:kFGOHUserDictionaryBioKey];
	_biography = [bio copy];
	
	NSString *location = [dictionary valueForKey:kFGOHUserDictionaryLocationKey];
	_location = [location copy];
	
	NSString *type = [dictionary valueForKey:kFGOHUserDictionaryTypeKey];
	_type = [type copy];
	
	NSString *gravatarId = [dictionary valueForKey:kFGOHUserDictionaryGravatarIDKey];
	_gravatarId = [gravatarId copy];
	
	//--//
	_apiResourceUrl	= [dictionary valueForKey:kFGOHUserDictionaryAPIURLKey];
	_blogUrl		= [dictionary valueForKey:kFGOHUserDictionaryBlogKey];
	_avatarUrl		= [dictionary valueForKey:kFGOHUserDictionaryAvatarURLKey];
	_htmlUrl		= [dictionary valueForKey:kFGOHUserDictionaryHTMLURLKey];
	
	
	//--//
	// TODO: Parse the created at date.
	NSDate *createdAt = [dictionary valueForKey:kFGOHUserDictionaryCreatedAtKey];
	_createdAt = createdAt;
	
	//--//
	NSNumber *authenticated = [dictionary valueForKey:kFGOHUserDictionaryAuthenticatedKey];
	_authenticated = [authenticated boolValue] || ([dictionary valueForKey:kFGOHUserDictionaryTotalPrivateReposKey] != nil);
	
	NSNumber *hireable = [dictionary valueForKey:kFGOHUserDictionaryHireableKey];
	_hireable = [hireable boolValue];
	
	
	//--//
	NSNumber *identifier = [dictionary valueForKey:kFGOHUserDictionaryIDKey];
	_identifier = [identifier unsignedIntegerValue];
	
	NSNumber *publicRepos = [dictionary valueForKey:kFGOHUserDictionaryPublicReposKey];
	_numberOfPublicRepositories = [publicRepos unsignedIntegerValue];
	
	NSNumber *privateRepos = [dictionary valueForKey:kFGOHUserDictionaryTotalPrivateReposKey];
	_numberOfPrivateRepositories = [privateRepos unsignedIntegerValue];
	
	NSNumber *ownedRepos = [dictionary valueForKey:kFGOHUserDictionaryOwnedPrivateReposKey];
	_numberOfOwnedPrivateRepositories = [ownedRepos unsignedIntegerValue];
	
	NSNumber *publicGists = [dictionary valueForKey:kFGOHUserDictionaryPublicGistsKey];
	_numberOfPublicGists = [publicGists unsignedIntegerValue];
	
	NSNumber *privateGists = [dictionary valueForKey:kFGOHUserDictionaryPrivateGistsKey];
	_numberOfPrivateGists = [privateGists unsignedIntegerValue];
	
	NSNumber *followers = [dictionary valueForKey:kFGOHUserDictionaryFollowersKey];
	_followers = [followers unsignedIntegerValue];
	
	NSNumber *following = [dictionary valueForKey:kFGOHUserDictionaryFollowingKey];
	_following = [following unsignedIntegerValue];
	
	NSNumber *collaborators = [dictionary valueForKey:kFGOHUserDictionaryCollaboratorsKey];
	_collaborators = [collaborators unsignedIntegerValue];
	
	NSNumber *diskUsage = [dictionary valueForKey:kFGOHUserDictionaryDiskUsageKey];
	_diskUsage = [diskUsage unsignedIntegerValue];
	
	
	//--//
	NSDictionary *planDict = [dictionary valueForKey:kFGOHUserDictionaryPlanKey];
	if (planDict) {
		_plan = [[FGOHPlan alloc] initWithDictionary:planDict];
	}
}


#pragma mark - Identifying and Comparing Users
- (BOOL)isEqual:(id)other
{
	if (other == self) {
		return YES;
	}
	if (!other || ![other isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToUser:other];
}

- (BOOL)isEqualToUser:(FGOHUser *)aUser
{
	if (aUser == self) {
		return YES;
	}
	
	return (aUser.identifier == self.identifier);
}

- (NSUInteger)hash
{
	return self.identifier;
}


#pragma mark - NSCopying Method
- (id)copyWithZone:(NSZone *)zone
{
	// Simply return a retained pointer to this instance as the class is
	// immutable.
	return self;
}


#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSDictionary *dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
	return [self initWithDictionary:dictionary];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	NSDictionary *dictionary = [self encodeAsDictionary];
	[aCoder encodeObject:dictionary forKey:@"dictionary"];
}


#pragma mark - Describing a User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %d, login = %@, resource = %@, is authed = %@ }>", [self class], self, self.identifier, self.login, self.apiResourceUrl, (self.isAuthenticated ? @"YES" : @"NO")];
}


@end
