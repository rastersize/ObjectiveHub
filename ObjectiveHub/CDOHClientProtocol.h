//
//  CDOHClientProtocol.h
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

#import <Foundation/Foundation.h>

#import <ObjectiveHub/CDOHTypes.h>


#pragma mark CDOHClientProtocol Protocol
/**
 * The `CDOHClientProtocol` defines the methods which are used to interact with
 * GitHub. You use a concrete class such as `CDOHClient`, which implement this
 * protocol, when actually interacting with GitHub this protocol merly specifies
 * how you use the concrete class.
 *
 * One example use of this protocol is if you have a proxy class infront of the
 * "real" `CDOHClient` instance you can have that proxy class conform to this
 * protocol. That way the compiler will not complain about your proxy class not
 * implementing certain methods.
 */
@protocol CDOHClientProtocol <NSObject>
@required

#pragma mark - User Authentication and Credentials
/** @name User Authentication and Credentials */
/**
 * Validate the given _login_ together with the given _password_.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the user.
 * @param password The password for the given _login_ of the user.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHUser` object
 * representing the user with the given login.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)validateLogin:(NSString *)login password:(NSString *)password success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

#pragma mark - Managing Users
/** @name Managing Users */
/**
 * Get information about a single specific user by their login.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the sought user.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHUser` object
 * representing the user with the given login.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see user:failure:
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)userWithLogin:(NSString *)login success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get information about the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHUser` object
 * representing the authenticated user.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see userWithLogin:success:failure:
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)user:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Update the currently authenticated user with the contents of the given
 * dictionary.
 *
 * In case the dictionary is empty or `nil` is passed to the method, it will
 * return immidiately without performing anything.
 *
 * Each of the available keys are optional and if omitted the value will not be
 * changed. The possible actions that can be performed as well as the
 * corresponding key and value type is listed in the table below.
 *
 * <table>
 *   <tr>
 *     <th></th>
 *     <th style="text-align: left">Dictionary Key Constant</th>
 *     <th style="text-align: left">Value Type</th>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change name:</th>
 *     <td><code>kCDOHUserNameKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th  style="text-align: right">Change email address:</th>
 *     <td><code>kCDOHUserEmailKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change blog URL:</th>
 *     <td><code>kCDOHUserBlogURLKey</code></td>
 *     <td><code>NSURL</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change company name:</th>
 *     <td><code>kCDOHUserCompanyKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change location string:</th>
 *     <td><code>kCDOHUserLocationKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change hireable status:</th>
 *     <td><code>kCDOHUserHireableKey</code></td>
 *     <td>Boolean inside a <code>NSNumber</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change biography text:</th>
 *     <td><code>kCDOHUserBiographyKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 * </table>
 *
 * If the dictionary contains any other key-value pairs they will be removed and
 * as such not sent to GitHub.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param dictionary A dictionary containing values for the pre-defined keys.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHUser` object
 * representing the authenticated user with updated values.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - User Emails
/** @name User Emails */
/**
 * Get all email addresses of the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray`
 * containing all the email addresses associated with the authenticated user.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see addUserEmails:success:failure:
 * @see deleteUserEmails:success:failure:
 * @see CDOHResponse
 */
- (void)userEmails:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Add new email addresses of the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param emails An array of email addresses to add to the currently
 * authenticated user.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray`
 * containing all the email addresses associated with the authenticated user.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see userEmails:failure:
 * @see deleteUserEmails:success:failure:
 * @see CDOHResponse
 */
- (void)addUserEmails:(NSArray *)emails success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Delete the given email addresses from the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param emails An array of email addresses to delete from the currently
 * authenticated user.
 * @param successBlock The block which is called upon success. The parameter may
 * be set to `NULL` in which case nothing will be done upon success. The
 * response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see userEmails:failure:
 * @see addUserEmails:success:failure:
 */
- (void)deleteUserEmails:(NSArray *)emails success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Managing Repositories
/** @name Managing Repositories */
/**
 * Get the repository for the given _owner_ login and _repository_ name.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed. Also please note that the result is not paginated.
 *
 * @param repository The name of the repository.
 * @param owner The name of the owner of the given _repository_.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success. The respone is not paginated.
 *
 * The `resource` property of the response will be set to a `CDOHRepository`
 * object representing the requested repository.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)repository:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Create a new repository for the authenticated user with the given _name_.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * The following table details the available keys, the expected type and
 * additional comments. All options are optional, only the name is required.
 *
 * <table>
 *   <tr>
 *     <th></th>
 *     <th style="text-align: left">Dictionary Key Constant</th>
 *     <th style="text-align: left">Value Type</th>
 *     <th style="text-align: left">Comments</th>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Description:</th>
 *     <td><code>kCDOHRepositoryDescriptionKey</code></td>
 *     <td><code>NSString</code></td>
 *     <td>Default is no description.</td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Homepage URL:</th>
 *     <td><code>kCDOHRepositoryHomepageURLKey</code></td>
 *     <td><code>NSURL</code></td>
 *     <td>Default is no homepage URL.</td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Private:</th>
 *     <td><code>kCDOHRepositoryPrivateKey</code></td>
 *     <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to create a private repository, <code>NO</code> to
 *       create a public one. Creating private repositories requires a paid
 *       GitHub account. Default is <code>NO</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has issues enabled:</th>
 *     <td><code>kCDOHRepositoryHasIssuesKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable issues for this repository, <code>NO</code>
 *       to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has wiki enabled:</th>
 *     <td><code>kCDOHRepositoryHasWikiKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable the wiki for this repository,
 *       <code>NO</code> to disable it. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has downloads enabled:</th>
 *     <td><code>kCDOHRepositoryHasDownloadsKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable downloads for this repository,
 *       <code>NO</code> to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 * </table>
 *
 * If the dictionary contains any other key-value pairs they will be removed and
 * as such not sent to GitHub.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param name The name of the to be created repository.
 * @param dictionary A dictionary containing all the options for the repository.
 * May be `nil` in which case the GitHubs default values will be used.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success. The respone is not paginated.
 *
 * The `resource` property of the response will be set to a `CDOHRepository`
 * object representing the newly created repository.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see repository:owner:success:failure:
 * @see deleteRepository:owner:success:failure:
 * @see createRepository:inOrganization:dictionary:success:failure:
 */
- (void)createRepository:(NSString *)name dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Create a new repository for the given organization with the given _name_.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * The following table details the available keys, the expected type and
 * additional comments. All options are optional, only the name is required.
 *
 * <table>
 *   <tr>
 *     <th></th>
 *     <th style="text-align: left">Dictionary Key Constant</th>
 *     <th style="text-align: left">Value Type</th>
 *     <th style="text-align: left">Comments</th>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Description:</th>
 *     <td><code>kCDOHRepositoryDescriptionKey</code></td>
 *     <td><code>NSString</code></td>
 *     <td>Default is no description.</td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Homepage URL:</th>
 *     <td><code>kCDOHRepositoryHomepageKey</code></td>
 *     <td><code>NSURL</code></td>
 *     <td>Default is no homepage URL.</td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Private:</th>
 *     <td><code>kCDOHRepositoryPrivateKey</code></td>
 *     <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to create a private repository, <code>NO</code> to
 *       create a public one. Creating private repositories requires a paid
 *       GitHub account. Default is <code>NO</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has issues enabled:</th>
 *     <td><code>kCDOHRepositoryHasIssuesKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable issues for this repository, <code>NO</code>
 *       to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has wiki enabled:</th>
 *     <td><code>kCDOHRepositoryHasWikiKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable the wiki for this repository,
 *       <code>NO</code> to disable it. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has downloads enabled:</th>
 *     <td><code>kCDOHRepositoryHasDownloadsKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable downloads for this repository,
 *       <code>NO</code> to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Team:</th>
 *     <td><code>kCDOHRepositoryHasDownloadsKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable downloads for this repository,
 *       <code>NO</code> to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 * </table>
 *
 * If the dictionary contains any other key-value pairs they will be removed and
 * as such not sent to GitHub.
 *
 * @warning **Important:** This method requires the user to be authenticated and
 * a member of the given _organization_. If no authenticated user has been set
 * the failure block will be will immediately executed and the method will
 * return. If no failure block has been supplied an
 * `NSInternalInconsistencyException` exception will be raised.
 *
 * @param name The name of the to be created repository.
 * @param organization The name of the organization the repository should
 * associated with.
 * @param dictionary A dictionary containing all the options for the repository.
 * May be `nil` in which case the GitHubs default values will be used.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success. The respone is not paginated.
 *
 * The `resource` property of the response will be set to a `CDOHRepository`
 * object representing the newly created repository.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see repository:owner:success:failure:
 * @see deleteRepository:owner:success:failure:
 * @see createRepository:inOrganization:dictionary:success:failure:
 */
- (void)createRepository:(NSString *)name inOrganization:(NSString *)organization dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Update the given _repository_ owned by the given _owner_ with the values of
 * the given _dictionary_.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * In case the _dictionary_ is empty or `nil` is passed to the method, it will
 * return immidiately without performing anything.
 *
 * Each of the available keys are optional and if omitted the value will not be
 * changed. The possible actions that can be performed as well as the
 * corresponding key and value type is listed in the table below.
 *
 * <table>
 *   <tr>
 *     <th></th>
 *     <th style="text-align: left">Dictionary Key Constant</th>
 *     <th style="text-align: left">Value Type</th>
 *     <th style="text-align: left">Comments</th>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Name:</th>
 *     <td><code>kCDOHRepositoryNameKey</code></td>
 *     <td><code>NSString</code></td>
 *     <td>
 *       If not set the value of the _repository_ parameter will be used. Since
 *       the parameter is required by GitHub.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Description:</th>
 *     <td><code>kCDOHRepositoryDescriptionKey</code></td>
 *     <td><code>NSString</code></td>
 *     <td></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Homepage URL:</th>
 *     <td><code>kCDOHRepositoryHomepageKey</code></td>
 *     <td><code>NSURL</code></td>
 *     <td></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Private:</th>
 *     <td><code>kCDOHRepositoryPrivateKey</code></td>
 *     <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> makes the repository private, and <code>NO</code>
 *       makes it public.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has issues enabled:</th>
 *     <td><code>kCDOHRepositoryHasIssuesKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable issues for the repository, <code>NO</code>
 *       to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has wiki enabled:</th>
 *     <td><code>kCDOHRepositoryHasWikiKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable the wiki for the repository,
 *       <code>NO</code> to disable it. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Has downloads enabled:</th>
 *     <td><code>kCDOHRepositoryHasDownloadsKey</code></td>
 *      <td>Boolean inside a <code>NSNumber</code></td>
 *     <td>
 *       <code>YES</code> to enable downloads for the repository,
 *       <code>NO</code> to disable them. Default is <code>YES</code>.
 *     </td>
 *   </tr>
 * </table>
 *
 * If the dictionary contains any other key-value pairs they will be removed and
 * as such not sent to GitHub.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param repository The name of the repository that should be updated.
 * @param owner The login of the owner of the given _repository_ that should be
 * updated.
 * @param dictionary A dictionary containing all the options for the repository.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHRepository`
 * object representing the updated repository.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 */
- (void)updateRepository:(NSString *)repository owner:(NSString *)owner dictionary:(NSDictionary *)dictionary success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories of the authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param type The type of repositories which should returned. See the
 * constants with the prefix `kCDOHRepositoriesType*` for possible values.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all repositories for the authenticated
 * user (taking into account the given _type_ of repositories requested, for
 * one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see repositoriesForUser:type:pages:success:failure:
 * @see repositoriesForOrganization:type:pages:success:failure:
 * @see [CDOHClient username]
 * @see [CDOHClient password]
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositories:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all public repositories of the user with the given _login_.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the user.
 * @param type The type of repositories which should returned. See the
 * constants with the prefix `kCDOHRepositoriesType*` for possible values.
 * Since we can only get public information for non-authenticated users the
 * `kCDOHRepositoriesTypePrivate` will not yeild any successful result.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all repositories of the user (taking
 * into account the given _type_ of repositories requested, for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see repositories:pages:success:failure:
 * @see repositoriesForOrganization:type:pages:success:failure:
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories of the given _organization_.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param organization The name of the organization.
 * @param type The type of repositories which should returned. See the
 * constants with the prefix `kCDOHRepositoriesType*` for possible values. Some
 * types might require the authenticated user to be a member of the organization
 * or have access to specific repositories in the organization.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all repositories of the organization
 * (taking into account the given _type_ of repositories requested, for one
 * page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see repositories:pages:success:failure:
 * @see repositoriesForUser:type:pages:success:failure:
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all contributors (exluding anonymous contributors) of the given
 * repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHUser` objects representing all the contributors of the given repository.
 * The response is not paginated.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see repositoryContributors:owner:anonymous:pages:success:failure:
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)repositoryContributors:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all contributors of the given repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param anonymous `YES` to include anonymous contributors, `NO` to exlude
 * anonymous contributors from the result.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHUser` objects representing all the contributors of the given repository.
 * The response is not paginated.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see repositoryContributors:owner:pages:success:failure:
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)repositoryContributors:(NSString *)repository owner:(NSString *)owner anonymous:(BOOL)anonymous success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all languages used in the repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `NSDictionary` objects representing a language
 * (`kCDOHRepositoryLanguageNameKey`) and the number of characters
 * (`kCDOHRepositoryLanguageCharactersKey`) in that language.
 * The response is not paginated.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see CDOHResponse
 */
- (void)repositoryLanguages:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Starred Repositories
/** @name Starred Repositories */
/**
 * Get all users which have starred the given _repository_ owned by _owner_.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHUser` objects representing all the user who have starred the given
 * repository (for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)repositoryStargazers:(NSString *)repository owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories starred by a specific user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the user for which the array of watched
 * repositories should be fetched.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all the repositories starred by the
 * given user (for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see repositoriesWatchedForPages:success:failure:
 * @see CDOHRepository
 */
- (void)repositoriesStarredByUser:(NSString *)login pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories starred by the authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (`CDOHResponse`) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `[CDOHResponse resource]` property of the response will be set to an
 * `NSArray` object containing one `CDOHRespository` object per starred
 * repository, up to the maximum items per page.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. May be `NULL` in which case nothing will be done upon failure.
 *
 * @exception NSInternalInconsistencyException If no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see repositoriesWatchedByUser:pages:success:failure:
 * @see CDOHRepository
 */
- (void)repositoriesStarredForPages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Check whether the currently authenticated user has starred the given
 * _repository_ owned by the given _owner_.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the user has starred the
 * given repository. The response object **will** be `nil`.
 * @param failureBlock The block which is called if the user is not watching the
 * given repository. In which case the error code will be
 * set to `kCDOHErrorCodeNotFound`. The block will also be called for other
 * types of errors. The parameter may be set to `NULL` in which case nothing
 * will be done upon failure.
 *
 * @exception NSInternalInconsistencyException if no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see [CDOHClient username]
 * @see [CDOHClient password]
 */
- (void)hasUserStarredRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Star a repository for the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the all went OK and the user
 * now has starred the given repository. The response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException if no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see [CDOHClient username]
 * @see [CDOHClient password]
 */
- (void)starRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Unstar a repository for the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the request to unstar the
 * specified repository succeeded. The response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException if no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see [CDOHClient username]
 * @see [CDOHClient password]
 */
- (void)unstarRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Repository Forks
/** @name Repository Forks */
/**
 * Get all forks of a given repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param pages A set of indexes representing the pages which should be loaded.
 * May be `nil` in which case the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all the forks of the given repositories
 * (for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see forkRepository:owner:success:failure:
 */
- (void)repositoryForks:(NSString *)repository owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Create a new fork of the given repository.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 * If no authenticated user has been set the failure block will be will
 * immediately executed and the method will return. If no failure block has been
 * supplied an `NSInternalInconsistencyException` exception will be raised.
 *
 * @param repository The name of the repository that should be forked.
 * @param owner The login of the owner of the given _repository_ that should be
 * forked.
 * @param intoOrganization The organization the repository should be forked
 * into. May be `nil` or an empty string in which case the fork will be created
 * for the authenticated user. 
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `CDOHRepository`
 * object representing the newly created fork of the given repository.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @exception NSInternalInconsistencyException if no authenticated user has been
 * set **and** no failure block has been given.
 *
 * @see repositoryForks:owner:pages:success:failure:
 */
- (void)forkRepository:(NSString *)repository owner:(NSString *)owner intoOrganization:(NSString *)intoOrganization success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


@end
