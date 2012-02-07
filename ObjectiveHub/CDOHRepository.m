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

#import "NSString+ObjectiveHub.h"

#pragma mark NSCoding and GitHub JSON Keys
//FIXME: These will soon be change from *_url to *_links
NSString *const kCDOHRepositoryHtmlUrlKey			= @"html_url";
NSString *const kCDOHRepositoryCloneUrlKey			= @"clone_url";
NSString *const kCDOHRepositoryGitUrlKey			= @"git_url";
NSString *const kCDOHRepositorySshUrlKey			= @"ssh_url";
NSString *const kCDOHRepositorySvnUrlKey			= @"svn_url";
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


#pragma mark - CDOHRepository Implementation
@implementation CDOHRepository

#pragma mark - Synthesization
@synthesize HTMLURL = _htmlUrl;
@synthesize cloneURL = _cloneUrl;
@synthesize gitURL = _gitUrl;
@synthesize SSHURL = _sshUrl;
@synthesize svnURL = _svnUrl;
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
		_htmlUrl	= [self URLObjectFromDictionary:dictionary usingKey:kCDOHRepositoryHtmlUrlKey];
		_cloneUrl	= [self URLObjectFromDictionary:dictionary usingKey:kCDOHRepositoryCloneUrlKey];
		_gitUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHRepositoryGitUrlKey];
		_sshUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHRepositorySshUrlKey];
		_svnUrl		= [self URLObjectFromDictionary:dictionary usingKey:kCDOHRepositorySvnUrlKey];
		
		// Strings
		_name = [[dictionary objectForKey:kCDOHRepositoryNameKey] copy];
		_repositoryDescription = [[dictionary objectForKey:kCDOHRepositoryDescriptionKey] copy];
		_homepage = [dictionary objectForKey:kCDOHRepositoryHomepageKey];
		_language = [[dictionary objectForKey:kCDOHRepositoryLanguageKey] copy];
		_defaultBranch = [[dictionary objectForKey:kCDOHRepositoryDefaultBranchKey] copy];
		
		// Resources
		_owner = [self resourceObjectFromDictionary:dictionary usingKey:kCDOHRepositoryOwnerKey ofClass:[CDOHUser class]];
		_organization = [self resourceObjectFromDictionary:dictionary usingKey:kCDOHRepositoryOwnerKey ofClass:[CDOHOrganization class]];
		_parentRepository = [self resourceObjectFromDictionary:dictionary usingKey:kCDOHRepositoryOwnerKey ofClass:[CDOHRepository class]];
		_sourceRepository = [self resourceObjectFromDictionary:dictionary usingKey:kCDOHRepositoryOwnerKey ofClass:[CDOHRepository class]];
		
		// Dates
		_pushedAt = [self dateObjectFromDictionary:dictionary usingKey:kCDOHRepositoryPushedAtKey];
		_createdAt = [self dateObjectFromDictionary:dictionary usingKey:kCDOHRepositoryCreatedAtKey];
		
		// Booleans
		_private = [[dictionary objectForKey:kCDOHRepositoryPrivateKey] boolValue];
		_fork = [[dictionary objectForKey:kCDOHRepositoryForkKey] boolValue];
		_hasWiki = [[dictionary objectForKey:kCDOHRepositoryHasWikiKey] boolValue];
		_hasIssues = [[dictionary objectForKey:kCDOHRepositoryHasIssuesKey] boolValue];
		_hasDownloads = [[dictionary objectForKey:kCDOHRepositoryHasDownloadsKey] boolValue];
		
		// Unsigned integers
		_forks = [[dictionary objectForKey:kCDOHRepositoryForksKey] unsignedIntegerValue];
		_watchers = [[dictionary objectForKey:kCDOHRepositoryWatchersKey] unsignedIntegerValue];
		_size = [[dictionary objectForKey:kCDOHRepositorySizeKey] unsignedIntegerValue];
		_openIssues = [[dictionary objectForKey:kCDOHRepositoryOpenIssuesKey] unsignedIntegerValue];
		
		// Custom logic
		_formattedName = [_owner.login stringByAppendingFormat:@"/%@", _name];
	}
	
	return self;
}


#pragma mark - Encoding Resources
- (NSDictionary *)encodeAsDictionary
{
	NSMutableDictionary *finalDictionary = nil;
	NSDictionary *superDictionary = [super encodeAsDictionary];
	
	NSNumber *privateNum = [[NSNumber alloc] initWithBool:_private];
	NSNumber *forkNum = [[NSNumber alloc] initWithBool:_fork];
	NSNumber *hasWikiNum = [[NSNumber alloc] initWithBool:_hasWiki];
	NSNumber *hasIssuesNum = [[NSNumber alloc] initWithBool:_hasIssues];
	NSNumber *hasDownloadsNum = [[NSNumber alloc] initWithBool:_hasDownloads];
	
	NSNumber *forksNum = [[NSNumber alloc] initWithUnsignedInteger:_forks];
	NSNumber *watchersNum = [[NSNumber alloc] initWithUnsignedInteger:_watchers];
	NSNumber *sizeNum = [[NSNumber alloc] initWithUnsignedInteger:_size];
	NSNumber *openIssuesNum = [[NSNumber alloc] initWithUnsignedInteger:_openIssues];
	
	NSDictionary *ownerDict = [_owner encodeAsDictionary];
	NSDictionary *organizationDict = [_organization encodeAsDictionary];
	NSDictionary *parentDict = [_parentRepository encodeAsDictionary];
	NSDictionary *sourceDict = [_sourceRepository encodeAsDictionary];
	
	
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
						  _htmlUrl,					kCDOHRepositoryHtmlUrlKey,
						  _cloneUrl,				kCDOHRepositoryCloneUrlKey,
						  _gitUrl,					kCDOHRepositoryGitUrlKey,
						  _sshUrl,					kCDOHRepositorySshUrlKey,
						  _svnUrl,					kCDOHRepositorySvnUrlKey,
						  ownerDict,				kCDOHRepositoryOwnerKey,
						  _name,					kCDOHRepositoryNameKey,
						  _repositoryDescription,	kCDOHRepositoryDescriptionKey,
						  _homepage,				kCDOHRepositoryHomepageKey,
						  _language,				kCDOHRepositoryLanguageKey,
						  privateNum,				kCDOHRepositoryPrivateKey,
						  watchersNum,				kCDOHRepositoryWatchersKey,
						  sizeNum,					kCDOHRepositorySizeKey,
						  _defaultBranch,			kCDOHRepositoryDefaultBranchKey,
						  openIssuesNum,			kCDOHRepositoryOpenIssuesKey,
						  hasIssuesNum,				kCDOHRepositoryHasIssuesKey,
						  _pushedAt,				kCDOHRepositoryPushedAtKey,
						  _createdAt,				kCDOHRepositoryCreatedAtKey,
						  organizationDict,			kCDOHRepositoryOrganizationKey,
						  forkNum,					kCDOHRepositoryForkKey,
						  forksNum,					kCDOHRepositoryForksKey,
						  parentDict,				kCDOHRepositoryParentRepositoryKey,
						  sourceDict,				kCDOHRepositorySourceRepositoryKey,
						  hasWikiNum,				kCDOHRepositoryHasWikiKey,
						  hasDownloadsNum,			kCDOHRepositoryHasDownloadsKey,
						  nil];
	
	NSUInteger finalDictionaryCapacity = [dictionary count] + [superDictionary count];
	finalDictionary = [[NSMutableDictionary alloc] initWithCapacity:finalDictionaryCapacity];
	[finalDictionary addEntriesFromDictionary:superDictionary];
	[finalDictionary addEntriesFromDictionary:dictionary];
	
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
	
	return ([_owner isEqual:aRepository.owner] &&
			[_name isEqualToString:aRepository.name] &&
			[_organization isEqual:aRepository.organization]);
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
