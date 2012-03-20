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
#import "CDOHAbstractUser.h"


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
NSString *const kCDOHRepositoryHomepageKey			= @"homepage";
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
NSString *const kCDOHRepositoryTeamIDKey			= @"team_id";


#pragma mark - Repository Language Dictionary Keys
NSString *const kCDOHRepositoryLanguageNameKey			= @"name";
NSString *const kCDOHRepositoryLanguageCharactersKey	= @"characters";


#pragma mark - CDOHRepository Implementation
@implementation CDOHRepository

#pragma mark - Cloning URLs
- (NSURL *)cloneURL
{
	return self.p_cloneURL;
}

- (void)setCloneURL:(NSURL *)cloneURL
{
	self.p_cloneURL = cloneURL;
}

- (NSURL *)gitURL
{
	return self.p_gitURL;
}

- (void)setGitURL:(NSURL *)gitURL
{
	self.p_gitURL = gitURL;
}

- (NSURL *)sshURL
{
	return self.p_sshURL;
}

- (void)setSshURL:(NSURL *)sshURL
{
	self.p_sshURL = sshURL;
}

- (NSURL *)svnURL
{
	return self.p_svnURL;
}

- (void)setSvnURL:(NSURL *)svnURL
{
	self.p_svnURL = svnURL;
}


#pragma mark - Repository Mirroring
- (NSURL *)mirrorURL
{
	return self.p_mirrorURL;
}

- (void)setMirrorURL:(NSURL *)mirrorURL
{
	self.p_mirrorURL = mirrorURL;
}


#pragma mark - Project URLs
- (NSURL *)repositoryHTMLURL
{
	return self.p_repositoryHTMLURL;
}

- (void)setRepositoryHTMLURL:(NSURL *)repositoryHTMLURL
{
	self.p_repositoryHTMLURL = repositoryHTMLURL;
}

- (NSURL *)homepageURL
{
	return self.p_homepageURL;
}

- (void)setHomepageURL:(NSURL *)homepageURL
{
	self.p_homepageURL = homepageURL;
}


#pragma mark - Formatted Name
- (NSString *)formattedName
{
	return [NSString stringWithFormat:@"%@/%@", self.owner.login, self.name];
}

@end
