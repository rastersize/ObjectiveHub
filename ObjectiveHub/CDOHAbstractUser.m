//
//  CDOHAbstractUser.m
//  ObjectiveHub
//
//  Copyright 2011-2012 Aron Cedercrantz. All rights reserved.
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

#import "CDOHAbstractUser.h"
#import "CDOHAbstractUserPrivate.h"
#import "CDOHResourcePrivate.h"
#import "CDOHPlan.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserLoginKey				= @"login";
NSString *const kCDOHUserIDKey					= @"id";
NSString *const kCDOHUserAvatarURLKey			= @"avatar_url";
NSString *const kCDOHUserGravatarIDKey			= @"gravatar_id";
NSString *const kCDOHUserNameKey				= @"name";
NSString *const kCDOHUserCompanyKey				= @"company";
NSString *const kCDOHUserBlogKey				= @"blog";
NSString *const kCDOHUserLocationKey			= @"location";
NSString *const kCDOHUserEmailKey				= @"email";
NSString *const kCDOHUserPublicReposKey			= @"public_repos";
NSString *const kCDOHUserPublicGistsKey			= @"public_gists";
NSString *const kCDOHUserFollowersKey			= @"followers";
NSString *const kCDOHUserFollowingKey			= @"following";
NSString *const kCDOHUserHTMLURLKey				= @"html_url";
NSString *const kCDOHUserCreatedAtKey			= @"created_at";
NSString *const kCDOHUserTypeKey				= @"type";
NSString *const kCDOHUserTotalPrivateReposKey	= @"total_private_repos";
NSString *const kCDOHUserOwnedPrivateReposKey	= @"owned_private_repos";
NSString *const kCDOHUserPrivateGistsKey		= @"private_gists";
NSString *const kCDOHUserDiskUsageKey			= @"disk_usage";
NSString *const kCDOHUserCollaboratorsKey		= @"collaborators";
NSString *const kCDOHUserPlanKey				= @"plan";

NSString *const kCDOHUserAuthenticatedKey		= @"internal_authed";


#pragma mark - CDOHAbstractUser Implementation
@implementation CDOHAbstractUser

#pragma mark - Synthesization
@synthesize name = _name;
@synthesize company = _company;
@synthesize email = _email;
@synthesize location = _location;
@synthesize blogURL = _blogUrl;
@synthesize authenticated = _authenticated;
@synthesize identifier = _identifier;
@synthesize login = _login;
@synthesize avatarURL = _avatarUrl;
@synthesize gravatarID = _gravatarId;
@synthesize htmlURL = _htmlUrl;
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
		// Custom logic
		NSNumber *authenticated = [dictionary valueForKey:kCDOHUserAuthenticatedKey];
		_authenticated = [authenticated boolValue] || ([dictionary valueForKey:kCDOHUserTotalPrivateReposKey] != nil);
		
		// Strings
		_login		= [[dictionary valueForKey:kCDOHUserLoginKey] copy];
		_name		= [[dictionary valueForKey:kCDOHUserNameKey] copy];
		_company	= [[dictionary valueForKey:kCDOHUserCompanyKey] copy];
		_email		= [[dictionary valueForKey:kCDOHUserEmailKey] copy];
		_location	= [[dictionary valueForKey:kCDOHUserLocationKey] copy];
		_type		= [[dictionary valueForKey:kCDOHUserTypeKey] copy];
		_gravatarId	= [[dictionary valueForKey:kCDOHUserGravatarIDKey] copy];
		
		// URLs
		_blogUrl		= [CDOHResource URLObjectFromDictionary:dictionary usingKey:kCDOHUserBlogKey];
		_avatarUrl		= [CDOHResource URLObjectFromDictionary:dictionary usingKey:kCDOHUserAvatarURLKey];
		_htmlUrl		= [CDOHResource URLObjectFromDictionary:dictionary usingKey:kCDOHUserHTMLURLKey];
		
		// Dates
		_createdAt = [CDOHResource dateObjectFromDictionary:dictionary usingKey:kCDOHUserCreatedAtKey];
		
		// Unsigned integers
		_identifier							= [[dictionary valueForKey:kCDOHUserIDKey] unsignedIntegerValue];
		_numberOfPublicRepositories			= [[dictionary valueForKey:kCDOHUserPublicReposKey] unsignedIntegerValue];		
		_numberOfPrivateRepositories		= [[dictionary valueForKey:kCDOHUserTotalPrivateReposKey] unsignedIntegerValue];
		_numberOfOwnedPrivateRepositories	= [[dictionary valueForKey:kCDOHUserOwnedPrivateReposKey] unsignedIntegerValue];
		_numberOfPublicGists				= [[dictionary valueForKey:kCDOHUserPublicGistsKey] unsignedIntegerValue];
		_numberOfPrivateGists				= [[dictionary valueForKey:kCDOHUserPrivateGistsKey] unsignedIntegerValue];
		_followers							= [[dictionary valueForKey:kCDOHUserFollowersKey] unsignedIntegerValue];
		_following							= [[dictionary valueForKey:kCDOHUserFollowingKey] unsignedIntegerValue];
		_collaborators						= [[dictionary valueForKey:kCDOHUserCollaboratorsKey] unsignedIntegerValue];
		_diskUsage							= [[dictionary valueForKey:kCDOHUserDiskUsageKey] unsignedIntegerValue];
		
		// Resources
		_plan = [CDOHResource resourceObjectFromDictionary:dictionary usingKey:kCDOHUserPlanKey ofClass:[CDOHPlan class]];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSMutableDictionary *finalDictionary = nil;
	NSDictionary *superDictionary = [super encodeAsDictionary];
	
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
	
	NSDictionary *planDict = [_plan encodeAsDictionary];
	
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								_login,							kCDOHUserLoginKey,
								_name,							kCDOHUserNameKey,
								_company,						kCDOHUserCompanyKey,
								_email,							kCDOHUserEmailKey,
								_location,						kCDOHUserLocationKey,
								_blogUrl,						kCDOHUserBlogKey,
								_avatarUrl,						kCDOHUserAvatarURLKey,
								_gravatarId,					kCDOHUserGravatarIDKey,
								_htmlUrl,						kCDOHUserHTMLURLKey,
								_createdAt,						kCDOHUserCreatedAtKey,
								_type,							kCDOHUserTypeKey,
								planDict,						kCDOHUserPlanKey,
								identifierNumber,				kCDOHUserIDKey,
								authenticatedNumber,			kCDOHUserAuthenticatedKey,
								publicRepositoriesNumber,		kCDOHUserPublicReposKey,
								publicGistsNumber,				kCDOHUserPublicGistsKey,
								privateRepositoriesNumber,		kCDOHUserTotalPrivateReposKey,
								privateOwnedRepositoriesNumber,	kCDOHUserOwnedPrivateReposKey,
								privateGistsNumber,				kCDOHUserPrivateGistsKey,
								followersNumber,				kCDOHUserFollowersKey,
								followingNumber,				kCDOHUserFollowingKey,
								collaboratorsNumber,			kCDOHUserCollaboratorsKey,
								diskUsageNumber,				kCDOHUserDiskUsageKey,
								nil];
	
	NSUInteger finalDictionaryCapacity = [dictionary count] + [superDictionary count];
	finalDictionary = [[NSMutableDictionary alloc] initWithCapacity:finalDictionaryCapacity];
	[finalDictionary addEntriesFromDictionary:superDictionary];
	[finalDictionary addEntriesFromDictionary:dictionary];
	
	return finalDictionary;
}


#pragma mark - Describing an Abstract User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %lu, login = %@, type = %@, is authed = %@ }>",
			[self class],
			self,
			_identifier,
			_login,
			_type,
			(_authenticated ? @"YES" : @"NO")];
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
	return [self isEqualToAbstractUser:other];
}

- (BOOL)isEqualToAbstractUser:(CDOHAbstractUser *)aUser
{
	if (aUser == self) {
		return YES;
	}
	
	return (aUser.identifier == self.identifier &&
			[_type isEqualToString:aUser.type]);
}

- (NSUInteger)hash
{
	NSUInteger prime = 31;
	NSUInteger hash = 1;
	
	hash = prime + _identifier;
	hash = prime * hash + [_type hash];
	
	return hash;
}

@end
