//
//  CDOHRepository.m
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

#import "CDOHRepository.h"
#import "CDOHRepositoryPrivate.h"
#import "CDOHResourcePrivate.h"

#import "CDOHUser.h"
#import "CDOHOrganization.h"

#import "NSDate+ObjectiveHub.h"
#import "NSMutableDictionary+ObjectiveHub.h"

#pragma mark - Dictionary Representation Keys
//FIXME: These will soon be change from *_url to *_links
NSString *const kCDOHRepositoryHTMLURLKey			= @"html_url";
NSString *const kCDOHRepositoryCloneURLKey			= @"clone_url";
NSString *const kCDOHRepositoryGitURLKey			= @"git_url";
NSString *const kCDOHRepositorySSHURLKey			= @"ssh_url";
NSString *const kCDOHRepositorySVNURLKey			= @"svn_url";
NSString *const kCDOHRepositoryMirrorURLKey			= @"mirror_url";
NSString *const kCDOHRepositoryIdentifierKey		= @"id";
NSString *const kCDOHRepositoryOwnerKey				= @"owner";
NSString *const kCDOHRepositoryNameKey				= @"name";
NSString *const kCDOHRepositoryDescriptionKey		= @"description";
NSString *const kCDOHRepositoryHomepageKey			= @"homepage";
NSString *const kCDOHRepositoryLanguageKey			= @"language";
NSString *const kCDOHRepositoryPrivateKey			= @"private";
NSString *const kCDOHRepositoryWatchersKey			= @"watchers";
NSString *const kCDOHRepositorySizeKey				= @"size";
//FIXME: This will soon be changed to default_branch:
NSString *const kCDOHRepositoryDefaultBranchKey		= @"master_branch";
NSString *const kCDOHRepositoryOpenIssuesKey		= @"open_issues";
NSString *const kCDOHRepositoryHasIssuesKey			= @"has_issues";
NSString *const kCDOHRepositoryUpdatedAtKey			= @"updated_at";
NSString *const kCDOHRepositoryPushedAtKey			= @"pushed_at";
NSString *const kCDOHRepositoryCreatedAtKey			= @"created_at";
NSString *const kCDOHRepositoryOrganizationKey		= @"organization";
NSString *const kCDOHRepositoryForkKey				= @"fork";
NSString *const kCDOHRepositoryForksKey				= @"forks";
NSString *const kCDOHRepositoryParentRepositoryKey	= @"parent";
NSString *const kCDOHRepositorySourceRepositoryKey	= @"source";
NSString *const kCDOHRepositoryHasWikiKey			= @"has_wiki";
NSString *const kCDOHRepositoryHasDownloadsKey		= @"has_downloads";
NSString *const kCDOHRepositoryTeamIDKey			= @"team_id";


#pragma mark - Repository Language Dictionary Keys
NSString *const kCDOHRepositoryLanguageNameKey			= @"name";
NSString *const kCDOHRepositoryLanguageCharactersKey	= @"characters";


#pragma mark - CDOHRepository Implementation
@implementation CDOHRepository

#pragma mark - Synthesization
@synthesize HTMLURL = _htmlUrl;
@synthesize cloneURL = _cloneUrl;
@synthesize gitURL = _gitUrl;
@synthesize SSHURL = _sshUrl;
@synthesize SVNURL = _svnUrl;
@synthesize mirrorURL = _mirrorUrl;
@synthesize identifier = _identifier;
@synthesize owner = _owner;
@synthesize name = _name;
@synthesize repositoryDescription = _repositoryDescription;
@synthesize homepage = _homepage;
@synthesize language = _language;
@synthesize private = _private;
@synthesize watchers = _watchers;
@synthesize size = _size;
@synthesize defaultBranch = _defaultBranch;
@synthesize openIssues = _openIssues;
@synthesize hasIssues = _hasIssues;
@synthesize updatedAt = _updatedAt;
@synthesize pushedAt = _pushedAt;
@synthesize createdAt = _createdAt;
@synthesize organization = _organization;
@synthesize fork = _fork;
@synthesize forks = _forks;
@synthesize parentRepository = _parentRepository;
@synthesize sourceRepository = _sourceRepository;
@synthesize hasWiki = _hasWiki;
@synthesize hasDownloads = _hasDownloads;
@synthesize formattedName = _formattedName;


#pragma mark - Initializing an CDOHRepository Instance
- (id)initWithJSONDictionary:(NSDictionary *)dictionary
{
	self = [super initWithJSONDictionary:dictionary];
	if (self) {
		// URLs
		_htmlUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryHTMLURLKey];
		_cloneUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryCloneURLKey];
		_gitUrl					= [dictionary cdoh_URLForKey:kCDOHRepositoryGitURLKey];
		_sshUrl					= [dictionary cdoh_URLForKey:kCDOHRepositorySSHURLKey];
		_svnUrl					= [dictionary cdoh_URLForKey:kCDOHRepositorySVNURLKey];
		_mirrorUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryMirrorURLKey];
		_homepage				= [dictionary cdoh_URLForKey:kCDOHRepositoryHomepageKey];
		
		// Strings
		_name					= [[dictionary cdoh_objectOrNilForKey:kCDOHRepositoryNameKey] copy];
		_repositoryDescription	= [[dictionary cdoh_objectOrNilForKey:kCDOHRepositoryDescriptionKey] copy];
		_language				= [[dictionary cdoh_objectOrNilForKey:kCDOHRepositoryLanguageKey] copy];
		_defaultBranch			= [[dictionary cdoh_objectOrNilForKey:kCDOHRepositoryDefaultBranchKey] copy];
		
		// Resources
		_owner					= [dictionary cdoh_resourceForKey:kCDOHRepositoryOwnerKey ofClass:[CDOHUser class]];
		_organization			= [dictionary cdoh_resourceForKey:kCDOHRepositoryOrganizationKey ofClass:[CDOHOrganization class]];
		_parentRepository		= [dictionary cdoh_resourceForKey:kCDOHRepositoryParentRepositoryKey ofClass:[CDOHRepository class]];
		_sourceRepository		= [dictionary cdoh_resourceForKey:kCDOHRepositorySourceRepositoryKey ofClass:[CDOHRepository class]];
		
		// Dates
		_updatedAt				= [dictionary cdoh_dateForKey:kCDOHRepositoryUpdatedAtKey];
		_pushedAt				= [dictionary cdoh_dateForKey:kCDOHRepositoryPushedAtKey];
		_createdAt				= [dictionary cdoh_dateForKey:kCDOHRepositoryCreatedAtKey];
		
		// Booleans
		_private				= [[dictionary cdoh_numberForKey:kCDOHRepositoryPrivateKey] boolValue];
		_fork					= [[dictionary cdoh_numberForKey:kCDOHRepositoryForkKey] boolValue];
		_hasWiki				= [[dictionary cdoh_numberForKey:kCDOHRepositoryHasWikiKey] boolValue];
		_hasIssues				= [[dictionary cdoh_numberForKey:kCDOHRepositoryHasIssuesKey] boolValue];
		_hasDownloads			= [[dictionary cdoh_numberForKey:kCDOHRepositoryHasDownloadsKey] boolValue];
		
		// Unsigned integers
		_identifier				= [[dictionary cdoh_numberForKey:kCDOHRepositoryIdentifierKey] unsignedIntegerValue];
		_forks					= [[dictionary cdoh_numberForKey:kCDOHRepositoryForksKey] unsignedIntegerValue];
		_watchers				= [[dictionary cdoh_numberForKey:kCDOHRepositoryWatchersKey] unsignedIntegerValue];
		_size					= [[dictionary cdoh_numberForKey:kCDOHRepositorySizeKey] unsignedIntegerValue];
		_openIssues				= [[dictionary cdoh_numberForKey:kCDOHRepositoryOpenIssuesKey] unsignedIntegerValue];
		
		// Custom logic
		_formattedName			= [_owner.login stringByAppendingFormat:@"/%@", _name];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		// URLs
		_htmlUrl				= [aDecoder decodeObjectForKey:kCDOHRepositoryHTMLURLKey];
		_cloneUrl				= [aDecoder decodeObjectForKey:kCDOHRepositoryCloneURLKey];
		_gitUrl					= [aDecoder decodeObjectForKey:kCDOHRepositoryGitURLKey];
		_sshUrl					= [aDecoder decodeObjectForKey:kCDOHRepositorySSHURLKey];
		_svnUrl					= [aDecoder decodeObjectForKey:kCDOHRepositorySVNURLKey];
		_mirrorUrl				= [aDecoder decodeObjectForKey:kCDOHRepositoryMirrorURLKey];
		_homepage				= [aDecoder decodeObjectForKey:kCDOHRepositoryHomepageKey];
		
		// Strings
		_name					= [[aDecoder decodeObjectForKey:kCDOHRepositoryNameKey] copy];
		_repositoryDescription	= [[aDecoder decodeObjectForKey:kCDOHRepositoryDescriptionKey] copy];
		_language				= [[aDecoder decodeObjectForKey:kCDOHRepositoryLanguageKey] copy];
		_defaultBranch			= [[aDecoder decodeObjectForKey:kCDOHRepositoryDefaultBranchKey] copy];
		
		// Resources
		_owner					= [aDecoder decodeObjectForKey:kCDOHRepositoryOwnerKey];
		_organization			= [aDecoder decodeObjectForKey:kCDOHRepositoryOrganizationKey];
		_parentRepository		= [aDecoder decodeObjectForKey:kCDOHRepositoryParentRepositoryKey];
		_sourceRepository		= [aDecoder decodeObjectForKey:kCDOHRepositorySourceRepositoryKey];
		
		// Dates
		_updatedAt				= [aDecoder decodeObjectForKey:kCDOHRepositoryUpdatedAtKey];
		_pushedAt				= [aDecoder decodeObjectForKey:kCDOHRepositoryPushedAtKey];
		_createdAt				= [aDecoder decodeObjectForKey:kCDOHRepositoryCreatedAtKey];
		
		// Booleans
		_private				= [aDecoder decodeBoolForKey:kCDOHRepositoryPrivateKey];
		_fork					= [aDecoder decodeBoolForKey:kCDOHRepositoryForkKey];
		_hasWiki				= [aDecoder decodeBoolForKey:kCDOHRepositoryHasWikiKey];
		_hasIssues				= [aDecoder decodeBoolForKey:kCDOHRepositoryHasIssuesKey];
		_hasDownloads			= [aDecoder decodeBoolForKey:kCDOHRepositoryHasDownloadsKey];
		
		// Unsigned integers
		_identifier				= [[aDecoder decodeObjectForKey:kCDOHRepositoryIdentifierKey] unsignedIntegerValue];
		_forks					= [[aDecoder decodeObjectForKey:kCDOHRepositoryForksKey] unsignedIntegerValue];
		_watchers				= [[aDecoder decodeObjectForKey:kCDOHRepositoryWatchersKey] unsignedIntegerValue];
		_size					= [[aDecoder decodeObjectForKey:kCDOHRepositorySizeKey] unsignedIntegerValue];
		_openIssues				= [[aDecoder decodeObjectForKey:kCDOHRepositoryOpenIssuesKey] unsignedIntegerValue];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	[aCoder encodeObject:_htmlUrl forKey:kCDOHRepositoryHTMLURLKey];
	[aCoder encodeObject:_cloneUrl forKey:kCDOHRepositoryCloneURLKey];
	[aCoder encodeObject:_gitUrl forKey:kCDOHRepositoryGitURLKey];
	[aCoder encodeObject:_sshUrl forKey:kCDOHRepositorySSHURLKey];
	[aCoder encodeObject:_svnUrl forKey:kCDOHRepositorySVNURLKey];
	[aCoder encodeObject:_mirrorUrl forKey:kCDOHRepositoryMirrorURLKey];
	[aCoder encodeObject:_homepage forKey:kCDOHRepositoryHomepageKey];
	[aCoder encodeObject:_name forKey:kCDOHRepositoryNameKey];
	[aCoder encodeObject:_repositoryDescription forKey:kCDOHRepositoryDescriptionKey];
	[aCoder encodeObject:_language forKey:kCDOHRepositoryLanguageKey];
	[aCoder encodeObject:_defaultBranch forKey:kCDOHRepositoryDefaultBranchKey];
	[aCoder encodeObject:_owner forKey:kCDOHRepositoryOwnerKey];
	[aCoder encodeObject:_organization forKey:kCDOHRepositoryOrganizationKey];
	[aCoder encodeObject:_parentRepository forKey:kCDOHRepositoryParentRepositoryKey];
	[aCoder encodeObject:_sourceRepository forKey:kCDOHRepositorySourceRepositoryKey];
	[aCoder encodeObject:_updatedAt forKey:kCDOHRepositoryUpdatedAtKey];
	[aCoder encodeObject:_pushedAt forKey:kCDOHRepositoryPushedAtKey];
	[aCoder encodeObject:_createdAt forKey:kCDOHRepositoryCreatedAtKey];
	
	[aCoder encodeBool:_private forKey:kCDOHRepositoryPrivateKey];
	[aCoder encodeBool:_fork forKey:kCDOHRepositoryForkKey];
	[aCoder encodeBool:_hasWiki forKey:kCDOHRepositoryHasWikiKey];
	[aCoder encodeBool:_hasIssues forKey:kCDOHRepositoryHasIssuesKey];
	[aCoder encodeBool:_hasDownloads forKey:kCDOHRepositoryHasDownloadsKey];
	
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_identifier] forKey:kCDOHRepositoryIdentifierKey];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_forks] forKey:kCDOHRepositoryForksKey];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_watchers] forKey:kCDOHRepositoryWatchersKey];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_size] forKey:kCDOHRepositorySizeKey];
	[aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_openIssues] forKey:kCDOHRepositoryOpenIssuesKey];
}


#pragma mark - Identifying and Comparing Users
- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (!object || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	
	return [self isEqualToRepository:object];
}

- (BOOL)isEqualToRepository:(CDOHRepository *)aRepository
{
	if (aRepository == self) {
		return YES;
	}
	
	return (self.identifier == aRepository.identifier);
}

- (NSUInteger)hash
{
	NSUInteger prime = 31;
	NSUInteger hash = 1;
	
	hash = prime + [_owner hash];
	hash = prime * hash + [_name hash];
	hash = prime * hash + [_organization hash];
	
	return hash;
}


#pragma mark - Describing a Repository Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { %@/%@ }>",
			[self class],
			self,
			self.owner.login,
			self.name];
}

@end
