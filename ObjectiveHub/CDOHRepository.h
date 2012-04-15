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

#import <ObjectiveHub/CDOHResource.h>


#pragma mark Forward Class Declaration
@class CDOHUser;


#pragma mark - JSON Dictionary Keys For Updating and Creating Repositories
/// Repository dictionary key for the name of the repository.
extern NSString *const kCDOHRepositoryNameKey;
/// Repository dictionary key for the description of the repository.
extern NSString *const kCDOHRepositoryDescriptionKey;
/// Repository dictionary key for the homepage URL.
extern NSString *const kCDOHRepositoryHomepageURLKey;
/// Repository dictionary key for wheter the repository is private or not.
extern NSString *const kCDOHRepositoryPrivateKey;
/// Repository dictionary key for whether the repository have issues enabled.
extern NSString *const kCDOHRepositoryHasIssuesKey;
/// Repository dictionary key for whether the repository has the wiki enabled
/// or not.
extern NSString *const kCDOHRepositoryHasWikiKey;
/// Repository dictionary key for whether the repository has downloads enabled
/// or not.
extern NSString *const kCDOHRepositoryHasDownloadsKey;
/// The team id that is granted access to the repository, given that the
/// repository belongs to an organization.
extern NSString *const kCDOHRepositoryTeamIdentifierKey;


#pragma mark - Repository Language Dictionary Keys
/// The key for the name of the language in a repository language dictionary.
extern NSString *const kCDOHRepositoryLanguageNameKey;
/// The key for the number of characters of the language in a repository
/// language dictionary.
extern NSString *const kCDOHRepositoryLanguageCharactersKey;


#pragma mark - Repository User Permission
enum _CDOHRepositoryPermission {
	///
	kCDOHRepositoryPermissionAdmin			= (1 << 0),
	/// 
	kCDOHRepositoryPermissionPull			= (1 << 1),
	/// 
	kCDOHRepositoryPermissionPush			= (1 << 2),
};
///
typedef NSInteger CDOHRepositoryPermission;


#pragma mark - CDOHRepository Interface
/**
 * A repository.
 */
@interface CDOHRepository : CDOHResource

#pragma mark - General Information
/** @name General Information */
/**
 * The unique identifier of the repository.
 */
@property (assign, readonly) NSUInteger identifier;

/**
 * Whether the repository is private or not.
 */
@property (assign, readonly, getter = isPrivate) BOOL private;

/**
 * The owner of the repository.
 *
 * @see CDOHUser
 */
@property (strong, readonly) CDOHUser *owner;

/**
 * The organization which the repository belongs to.
 *
 * Will be `nil` if no organization owns the repository.
 *
 * @see CDOHUser
 */
@property (strong, readonly) CDOHUser *organization;

/**
 * The name of the repository.
 */
@property (copy, readonly) NSString *name;

/**
 * The repository description.
 */
@property (copy, readonly) NSString *repositoryDescription;


#pragma mark - Formatted Name
/** @name Formatted Name */
/**
 * The formatted name of the repository (i.e. "owner_login/repo_name").
 *
 * @return A string containing the formatted repository name.
 */
@property (copy, readonly) NSString *formattedName;


#pragma mark - Cloning URLs
/** @name Cloning URLs */
/**
 * Standard clone URL.
 */
@property (strong, readonly) NSURL *cloneURL;

/**
 * Clone URL for cloning over the git protocol.
 */
@property (strong, readonly) NSURL *gitURL;

/**
 * Clone URL for cloning over the SSH protocol.
 */
@property (strong, readonly) NSURL *sshURL;

/**
 * Clone URL for checkingout over the Subversion protocol.
 */
@property (strong, readonly) NSURL *svnURL;


#pragma mark - Repository Mirroring
/** @name Repository Mirroring */
/**
 * The URL of the original repository which this repository mirrors.
 */
@property (strong, readonly) NSURL *mirrorURL;


#pragma mark - Project URLs
/** @name Project URLs */
/**
 * The URL of the GitHub (HTML) repository page.
 */
@property (strong, readonly) NSURL *repositoryHTMLURL;

/**
 * The URL of the project homepage.
 */
@property (strong, readonly) NSURL *homepageURL;


#pragma mark - Meta Information
/** @name Meta Information */
/**
 * The primary language used in the project.
 */
@property (strong, readonly) NSString *language;

/**
 * The number of watchers of the project.
 */
@property (assign, readonly) NSUInteger watchersCount;

/**
 * The total size of the project in bytes.
 */
@property (assign, readonly) NSUInteger size;

/**
 * The date and time of the latest push to the repository.
 */
@property (strong, readonly) NSDate *updatedAt;

/**
 * The date and time of the latest push to the repository.
 */
@property (strong, readonly) NSDate *pushedAt;

/**
 * The date and time when the repository was created.
 */
@property (strong, readonly) NSDate *createdAt;


#pragma mark - User Permissions
/** @name User Permissions */
/**
 * The permissions the authenticated user have on the repository.
 *
 * @see CDOHRepositoryPermission
 */
@property (assign, readonly) CDOHRepositoryPermission permissions;

/**
 * Returns whether the authenticated user have permission to administrate the
 * repository.
 */
@property (assign, readonly) BOOL hasAdminPermission;

/**
 * Returns whether the authenticated user have permission to push to the
 * repository. 
 */
@property (assign, readonly) BOOL hasPushPermission;

/**
 * Returns whether the authenticated user have permission to pull from the
 * repository.
 */
@property (assign, readonly) BOOL hasPullPermission;


#pragma mark - Branches
/** @name Branches */
/**
 * The master branch of the repository.
 */
@property (copy, readonly) NSString *defaultBranch;


#pragma mark - Issues
/** @name Issues */
/**
 * The total number of open issues.
 */
@property (assign, readonly) NSUInteger openIssuesCount;
/**
 * Whether the repository have issues enabled or not.
 */
@property (assign, readonly) BOOL hasIssues;


#pragma mark - Fork Information
/**
 * Whether the repository is a fork or not.
 */
@property (assign, readonly, getter = isFork) BOOL fork;

/**
 * Total number of forks.
 */
@property (assign, readonly) NSUInteger forksCount;

/**
 * The parent repository.
 *
 * Will be `nil` if repository is not a fork, i.e. fork returns `NO`.
 *
 * @see parentRepository
 * @see fork
 */
@property (strong, readonly) CDOHRepository *parentRepository;

/**
 * The source repository.
 *
 * The source repository is the repository this repository, all its sibling
 * forks and parent repository originate from. Will be `nil` if fork returns
 * `NO`, i.e. this is the source repository.
 *
 * @see parentRepository
 * @see fork
 */
@property (strong, readonly) CDOHRepository *sourceRepository;


#pragma mark - Wiki
/** @name Wiki */
/**
 * Whether the repository have the wiki enabled.
 */
@property (assign, readonly) BOOL hasWiki;


#pragma mark - Downloads
/** @name Downloads */
/**
 * Whether the repository have downloads enabled.
 */
@property (assign, readonly) BOOL hasDownloads;


#pragma mark - Identifying and Comparing Repositories
/** @name Identifying and Comparing Repositories */
/**
 * Returns a Boolean value that indicates whether a given repository is equal to
 * the receiver.
 *
 * The receiver and _aRepository_ is determined to be equal if their identifiers
 * are equal.
 *
 * @param aRepository The repository with which to compare the reciever.
 * @return `YES` if _aRepository_ is equivalent to the reciever, otherwise `NO`.
 */
- (BOOL)isEqualToRepository:(CDOHRepository *)aRepository;

@end
