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

#import "CDOHPlanPrivate.h"


#pragma mark NSCoding and GitHub JSON Keys
NSString *const kCDOHUserDictionaryLoginKey				= @"login";
NSString *const kCDOHUserDictionaryIDKey				= @"id";
NSString *const kCDOHUserDictionaryAvatarURLKey			= @"avatar_url";
NSString *const kCDOHUserDictionaryGravatarIDKey		= @"gravatar_id";
NSString *const kCDOHUserDictionaryNameKey				= @"name";
NSString *const kCDOHUserDictionaryCompanyKey			= @"company";
NSString *const kCDOHUserDictionaryBlogKey				= @"blog";
NSString *const kCDOHUserDictionaryLocationKey			= @"location";
NSString *const kCDOHUserDictionaryEmailKey				= @"email";
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
		NSNumber *authenticated = [dictionary valueForKey:kCDOHUserDictionaryAuthenticatedKey];
		_authenticated = [authenticated boolValue] || ([dictionary valueForKey:kCDOHUserDictionaryTotalPrivateReposKey] != nil);
		
		// Strings
		_login		= [[dictionary valueForKey:kCDOHUserDictionaryLoginKey] copy];
		_name		= [[dictionary valueForKey:kCDOHUserDictionaryNameKey] copy];
		_company	= [[dictionary valueForKey:kCDOHUserDictionaryCompanyKey] copy];
		_email		= [[dictionary valueForKey:kCDOHUserDictionaryEmailKey] copy];
		_location	= [[dictionary valueForKey:kCDOHUserDictionaryLocationKey] copy];
		_type		= [[dictionary valueForKey:kCDOHUserDictionaryTypeKey] copy];
		_gravatarId	= [[dictionary valueForKey:kCDOHUserDictionaryGravatarIDKey] copy];
		
		// URLs
		_blogUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHUserDictionaryBlogKey];
		_avatarUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHUserDictionaryAvatarURLKey];
		_htmlUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHUserDictionaryHTMLURLKey];
		
		// Dates
		_createdAt = [self dateObjectFromDictionary:dictionary usingKey:kCDOHUserDictionaryCreatedAtKey];
		
		// Unsigned integers
		_identifier							= [[dictionary valueForKey:kCDOHUserDictionaryIDKey] unsignedIntegerValue];
		_numberOfPublicRepositories			= [[dictionary valueForKey:kCDOHUserDictionaryPublicReposKey] unsignedIntegerValue];		
		_numberOfPrivateRepositories		= [[dictionary valueForKey:kCDOHUserDictionaryTotalPrivateReposKey] unsignedIntegerValue];
		_numberOfOwnedPrivateRepositories	= [[dictionary valueForKey:kCDOHUserDictionaryOwnedPrivateReposKey] unsignedIntegerValue];
		_numberOfPublicGists				= [[dictionary valueForKey:kCDOHUserDictionaryPublicGistsKey] unsignedIntegerValue];
		_numberOfPrivateGists				= [[dictionary valueForKey:kCDOHUserDictionaryPrivateGistsKey] unsignedIntegerValue];
		_followers							= [[dictionary valueForKey:kCDOHUserDictionaryFollowersKey] unsignedIntegerValue];
		_following							= [[dictionary valueForKey:kCDOHUserDictionaryFollowingKey] unsignedIntegerValue];
		_collaborators						= [[dictionary valueForKey:kCDOHUserDictionaryCollaboratorsKey] unsignedIntegerValue];
		_diskUsage							= [[dictionary valueForKey:kCDOHUserDictionaryDiskUsageKey] unsignedIntegerValue];
		
		// Resources
		_plan = [self resourceObjectFromDictionary:dictionary usingKey:kCDOHUserDictionaryPlanKey ofClass:[CDOHPlan class]];
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
								_login,							kCDOHUserDictionaryLoginKey,
								_name,							kCDOHUserDictionaryNameKey,
								_company,						kCDOHUserDictionaryCompanyKey,
								_email,							kCDOHUserDictionaryEmailKey,
								_location,						kCDOHUserDictionaryLocationKey,
								_blogUrl,						kCDOHUserDictionaryBlogKey,
								_avatarUrl,						kCDOHUserDictionaryAvatarURLKey,
								_gravatarId,					kCDOHUserDictionaryGravatarIDKey,
								_htmlUrl,						kCDOHUserDictionaryHTMLURLKey,
								_createdAt,						kCDOHUserDictionaryCreatedAtKey,
								_type,							kCDOHUserDictionaryTypeKey,
								planDict,						kCDOHUserDictionaryPlanKey,
								identifierNumber,				kCDOHUserDictionaryIDKey,
								authenticatedNumber,			kCDOHUserDictionaryAuthenticatedKey,
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
	
	NSUInteger finalDictionaryCapacity = [dictionary count] + [superDictionary count];
	finalDictionary = [[NSMutableDictionary alloc] initWithCapacity:finalDictionaryCapacity];
	[finalDictionary addEntriesFromDictionary:superDictionary];
	[finalDictionary addEntriesFromDictionary:dictionary];
	
	return finalDictionary;
}


#pragma mark - Describing an Abstract User Object
- (NSString *)description
{	
	return [NSString stringWithFormat:@"<%@: %p { id = %d, login = %@, type = %@, is authed = %@ }>",
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
