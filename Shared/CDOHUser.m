//
//  CDOHUser.m
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

#import "CDOHUser.h"
#import "CDOHUserPrivate.h"
#import "CDOHPlanPrivate.h"
#import "CDOHResourcePrivate.h"


#pragma mark Dictionary Keys
NSString *const kCDOHUserDictionaryLoginKey				= @"login";
NSString *const kCDOHUserDictionaryIDKey				= @"id";
NSString *const kCDOHUserDictionaryAvatarURLKey			= @"avatar_url";
NSString *const kCDOHUserDictionaryGravatarIDKey		= @"gravatar_id";
NSString *const kCDOHUserDictionaryNameKey				= @"name";
NSString *const kCDOHUserDictionaryCompanyKey			= @"company";
NSString *const kCDOHUserDictionaryBlogKey				= @"blog";
NSString *const kCDOHUserDictionaryLocationKey			= @"location";
NSString *const kCDOHUserDictionaryEmailKey				= @"email";
NSString *const kCDOHUserDictionaryHireableKey			= @"hireable";
NSString *const kCDOHUserDictionaryBioKey				= @"bio";
NSString *const kCDOHUserDictionaryPublicReposKey		= @"public_repos";
NSString *const kCDOHUserDictionaryPublicGistsKey		= @"public_gists";
NSString *const kCDOHUserDictionaryFollowersKey			= @"followers";
NSString *const kCDOHUserDictionaryFollowingKey			= @"following";
NSString *const kCDOHUserDictionaryHTMLURLKey			= @"html_url";
NSString *const kCDOHUserDictionaryCreatedAtKey			= @"created_at";
NSString *const kCDOHUserDictionaryTypeKey				= @"type";
NSString *const kCDOHUserDictionaryTotalPrivateReposKey	= @"total_private_repos";
NSString *const kCDOHUserDictionaryOwnedPrivateReposKey	= @"owned_private_repos";
NSString *const kCDOHUserDictionaryPrivateGistsKey		= @"private_gists";
NSString *const kCDOHUserDictionaryDiskUsageKey			= @"disk_usage";
NSString *const kCDOHUserDictionaryCollaboratorsKey		= @"collaborators";
NSString *const kCDOHUserDictionaryPlanKey				= @"plan";

NSString *const kCDOHUserDictionaryAuthenticatedKey		= @"internal_authed";


#pragma mark - CDOHUser Private Interface
@interface CDOHUser ()


@end



#pragma mark - CDOHUser Implementation
@implementation CDOHUser

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


#pragma mark - Initializing an CDOHUser Instance
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		NSString *login = [dictionary valueForKey:kCDOHUserDictionaryLoginKey];
		_login = [login copy];
		
		NSString *name = [dictionary valueForKey:kCDOHUserDictionaryNameKey];
		_name = [name copy];
		
		NSString *company = [dictionary valueForKey:kCDOHUserDictionaryCompanyKey];
		_company = [company copy];
		
		NSString *email = [dictionary valueForKey:kCDOHUserDictionaryEmailKey];
		_email = [email copy];
		
		NSString *bio = [dictionary valueForKey:kCDOHUserDictionaryBioKey];
		_biography = [bio copy];
		
		NSString *location = [dictionary valueForKey:kCDOHUserDictionaryLocationKey];
		_location = [location copy];
		
		NSString *type = [dictionary valueForKey:kCDOHUserDictionaryTypeKey];
		_type = [type copy];
		
		NSString *gravatarId = [dictionary valueForKey:kCDOHUserDictionaryGravatarIDKey];
		_gravatarId = [gravatarId copy];
		
		//--//
		_blogUrl		= [dictionary valueForKey:kCDOHUserDictionaryBlogKey];
		_avatarUrl		= [dictionary valueForKey:kCDOHUserDictionaryAvatarURLKey];
		_htmlUrl		= [dictionary valueForKey:kCDOHUserDictionaryHTMLURLKey];
		
		
		//--//
		id createdAtObj = [dictionary valueForKey:kCDOHUserDictionaryCreatedAtKey];
		if (createdAtObj) {
			if ([createdAtObj isKindOfClass:[NSDate class]]) {
				_createdAt = createdAtObj;
			} else if ([createdAtObj isKindOfClass:[NSString class]]) {
				// TODO: Parse the created at date.
				NSLog(@"Not yet implemented 2008-01-14T04:33:35Z -> NSDate");
			} else {
#if DEBUG
				NSAssert(NO, @"Unkown representation of 'created at', skipping.");
#else
				NSLog(@"Unkown representation of 'created at', skipping.");
#endif
			}
		}
		
		//--//
		NSNumber *authenticated = [dictionary valueForKey:kCDOHUserDictionaryAuthenticatedKey];
		_authenticated = [authenticated boolValue] || ([dictionary valueForKey:kCDOHUserDictionaryTotalPrivateReposKey] != nil);
		
		NSNumber *hireable = [dictionary valueForKey:kCDOHUserDictionaryHireableKey];
		_hireable = [hireable boolValue];
		
		
		//--//
		NSNumber *identifier = [dictionary valueForKey:kCDOHUserDictionaryIDKey];
		_identifier = [identifier unsignedIntegerValue];

		NSNumber *publicRepos = [dictionary valueForKey:kCDOHUserDictionaryPublicReposKey];
		_numberOfPublicRepositories = [publicRepos unsignedIntegerValue];
		
		NSNumber *privateRepos = [dictionary valueForKey:kCDOHUserDictionaryTotalPrivateReposKey];
		_numberOfPrivateRepositories = [privateRepos unsignedIntegerValue];
		
		NSNumber *ownedRepos = [dictionary valueForKey:kCDOHUserDictionaryOwnedPrivateReposKey];
		_numberOfOwnedPrivateRepositories = [ownedRepos unsignedIntegerValue];
		
		NSNumber *publicGists = [dictionary valueForKey:kCDOHUserDictionaryPublicGistsKey];
		_numberOfPublicGists = [publicGists unsignedIntegerValue];
		
		NSNumber *privateGists = [dictionary valueForKey:kCDOHUserDictionaryPrivateGistsKey];
		_numberOfPrivateGists = [privateGists unsignedIntegerValue];
		
		NSNumber *followers = [dictionary valueForKey:kCDOHUserDictionaryFollowersKey];
		_followers = [followers unsignedIntegerValue];
		
		NSNumber *following = [dictionary valueForKey:kCDOHUserDictionaryFollowingKey];
		_following = [following unsignedIntegerValue];
		
		NSNumber *collaborators = [dictionary valueForKey:kCDOHUserDictionaryCollaboratorsKey];
		_collaborators = [collaborators unsignedIntegerValue];
		
		NSNumber *diskUsage = [dictionary valueForKey:kCDOHUserDictionaryDiskUsageKey];
		_diskUsage = [diskUsage unsignedIntegerValue];
		
		
		//--//
		id planObj = [dictionary valueForKey:kCDOHUserDictionaryPlanKey];
		if (planObj) {
			if ([planObj isKindOfClass:[CDOHPlan class]]) {
				_plan = planObj;
			} else if ([planObj isKindOfClass:[NSDictionary class]]) {
				_plan = [[CDOHPlan alloc] initWithDictionary:planObj];
			} else {
#if DEBUG
				NSAssert(NO, @"Unkown representation of 'created at', skipping.");
#else
				NSLog(@"Unkown representation of 'created at', skipping.");
#endif
			}
		}
	}
	
	return self;
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

- (BOOL)isEqualToUser:(CDOHUser *)aUser
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
- (id)copyWithZone:(NSZone *)__unused zone
{
	// Simply return a retained pointer to this instance as the class is
	// immutable.
	return self;
}


#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	NSDictionary *dictionary = [decoder decodeObjectForKey:@"CDOHUserPropertiesDictionary"];
	self = [self initWithDictionary:dictionary];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	NSNumber *identifierNumber					= [NSNumber numberWithUnsignedInteger:self.identifier];
	NSNumber *publicRepositoriesNumber			= [NSNumber numberWithUnsignedInteger:self.numberOfPublicRepositories];
	NSNumber *publicGistsNumber					= [NSNumber numberWithUnsignedInteger:self.numberOfPublicGists];
	NSNumber *privateRepositoriesNumber			= [NSNumber numberWithUnsignedInteger:self.numberOfPrivateRepositories];
	NSNumber *privateOwnedRepositoriesNumber	= [NSNumber numberWithUnsignedInteger:self.numberOfOwnedPrivateRepositories];
	NSNumber *privateGistsNumber				= [NSNumber numberWithUnsignedInteger:self.numberOfPrivateGists];
	NSNumber *followersNumber					= [NSNumber numberWithUnsignedInteger:self.followers];
	NSNumber *followingNumber					= [NSNumber numberWithUnsignedInteger:self.following];
	NSNumber *collaboratorsNumber				= [NSNumber numberWithUnsignedInteger:self.collaborators];
	NSNumber *diskUsageNumber					= [NSNumber numberWithUnsignedInteger:self.diskUsage];
	
	NSNumber *authenticatedNumber				= [NSNumber numberWithBool:self.isAuthenticated];
	NSNumber *hireableNumber					= [NSNumber numberWithBool:self.hireable];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								_login,							kCDOHUserDictionaryLoginKey,
								_name,							kCDOHUserDictionaryNameKey,
								_company,						kCDOHUserDictionaryCompanyKey,
								_email,							kCDOHUserDictionaryEmailKey,
								_biography,						kCDOHUserDictionaryBioKey,
								_location,						kCDOHUserDictionaryLocationKey,
								_blogUrl,						kCDOHUserDictionaryBlogKey,
								_avatarUrl,						kCDOHUserDictionaryAvatarURLKey,
								_gravatarId,					kCDOHUserDictionaryGravatarIDKey,
								_htmlUrl,						kCDOHUserDictionaryHTMLURLKey,
								_createdAt,						kCDOHUserDictionaryCreatedAtKey,
								_type,							kCDOHUserDictionaryTypeKey,
								_plan,							kCDOHUserDictionaryPlanKey,
								identifierNumber,				kCDOHUserDictionaryIDKey,
								authenticatedNumber,			kCDOHUserDictionaryAuthenticatedKey,
								hireableNumber,					kCDOHUserDictionaryHireableKey,
								publicRepositoriesNumber,		kCDOHUserDictionaryPublicReposKey,
								publicGistsNumber,				kCDOHUserDictionaryPublicGistsKey,
								privateRepositoriesNumber,		kCDOHUserDictionaryTotalPrivateReposKey,
								privateOwnedRepositoriesNumber,	kCDOHUserDictionaryOwnedPrivateReposKey,
								privateGistsNumber,				kCDOHUserDictionaryPrivateGistsKey,
								followersNumber,				kCDOHUserDictionaryFollowersKey,
								followingNumber,				kCDOHUserDictionaryFollowingKey,
								collaboratorsNumber,			kCDOHUserDictionaryCollaboratorsKey,
								diskUsageNumber,				kCDOHUserDictionaryDiskUsageKey,
								nil];
	
	[coder encodeObject:dictionary forKey:@"CDOHUserPropertiesDictionary"];
}


#pragma mark - Describing a User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %d, login = %@, resource = %@, is authed = %@ }>",
			[self class],
			self,
			self.identifier,
			self.login,
			self._APIResourceURL,
			(self.isAuthenticated ? @"YES" : @"NO")];
}


@end
