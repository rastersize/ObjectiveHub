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

#import <ObjectiveHub/_CDOHRepository.h>

#pragma mark GitHub JSON Keys
/// Repository dictionary key for the HTML URL.
extern NSString *const kCDOHRepositoryHTMLURLKey;
/// Repository dictionary key for the default clone URL.
extern NSString *const kCDOHRepositoryCloneURLKey;
/// Repository dictionary key for the git protocol URL.
extern NSString *const kCDOHRepositoryGitURLKey;
/// Repository dictionary key for the ssh protocol URL.
extern NSString *const kCDOHRepositorySSHURLKey;
/// Repository dictionary key for the svn protocol URL.
extern NSString *const kCDOHRepositorySVNURLKey;
/// Repository dictionary key for the repository mirror URL.
extern NSString *const kCDOHRepositoryMirrorURLKey;
/// Repository dictionary key for the repository unique identifier.
extern NSString *const kCDOHRepositoryIdentifierKey;
/// Repository dictionary key for the repository owner.
extern NSString *const kCDOHRepositoryOwnerKey;
/// Repository dictionary key for the name of the repository.
extern NSString *const kCDOHRepositoryNameKey;	
/// Repository dictionary key for the description of the repository.
extern NSString *const kCDOHRepositoryDescriptionKey;
/// Repository dictionary key for the homepage URL.
extern NSString *const kCDOHRepositoryHomepageKey;
/// Repository dictionary key for the primary language used in the repository.
extern NSString *const kCDOHRepositoryLanguageKey;
/// Repository dictionary key for wheter the repository is private or not.
extern NSString *const kCDOHRepositoryPrivateKey;
/// Repository dictionary key for the number of watchers of the repository.
extern NSString *const kCDOHRepositoryWatchersKey;
/// Repository dictionary key for the size of the repository.
extern NSString *const kCDOHRepositorySizeKey;
/// Repository dictionary key for the repository’s default branch.
extern NSString *const kCDOHRepositoryDefaultBranchKey;
/// Repository dictionary key for the number of open issues.
extern NSString *const kCDOHRepositoryOpenIssuesKey;
/// Repository dictionary key for whether the repository have issues enabled.
extern NSString *const kCDOHRepositoryHasIssuesKey;
/// Repository dictionary key for the date when the repository was updated.
extern NSString *const kCDOHRepositoryUpdatedAtKey;
/// Repository dictionary key for the date when the repository was pushed to.
extern NSString *const kCDOHRepositoryPushedAtKey;
/// Repository dictionary key for the date when the repository was created.
extern NSString *const kCDOHRepositoryCreatedAtKey;
/// Repository dictionary key for the organization the repository belongs to.
extern NSString *const kCDOHRepositoryOrganizationKey;
/// Repository dictionary key for whether the repository is a fork or not.
extern NSString *const kCDOHRepositoryForkKey;
/// Repository dictionary key for the number of forks of the repository.
extern NSString *const kCDOHRepositoryForksKey;
/// Repository dictionary key for the parent repository.
extern NSString *const kCDOHRepositoryParentRepositoryKey;
/// Repository dictionary key for the source repository.
extern NSString *const kCDOHRepositorySourceRepositoryKey;
/// Repository dictionary key for whether the repository has the wiki enabled
/// or not.
extern NSString *const kCDOHRepositoryHasWikiKey;
/// Repository dictionary key for whether the repository has downloads enabled
/// or not.
extern NSString *const kCDOHRepositoryHasDownloadsKey;
/// The team id that is granted access to the repository, given that the
/// repository belongs to an organization.
extern NSString *const kCDOHRepositoryTeamIDKey;


#pragma mark - Repository Language Dictionary Keys
/// The key for the name of the language in a repository language dictionary.
extern NSString *const kCDOHRepositoryLanguageNameKey;
/// The key for the number of characters of the language in a repository
/// language dictionary.
extern NSString *const kCDOHRepositoryLanguageCharactersKey;


#pragma mark - CDOHRepository Interface
/**
 *
 */
@interface CDOHRepository : _CDOHRepository

#pragma mark - Cloning URLs
/** @name Cloning URLs */
/**
 * Standard clone URL.
 */
@property (strong) NSURL *cloneURL;

/**
 * Clone URL for cloning over the git protocol.
 */
@property (strong) NSURL *gitURL;

/**
 * Clone URL for cloning over the SSH protocol.
 */
@property (strong) NSURL *sshURL;

/**
 * Clone URL for checkingout over the Subversion protocol.
 */
@property (strong) NSURL *svnURL;


#pragma mark - Repository Mirroring
/** @name Repository Mirroring */
/**
 * The URL of the original repository which this repository mirrors.
 */
@property (strong) NSURL *mirrorURL;


#pragma mark - Project URLs
/** @name Project URLs */
/**
 * The URL of the GitHub (HTML) repository page.
 */
@property (strong) NSURL *repositoryHTMLURL;

/**
 * The URL of the project homepage.
 */
@property (strong) NSURL *homepageURL;


#pragma mark - Formatted Name
/** @name Formatted Name */
/**
 * The formatted name of the repository (i.e. "owner_login/repo_name").
 *
 * @return A string containing the formatted repository name.
 */
- (NSString *)formattedName;

@end
