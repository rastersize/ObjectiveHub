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
		// A user is considerred authenticated if any of the following keys are
		// set:
		// - kCDOHUserAuthenticatedKey and is `YES`
		// - kCDOHUserTotalPrivateReposKey
		// - kCDOHUserOwnedPrivateReposKey
		// - kCDOHUserPrivateGistsKey
		// - kCDOHUserDiskUsageKey
		// - kCDOHUserCollaboratorsKey
		// - kCDOHUserPlanKey
		NSNumber *authenticated = [dictionary objectForKey:kCDOHUserAuthenticatedKey];
		_authenticated = ([authenticated boolValue] ||
						  ([dictionary objectForKey:kCDOHUserTotalPrivateReposKey] != nil) ||
						  ([dictionary objectForKey:kCDOHUserOwnedPrivateReposKey] != nil) ||
						  ([dictionary objectForKey:kCDOHUserPrivateGistsKey] != nil) ||
						  ([dictionary objectForKey:kCDOHUserDiskUsageKey] != nil) ||
						  ([dictionary objectForKey:kCDOHUserCollaboratorsKey] != nil) ||
						  ([dictionary objectForKey:kCDOHUserPlanKey] != nil));
		
		// Strings
		_login		= [[dictionary objectForKey:kCDOHUserLoginKey] copy];
		_name		= [[dictionary objectForKey:kCDOHUserNameKey] copy];
		_company	= [[dictionary objectForKey:kCDOHUserCompanyKey] copy];
		_email		= [[dictionary objectForKey:kCDOHUserEmailKey] copy];
		_location	= [[dictionary objectForKey:kCDOHUserLocationKey] copy];
		_type		= [[dictionary objectForKey:kCDOHUserTypeKey] copy];
		_gravatarId	= [[dictionary objectForKey:kCDOHUserGravatarIDKey] copy];
		
		// URLs
		_blogUrl		= [dictionary cdoh_URLForKey:kCDOHUserBlogKey];
		_avatarUrl		= [dictionary cdoh_URLForKey:kCDOHUserAvatarURLKey];
		_htmlUrl		= [dictionary cdoh_URLForKey:kCDOHUserHTMLURLKey];
		
		// Dates
		_createdAt = [dictionary cdoh_dateForKey:kCDOHUserCreatedAtKey];
		
		// Unsigned integers
		_identifier							= [[dictionary objectForKey:kCDOHUserIDKey] unsignedIntegerValue];
		_numberOfPublicRepositories			= [[dictionary objectForKey:kCDOHUserPublicReposKey] unsignedIntegerValue];		
		_numberOfPrivateRepositories		= [[dictionary objectForKey:kCDOHUserTotalPrivateReposKey] unsignedIntegerValue];
		_numberOfOwnedPrivateRepositories	= [[dictionary objectForKey:kCDOHUserOwnedPrivateReposKey] unsignedIntegerValue];
		_numberOfPublicGists				= [[dictionary objectForKey:kCDOHUserPublicGistsKey] unsignedIntegerValue];
		_numberOfPrivateGists				= [[dictionary objectForKey:kCDOHUserPrivateGistsKey] unsignedIntegerValue];
		_followers							= [[dictionary objectForKey:kCDOHUserFollowersKey] unsignedIntegerValue];
		_following							= [[dictionary objectForKey:kCDOHUserFollowingKey] unsignedIntegerValue];
		_collaborators						= [[dictionary objectForKey:kCDOHUserCollaboratorsKey] unsignedIntegerValue];
		_diskUsage							= [[dictionary objectForKey:kCDOHUserDiskUsageKey] unsignedIntegerValue];
		
		// Resources
		_plan = [dictionary cdoh_resourceForKey:kCDOHUserPlanKey ofClass:[CDOHPlan class]];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSDictionary *superDictionary = [super encodeAsDictionary];
	NSMutableDictionary *finalDictionary = [[NSMutableDictionary alloc] initWithDictionary:superDictionary];
	
	// Strings
	[finalDictionary cdoh_setObject:_login forKey:kCDOHUserLoginKey];
	[finalDictionary cdoh_setObject:_name forKey:kCDOHUserNameKey];
	[finalDictionary cdoh_setObject:_company forKey:kCDOHUserCompanyKey];
	[finalDictionary cdoh_setObject:_email forKey:kCDOHUserEmailKey];
	[finalDictionary cdoh_setObject:_location forKey:kCDOHUserLocationKey];
	[finalDictionary cdoh_setObject:_type forKey:kCDOHUserTypeKey];
	[finalDictionary cdoh_setObject:_gravatarId forKey:kCDOHUserGravatarIDKey];
	
	// Unsigned integers
	[finalDictionary cdoh_setUnsignedInteger:_identifier forKey:kCDOHUserIDKey];
	[finalDictionary cdoh_setUnsignedInteger:_numberOfPublicRepositories forKey:kCDOHUserPublicReposKey];
	[finalDictionary cdoh_setUnsignedInteger:_numberOfPublicGists forKey:kCDOHUserPublicGistsKey];
	[finalDictionary cdoh_setUnsignedInteger:_numberOfPrivateRepositories forKey:kCDOHUserTotalPrivateReposKey];
	[finalDictionary cdoh_setUnsignedInteger:_numberOfOwnedPrivateRepositories forKey:kCDOHUserOwnedPrivateReposKey];
	[finalDictionary cdoh_setUnsignedInteger:_numberOfPrivateGists forKey:kCDOHUserPrivateGistsKey];
	[finalDictionary cdoh_setUnsignedInteger:_followers forKey:kCDOHUserFollowersKey];
	[finalDictionary cdoh_setUnsignedInteger:_following forKey:kCDOHUserFollowingKey];
	[finalDictionary cdoh_setUnsignedInteger:_collaborators forKey:kCDOHUserCollaboratorsKey];
	[finalDictionary cdoh_setUnsignedInteger:_diskUsage forKey:kCDOHUserDiskUsageKey];
	
	// Booleans
	[finalDictionary cdoh_setBool:_authenticated forKey:kCDOHUserAuthenticatedKey];
	
	// URLs
	[finalDictionary cdoh_encodeAndSetURL:_blogUrl forKey:kCDOHUserBlogKey];
	[finalDictionary cdoh_encodeAndSetURL:_htmlUrl forKey:kCDOHUserHTMLURLKey];
	[finalDictionary cdoh_encodeAndSetURL:_avatarUrl forKey:kCDOHUserAvatarURLKey];
	
	// Dates
	[finalDictionary cdoh_encodeAndSetDate:_createdAt forKey:kCDOHUserCreatedAtKey];
	
	// Resources
	[finalDictionary cdoh_encodeAndSetResource:_plan forKey:kCDOHUserPlanKey];
	
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
	
	return (aUser.identifier == self.identifier);
}

- (NSUInteger)hash
{
	return _identifier;
}

@end
