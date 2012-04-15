//
//  CDOHRepository.h
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
#import "CDOHResourcePrivate.h"
#import "CDOHUser.h"


#pragma mark GitHub JSON Keys
// FIXME: These will soon be change from *_url to *_links
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
NSString *const kCDOHRepositoryHomepageURLKey		= @"homepage";
NSString *const kCDOHRepositoryLanguageKey			= @"language";
NSString *const kCDOHRepositoryPrivateKey			= @"private";
NSString *const kCDOHRepositoryWatchersKey			= @"watchers";
NSString *const kCDOHRepositorySizeKey				= @"size";
// FIXME: This will soon be changed to default_branch:
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
NSString *const kCDOHRepositoryTeamIdentifierKey	= @"team_id";


#pragma mark - Repository Language Dictionary Keys
NSString *const kCDOHRepositoryLanguageNameKey			= @"name";
NSString *const kCDOHRepositoryLanguageCharactersKey	= @"characters";


#pragma mark - CDOHRepository Implementation
@implementation CDOHRepository

#pragma mark - Properties
@synthesize cloneURL = _cloneURL;
@synthesize gitURL = _gitURL;
@synthesize sshURL = _sshURL;
@synthesize svnURL = _svnURL;
@synthesize mirrorURL = _mirrorURL;
@synthesize repositoryHTMLURL = _repositoryHTMLURL;
@synthesize homepageURL = _homepageURL;
@synthesize identifier = _identifier;
@synthesize private = _private;
@synthesize owner = _owner;
@synthesize organization = _organization;
@synthesize name = _name;
@synthesize repositoryDescription = _repositoryDescription;
@synthesize language = _language;
@synthesize watchersCount = _watchersCount;
@synthesize size = _size;
@synthesize updatedAt = _updatedAt;
@synthesize pushedAt = _pushedAt;
@synthesize createdAt = _createdAt;
@synthesize defaultBranch = _defaultBranch;
@synthesize openIssuesCount = _openIssuesCount;
@synthesize hasIssues = _hasIssues;
@synthesize hasWiki = _hasWiki;
@synthesize hasDownloads = _hasDownloads;
@synthesize fork = _fork;
@synthesize forksCount = _forksCount;
@synthesize parentRepository = _parentRepository;
@synthesize sourceRepository = _sourceRepository;
@synthesize formattedName = _formattedName;

#pragma mark - Creating and Initializing CDOHRepository Objects
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
{
	self = [super initWithJSONDictionary:jsonDictionary];
	if (self) {
		// Strings
		_name					= [[jsonDictionary cdoh_objectOrNilForKey:kCDOHRepositoryNameKey] copy];
		_repositoryDescription	= [[jsonDictionary cdoh_objectOrNilForKey:kCDOHRepositoryDescriptionKey] copy];
		_language				= [[jsonDictionary cdoh_objectOrNilForKey:kCDOHRepositoryLanguageKey] copy];
		_defaultBranch			= [[jsonDictionary cdoh_objectOrNilForKey:kCDOHRepositoryDefaultBranchKey] copy];
		
		// URLs
		_repositoryHTMLURL		= [jsonDictionary cdoh_URLForKey:kCDOHRepositoryHTMLURLKey];
		_cloneURL				= [jsonDictionary cdoh_URLForKey:kCDOHRepositoryCloneURLKey];
		_gitURL					= [jsonDictionary cdoh_URLForKey:kCDOHRepositoryGitURLKey];
		_sshURL					= [jsonDictionary cdoh_URLForKey:kCDOHRepositorySSHURLKey];
		_svnURL					= [jsonDictionary cdoh_URLForKey:kCDOHRepositorySVNURLKey];
		_mirrorURL				= [jsonDictionary cdoh_URLForKey:kCDOHRepositoryMirrorURLKey];
		_homepageURL			= [jsonDictionary cdoh_URLForKey:kCDOHRepositoryHomepageURLKey];
		
		// Dates
		_updatedAt				= [jsonDictionary cdoh_dateForKey:kCDOHRepositoryUpdatedAtKey];
		_pushedAt				= [jsonDictionary cdoh_dateForKey:kCDOHRepositoryPushedAtKey];
		_createdAt				= [jsonDictionary cdoh_dateForKey:kCDOHRepositoryCreatedAtKey];
		
		// Resources
		_owner					= [jsonDictionary cdoh_resourceForKey:kCDOHRepositoryOwnerKey ofClass:[CDOHUser class]];
		_organization			= [jsonDictionary cdoh_resourceForKey:kCDOHRepositoryOrganizationKey ofClass:[CDOHUser class]];
		_parentRepository		= [jsonDictionary cdoh_resourceForKey:kCDOHRepositoryParentRepositoryKey ofClass:[CDOHRepository class]];
		_sourceRepository		= [jsonDictionary cdoh_resourceForKey:kCDOHRepositorySourceRepositoryKey ofClass:[CDOHRepository class]];
		
		// Unsigned integers
		_identifier				= [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHRepositoryIdentifierKey];
		_forksCount				= [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHRepositoryForksKey];
		_watchersCount			= [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHRepositoryWatchersKey];
		_size					= [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHRepositorySizeKey];
		_openIssuesCount		= [jsonDictionary cdoh_unsignedIntegerForKey:kCDOHRepositoryOpenIssuesKey];
		
		// Booleans
		_private				= [jsonDictionary cdoh_boolForKey:kCDOHRepositoryPrivateKey];
		_fork					= [jsonDictionary cdoh_boolForKey:kCDOHRepositoryForkKey];
		_hasWiki				= [jsonDictionary cdoh_boolForKey:kCDOHRepositoryHasWikiKey];
		_hasIssues				= [jsonDictionary cdoh_boolForKey:kCDOHRepositoryHasIssuesKey];
		_hasDownloads			= [jsonDictionary cdoh_boolForKey:kCDOHRepositoryHasDownloadsKey];
		
		// Special logic
		_formattedName			= [_owner.login stringByAppendingFormat:@"/%@", _name];
	}
	
	return self;
}


#pragma mark - Encoding
- (void)encodeWithJSONDictionary:(NSMutableDictionary *)jsonDictionary
{
	[super encodeWithJSONDictionary:jsonDictionary];
	
	// Strings
	[jsonDictionary cdoh_setObject:_name forKey:kCDOHRepositoryNameKey];
	[jsonDictionary cdoh_setObject:_repositoryDescription forKey:kCDOHRepositoryDescriptionKey];
	[jsonDictionary cdoh_setObject:_language forKey:kCDOHRepositoryLanguageKey];
	[jsonDictionary cdoh_setObject:_defaultBranch forKey:kCDOHRepositoryDefaultBranchKey];
	
	// URLs
	[jsonDictionary cdoh_encodeAndSetURL:_repositoryHTMLURL forKey:kCDOHRepositoryHTMLURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_cloneURL forKey:kCDOHRepositoryCloneURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_gitURL forKey:kCDOHRepositoryGitURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_sshURL forKey:kCDOHRepositorySSHURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_svnURL forKey:kCDOHRepositorySVNURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_mirrorURL forKey:kCDOHRepositoryMirrorURLKey];
	[jsonDictionary cdoh_encodeAndSetURL:_homepageURL forKey:kCDOHRepositoryHomepageURLKey];
	
	// Dates
	[jsonDictionary cdoh_encodeAndSetDate:_updatedAt forKey:kCDOHRepositoryUpdatedAtKey];
	[jsonDictionary cdoh_encodeAndSetDate:_pushedAt forKey:kCDOHRepositoryPushedAtKey];
	[jsonDictionary cdoh_encodeAndSetDate:_createdAt forKey:kCDOHRepositoryCreatedAtKey];
	
	// Resources
	[jsonDictionary cdoh_encodeAndSetResource:_owner forKey:kCDOHRepositoryOwnerKey];
	[jsonDictionary cdoh_encodeAndSetResource:_organization forKey:kCDOHRepositoryOrganizationKey];
	[jsonDictionary cdoh_encodeAndSetResource:_parentRepository forKey:kCDOHRepositoryParentRepositoryKey];
	[jsonDictionary cdoh_encodeAndSetResource:_sourceRepository forKey:kCDOHRepositorySourceRepositoryKey];
	
	// Unsigned integers
	[jsonDictionary cdoh_setUnsignedInteger:_identifier forKey:kCDOHRepositoryIdentifierKey];
	[jsonDictionary cdoh_setUnsignedInteger:_forksCount forKey:kCDOHRepositoryForksKey];
	[jsonDictionary cdoh_setUnsignedInteger:_watchersCount forKey:kCDOHRepositoryWatchersKey];
	[jsonDictionary cdoh_setUnsignedInteger:_size forKey:kCDOHRepositorySizeKey];
	[jsonDictionary cdoh_setUnsignedInteger:_openIssuesCount forKey:kCDOHRepositoryOpenIssuesKey];
	
	// Booleans
	[jsonDictionary cdoh_setBool:_private forKey:kCDOHRepositoryPrivateKey];
	[jsonDictionary cdoh_setBool:_fork forKey:kCDOHRepositoryForkKey];
	[jsonDictionary cdoh_setBool:_hasWiki forKey:kCDOHRepositoryHasWikiKey];
	[jsonDictionary cdoh_setBool:_hasIssues forKey:kCDOHRepositoryHasIssuesKey];
	[jsonDictionary cdoh_setBool:_hasDownloads forKey:kCDOHRepositoryHasDownloadsKey];
}


#pragma mark -
+ (void)JSONKeyToPropertyNameDictionary:(NSMutableDictionary *)dictionary
{
	[super JSONKeyToPropertyNameDictionary:dictionary];
	
	CDOHSetPropertyForJSONKey(identifier,				kCDOHRepositoryIdentifierKey, dictionary);
	CDOHSetPropertyForJSONKey(isPrivate,					kCDOHRepositoryPrivateKey, dictionary);
	CDOHSetPropertyForJSONKey(owner,					kCDOHRepositoryOwnerKey, dictionary);
	CDOHSetPropertyForJSONKey(organization,				kCDOHRepositoryOrganizationKey, dictionary);
	CDOHSetPropertyForJSONKey(name,						kCDOHRepositoryNameKey, dictionary);
	CDOHSetPropertyForJSONKey(repositoryDescription,	kCDOHRepositoryDescriptionKey, dictionary);
	CDOHSetPropertyForJSONKey(cloneURL,					kCDOHRepositoryCloneURLKey, dictionary);
	CDOHSetPropertyForJSONKey(gitURL,					kCDOHRepositoryGitURLKey, dictionary);
	CDOHSetPropertyForJSONKey(sshURL,					kCDOHRepositorySSHURLKey, dictionary);
	CDOHSetPropertyForJSONKey(svnURL,					kCDOHRepositorySVNURLKey, dictionary);
	CDOHSetPropertyForJSONKey(mirrorURL,				kCDOHRepositoryMirrorURLKey, dictionary);
	CDOHSetPropertyForJSONKey(repositoryHTMLURL,		kCDOHRepositoryHTMLURLKey, dictionary);
	CDOHSetPropertyForJSONKey(homepageURL,				kCDOHRepositoryHomepageURLKey, dictionary);
	CDOHSetPropertyForJSONKey(language,					kCDOHRepositoryLanguageKey, dictionary);
	CDOHSetPropertyForJSONKey(watchersCount,			kCDOHRepositoryWatchersKey, dictionary);
	CDOHSetPropertyForJSONKey(size,						kCDOHRepositorySizeKey, dictionary);
	CDOHSetPropertyForJSONKey(updatedAt,				kCDOHRepositoryUpdatedAtKey, dictionary);
	CDOHSetPropertyForJSONKey(pushedAt,					kCDOHRepositoryPushedAtKey, dictionary);
	CDOHSetPropertyForJSONKey(createdAt,				kCDOHRepositoryCreatedAtKey, dictionary);
	CDOHSetPropertyForJSONKey(defaultBranch,			kCDOHRepositoryDefaultBranchKey, dictionary);
	CDOHSetPropertyForJSONKey(openIssuesCount,			kCDOHRepositoryOpenIssuesKey, dictionary);
	CDOHSetPropertyForJSONKey(hasIssues,				kCDOHRepositoryHasIssuesKey, dictionary);
	CDOHSetPropertyForJSONKey(isFork,						kCDOHRepositoryForkKey, dictionary);
	CDOHSetPropertyForJSONKey(forksCount,				kCDOHRepositoryForksKey, dictionary);
	CDOHSetPropertyForJSONKey(parentRepository,			kCDOHRepositoryParentRepositoryKey, dictionary);
	CDOHSetPropertyForJSONKey(sourceRepository,			kCDOHRepositorySourceRepositoryKey, dictionary);
	CDOHSetPropertyForJSONKey(hasWiki,					kCDOHRepositoryHasWikiKey, dictionary);
	CDOHSetPropertyForJSONKey(hasDownloads,				kCDOHRepositoryHasDownloadsKey, dictionary);
}

+ (NSDictionary *)JSONKeyToPropertyName
{
	static NSDictionary *JSONKeyToPropertyName = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[CDOHRepository JSONKeyToPropertyNameDictionary:dictionary];
		JSONKeyToPropertyName = [dictionary copy];
	});
	return JSONKeyToPropertyName;
}



#pragma mark - Identifying and Comparing Repositories
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
	
	hash = prime * hash + [self.owner hash];
	hash = prime * hash + [self.name hash];
	hash = prime * hash + [self.organization hash];
	
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
