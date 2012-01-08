//
//  CDOHClient.h
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
#import <ObjectiveHub/CDOHResponsBlockTypes.h>


// TODO: Fix so that we can import all headers into this file.
// TODO: Break out the class ObjectiveHub to CDOHClient and just use this file to import all the public headers of the library.


#pragma mark Forward Class Declarations
@class CDOHUser, CDOHPlan, CDOHError, CDOHResponse;


#pragma mark - Constants
/// The default default items per page.
#define kCDOHDefaultItemsPerPage				0

/// The default rate limit of API requests, where zero (0) means automatic.
#define kCDOHDefaultRateLimit					0


NSString *const kCDOHResponseInfoNextPageKey;
NSString *const kCDOHResponseInfoLastPageKey;
NSString *const kCDOHResponseInfoRateLimitKey;
NSString *const kCDOHResponseInfoRateLimitRemainingKey;


#pragma mark - ObjectiveHub Interface
/**
 * Objective-C class for comunicating with GitHub asynchronously using blocks.
 *
 * Currently version 3 of the GitHub API is supported.
 *
 * **Blocks**
 *
 * - _Failure blocks_ takes exactly one argument, the error (CDOHError) which
 * was encounterred.
 * - _Success blocks_ takes exactly one argument, the response (CDOHResponse)
 * recieved from GitHub. The `resource` property models the resouce provided by
 * GitHub. More information is available through this object, such as if the
 * response is paginated and how many pages exists. The response object also
 * makes it easy to get more pages via its `-loadNextPage`, `-loadPreviousPage`
 * and `-loadPages:`.
 *
 * @TODO: We should only require a password when GitHub requires us to authenticate else we should not store it (so that we do not expose the user to unnecessary risks. That is, if the user of the library wants this and it is possible.
 */
@interface CDOHClient : NSObject

#pragma mark - Initializing ObjectiveHub
/** @name Initializing ObjectiveHub */
/**
 * Initializes and returns an `ObjectiveHub` instance that uses the default
 * settings.
 *
 * @warning *Important:* To get data which requires authentication you must set
 * the username and password properties after calling the init method.
 * Alternatively you can use the initialization method
 * initWithUsername:password: instead which will do it for you.
 *
 * @return An `ObjectiveHub` instance initialized with the default values.
 */
- (id)init;

/**
 * Initializes and returns an `ObjectiveHub` instance that uses the given
 * username and password for authentication with GitHub.
 *
 * @warning *Important:* The
 * [basic authentication](http://developer.github.com/v3/#authentication) method
 * is used as this is what GitHub recommend that desktop applications use.
 *
 * @param username The username used to authenticate with GitHub.
 * @param password The password used to authenticate with GitHub.
 * @return An `ObjectiveHub` instance initialized with the given username and 
 * password.
 */
- (id)initWithUsername:(NSString *)username password:(NSString *)password;


#pragma mark - User Credentials
/** @name User Credentials */
/**
 * The username used to authenticate with GitHub using
 * [basic authentication](http://developer.github.com/v3/#authentication).
 *
 * @see password
 */
@property (copy) NSString *username;

/**
 * The password used to authenticate with GitHub using
 * [basic authentication](http://developer.github.com/v3/#authentication).
 *
 * @see username
 */
@property (copy) NSString *password;


#pragma mark - Configuration Options
/** @name Configuration Options */
/**
 * The default items per page size for requests that return multiple items.
 *
 * The default is to let GitHub decide how many items per page should be
 * returned.
 *
 * @warning *Note* Valid range is between 0 to 100 (the upper limit is a
 * [restriction from GitHub](http://developer.github.com/v3/#pagination)).
 * Where 0 (zero) means that we will use GitHub’s default value.
 */
@property (assign) NSUInteger itemsPerPage;

/**
 * The API request rate limit.
 *
 * @warning *Note* setting the rate limit to zero (`0`) will make the framework
 * manage the rate limiting automatically.
 *
 * @todo Implement this.
 */
@property (assign) NSUInteger rateLimit;


#pragma mark - Getting and Modyfing Users
/** @name Getting and Updating Users */
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
 * @warning *Important:* This method requires the user to be authenticated.
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
 * @warning *Important:* This method requires the user to be authenticated.
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


#pragma mark - Getting and Modyfing User Emails
/** @name Getting and Modyfing Users */
/**
 * Get all email addresses of the currently authenticated user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @warning *Important* This method requires the user to be authenticated.
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
 * @warning *Important* This method requires the user to be authenticated.
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
 * @warning *Important* This method requires the user to be authenticated.
 *
 * @param emails An array of email addresses to delete from the currently
 * authenticated user.
 * @param successBlock The block which is called upon success. The parameter may
 * be set to `NULL` in which case nothing will be done upon success.
 * @param failureBlock The block which is called upon failure with the error
 * encountered. The parameter may be set to `NULL` in which case nothing will be
 * done upon failure.
 */
- (void)deleteUserEmails:(NSArray *)emails success:(CDOHNoResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Getting Watched and Watching Repositories
/** @name Getting Watched and Watching Repositories */
/**
 * Get all users watching a specific repository.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param repository The name of the repository.
 * @param owner The name of the owner of the given repository
 * _repositoryName_.
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
- (void)watchersOfRepository:(NSString *)repository owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get all repositories watched by a specific user.
 *
 * The success and failure blocks are both optional but if neither is given no
 * request will be performed.
 *
 * @param login The login of the user for which the array of watched
 * repositories should be fetched.
 * @param pages The pages to get. May be `nil`, in which case the first page
 * will be loaded.
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
- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


@end
