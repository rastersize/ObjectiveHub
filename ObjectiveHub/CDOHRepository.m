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
NSString *const kCDOHRepositoryHtmlUrlKey			= @"html_url";
NSString *const kCDOHRepositoryCloneUrlKey			= @"clone_url";
NSString *const kCDOHRepositoryGitUrlKey			= @"git_url";
NSString *const kCDOHRepositorySshUrlKey			= @"ssh_url";
NSString *const kCDOHRepositorySvnUrlKey			= @"svn_url";
NSString *const kCDOHRepositoryMirrorUrlKey			= @"mirror_url";
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
@synthesize svnURL = _svnUrl;
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
- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super initWithDictionary:dictionary];
	if (self) {
		// URLs
		_htmlUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryHtmlUrlKey];
		_cloneUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryCloneUrlKey];
		_gitUrl					= [dictionary cdoh_URLForKey:kCDOHRepositoryGitUrlKey];
		_sshUrl					= [dictionary cdoh_URLForKey:kCDOHRepositorySshUrlKey];
		_svnUrl					= [dictionary cdoh_URLForKey:kCDOHRepositorySvnUrlKey];
		_mirrorUrl				= [dictionary cdoh_URLForKey:kCDOHRepositoryMirrorUrlKey];
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
- (NSDictionary *)encodeAsDictionary
{
	NSDictionary *superDictionary = [super encodeAsDictionary];
	NSMutableDictionary *finalDictionary = [[NSMutableDictionary alloc] initWithCapacity:28 + [superDictionary count]];
	[finalDictionary addEntriesFromDictionary:superDictionary];
	
	// Strings
	[finalDictionary cdoh_setObject:_name forKey:kCDOHRepositoryNameKey];
	[finalDictionary cdoh_setObject:_repositoryDescription forKey:kCDOHRepositoryDescriptionKey];
	[finalDictionary cdoh_setObject:_language forKey:kCDOHRepositoryLanguageKey];
	[finalDictionary cdoh_setObject:_defaultBranch forKey:kCDOHRepositoryDefaultBranchKey];
	
	// Booleans
	[finalDictionary cdoh_setBool:_private forKey:kCDOHRepositoryPrivateKey];
	[finalDictionary cdoh_setBool:_fork forKey:kCDOHRepositoryForkKey];
	[finalDictionary cdoh_setBool:_hasWiki forKey:kCDOHRepositoryHasWikiKey];
	[finalDictionary cdoh_setBool:_hasIssues forKey:kCDOHRepositoryHasIssuesKey];
	[finalDictionary cdoh_setBool:_hasDownloads forKey:kCDOHRepositoryHasDownloadsKey];
	
	// Unsigned integers
	[finalDictionary cdoh_setUnsignedInteger:_identifier forKey:kCDOHRepositoryIdentifierKey];
	[finalDictionary cdoh_setUnsignedInteger:_forks forKey:kCDOHRepositoryForksKey];
	[finalDictionary cdoh_setUnsignedInteger:_watchers forKey:kCDOHRepositoryWatchersKey];
	[finalDictionary cdoh_setUnsignedInteger:_size forKey:kCDOHRepositorySizeKey];
	[finalDictionary cdoh_setUnsignedInteger:_openIssues forKey:kCDOHRepositoryOpenIssuesKey];
	
	// Resources
	[finalDictionary cdoh_encodeAndSetResource:_owner forKey:kCDOHRepositoryOwnerKey];
	[finalDictionary cdoh_encodeAndSetResource:_organization forKey:kCDOHRepositoryOrganizationKey];
	[finalDictionary cdoh_encodeAndSetResource:_parentRepository forKey:kCDOHRepositoryParentRepositoryKey];
	[finalDictionary cdoh_encodeAndSetResource:_sourceRepository forKey:kCDOHRepositorySourceRepositoryKey];
	
	// URLs
	[finalDictionary cdoh_encodeAndSetURL:_htmlUrl forKey:kCDOHRepositoryHtmlUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_cloneUrl forKey:kCDOHRepositoryCloneUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_gitUrl forKey:kCDOHRepositoryGitUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_sshUrl forKey:kCDOHRepositorySshUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_svnUrl forKey:kCDOHRepositorySvnUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_mirrorUrl forKey:kCDOHRepositoryMirrorUrlKey];
	[finalDictionary cdoh_encodeAndSetURL:_homepage forKey:kCDOHRepositoryHomepageKey];
	
	// Dates
	[finalDictionary cdoh_encodeAndSetDate:_updatedAt forKey:kCDOHRepositoryUpdatedAtKey];
	[finalDictionary cdoh_encodeAndSetDate:_pushedAt forKey:kCDOHRepositoryPushedAtKey];
	[finalDictionary cdoh_encodeAndSetDate:_createdAt forKey:kCDOHRepositoryCreatedAtKey];

	return finalDictionary;
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
