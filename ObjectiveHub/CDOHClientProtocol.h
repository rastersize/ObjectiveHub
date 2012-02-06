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
 * GitHub. Please see the concrete class CDOHClient, which implement this
 * protocol, for details on how to to interact with GitHub.
 *
 * One example use of this protocol is if you have a proxy class infront of the
 * "real" `CDOHClient` instance you can have that proxy class conform to this
 * protocol. That way the compiler will not complain that your class might not
 * implement some method.
 */
@protocol CDOHClientProtocol <NSObject>
@required

#pragma mark - Users
/** @name Users */
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
- (void)userWithLogin:(NSString *)login success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get information about the currently authenticated user.
 *
 * If either one of the properties username or password is not set the failure
 * block will be called immediately.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
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
 * @see userWithLogin:success:failure:
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)user:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Update the currently authenticated user with the contents of the given
 * dictionary.
 *
 * Each of the available keys are optional and if omitted the value will not be
 * changed. The possible actions that can be performed as well as the
 * corresponding key and value type is listed in the table below.
 *
 * <table>
 *   <tr>
 *     <th></th>
 *     <th style="text-align: left">Dictionary Key</th>
 *     <th style="text-align: left">Value Type</th>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change name:</th>
 *     <td><code>kCDOHUserDictionaryNameKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th  style="text-align: right">Change email address:</th>
 *     <td><code>kCDOHUserDictionaryEmailKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change blog URL:</th>
 *     <td><code>kCDOHUserDictionaryBlogKey</code></td>
 *     <td><code>NSURL</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change company name:</th>
 *     <td><code>kCDOHUserDictionaryCompanyKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change location string:</th>
 *     <td><code>kCDOHUserDictionaryLocationKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change hireable status:</th>
 *     <td><code>kCDOHUserDictionaryHireableKey</code></td>
 *     <td>Boolean inside a <code>NSNumber</code></td>
 *   </tr>
 *   <tr>
 *     <th style="text-align: right">Change biography text:</th>
 *     <td><code>kCDOHUserDictionaryBioKey</code></td>
 *     <td><code>NSString</code></td>
 *   </tr>
 * </table>
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
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
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - User Emails
/** @name User Emails */
/**
 * Get all email addresses of the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
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
 * @see CDOHResponse
 */
- (void)userEmails:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Add new email addresses of the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
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
 * @see CDOHResponse
 */
- (void)addUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Delete the given email addresses from the currently authenticated user.
 *
 * The success and failure blocks are both optional and the task **will** be
 * carried out even if you set both to `NULL`.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 *
 * @param emails An array of email addresses to delete from the currently
 * authenticated user.
 * @param successBlock The block which is called upon success. The parameter may
 * be set to `NULL` in which case nothing will be done upon success. The
 * response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)deleteUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Repositories
/** @name Repositories */
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
 *
 * @exception NSInvalidArgumentException if _repository_ or _owner_ is `nil`.
 */
- (void)repository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories of the authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning **Important:** This method requires the user to be authenticated.
 *
 * @param type The type of repositories which should returned. See the
 * constants with the prefix `kCDOHRepositoriesType*` for possible values.
 * @param pages An array of an unsigned integers wrapped with a NSNumber for
 * each page of the resource that should be loaded. May be `nil` in which case
 * the first page will be loaded.
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
 * @exception NSInvalidArgumentException if _type_ is `nil`.
 * @exception NSInternalInconsistencyException if the `username` of the
 * authenticated user has not been set.
 *
 * @see CDOHResponse
 * @see CDOHRepository
 * @see CDOHRepositoriesType
 */
- (void)repositories:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

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
 * @param pages An array of an unsigned integers wrapped with a NSNumber for
 * each page of the resource that should be loaded. May be `nil` in which case
 * the first page will be loaded.
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
 * @exception NSInvalidArgumentException if _login_ or _type_ are `nil`.
 *
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

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
 * @param pages An array of an unsigned integers wrapped with a NSNumber for
 * each page of the resource that should be loaded. May be `nil` in which case
 * the first page will be loaded.
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
 * @exception NSInvalidArgumentException if _login_ or _type_ are `nil`.
 *
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Watched and Watching Repositories
/** @name Watched and Watching Repositories */
/**
 * Get all users watching a specific repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param pages An array of an unsigned integers wrapped with a NSNumber for
 * each page of the resource that should be loaded. May be `nil` in which case
 * the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHUser` objects representing all the watchers of the given repository
 * (for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see CDOHResponse
 * @see CDOHUser
 */
- (void)watchersOfRepository:(NSString *)repository owner:(NSString *)owner pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories watched by a specific user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the user for which the array of watched
 * repositories should be fetched.
 * @param pages An array of an unsigned integers wrapped with a NSNumber for
 * each page of the resource that should be loaded. May be `nil` in which case
 * the first page will be loaded.
 * @param successBlock The block which is called upon success with a
 * (CDOHResponse) response object. The parameter may be set to `NULL` in which
 * case nothing will be done upon success.
 *
 * The `resource` property of the response will be set to a `NSArray` of
 * `CDOHRepository` objects representing all the repositories watched by the
 * given user (for one page).
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 *
 * @see CDOHResponse
 * @see CDOHRepository
 */
- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Check whether the currently authenticated user is watching the given
 * repository owned by the given owner.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the user is watching the
 * given repository. The response object **will** be `nil`.
 * @param failureBlock The block which is called if the user is not watching the
 * given repository. In which case the error code will be
 * set to `kCDOHErrorCodeNotFound`. The block will also be called for other
 * types of errors. The parameter may be set to `NULL` in which case nothing
 * will be done upon failure.
 */
- (void)isUserWatchingRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Watch a repository using the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the user is watching the
 * given repository. The response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)watchRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Stop watching a repository using the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 * 
 * @warning **Important:** This method requires the user to be authenticated.
 *
 * @param repository The name of the repository.
 * @param owner The login of the owner of the given _repository_.
 * @param successBlock The block which is called if the request to stop watching
 * the specified repository succeeded. The response object **will** be `nil`.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)stopWatchingRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


@end
