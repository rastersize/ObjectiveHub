//
//  CDOHRepository.h
//  ObjectiveHub
//
//  Copyright 2011 Aron Cedercrantz. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "CDOHResource.h"


@class CDOHUser;
@class CDOHOrganization;


#pragma mark - CDOHRepository Interface
/**
 * An immutable class containing information about a single GitHub repository.
 */
@interface CDOHRepository : CDOHResource

- (id)initWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Repository URLs
/** @name Repository URLs */
/**
 * The URL to the GitHub repository HTML page.
 */
@property (strong, readonly) NSURL *HTMLURL;

/**
 * The URL which to clone the repository with.
 */
@property (strong, readonly) NSURL *cloneURL;

/**
 * The `git:` URL to the project.
 */
@property (strong, readonly) NSURL *gitURL;

/**
 * The SSH URL to the project.
 *
 * @warning Only available if the user has permission to push to the repository.
 */
@property (strong, readonly) NSURL *SSHURL;

/**
 * The Subversion (SVN) URL to the project.
 */
@property (strong, readonly) NSURL *svnURL;


#pragma mark - General Information
/** @name General Information */
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
 * @see CDOHOrganization
 */
@property (strong, readonly) CDOHOrganization *organization;

/**
 * The name of the repository.
 */
@property (copy, readonly) NSString *name;

/**
 * The repository description.
 */
@property (copy, readonly) NSString *description;

/**
 * The homepage of the repository.
 *
 * @warning This is the homepage given by the owner of the repository, that is
 * not the URL to the GitHub repository (i.e. https://github.com/_owner_/_name_
 * ). If what you want is the latter please see HTMLURL instead.
 *
 * @see HTMLURL
 */
@property (strong, readonly) NSURL *homepage;

/**
 * Whether the repository is private or not.
 */
@property (assign, readonly, getter = isPrivate) BOOL private;


#pragma mark - Statistics
/** @name Statistics */
/**
 * The languages used in the project.
 */
@property (strong, readonly) NSArray *languages;

/**
 * The number of watchers of the project.
 */
@property (assign, readonly) NSUInteger watchers;

/**
 * The total size of the project in bytes.
 */
@property (assign, readonly) NSUInteger size;

/**
 * The date and time of the latest push to the repository.
 */
@property (strong, readonly) NSDate *pushedAt;

/**
 * The date and time when the repository was created.
 */
@property (strong, readonly) NSDate *createdAt;


#pragma mark - Branches
/** @name Branches */
/**
 * The master branch of the repository.
 */
@property (copy, readonly) NSString *masterBranch;


#pragma mark - Issues
/** @name Issues */
/**
 * The total number of open issues.
 */
@property (assign, readonly) NSUInteger openIssues;
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


@end
