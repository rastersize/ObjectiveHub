//
//  CDOHClient.h
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
#import <ObjectiveHub/CDOHClientProtocol.h>


#pragma mark Constants
/// The default default items per page.
#define kCDOHDefaultItemsPerPage			0


#pragma mark - ObjectiveHub Interface
/**
 * Objective-C class for comunicating with GitHub asynchronously using blocks.
 * Besides this class you will probably be very interested in the
 * CDOHClientProtocol protcol which defins all methods used to interact with
 * GitHub.
 *
 * Currently **version 3** of the GitHub API is supported.
 *
 * ### Blocks ###
 *
 * The library use two types of blocks, failure and success blocks. These blocks
 * will be called as described below on a background thread. As such you should
 * take care when updating GUI elements from within such a block. Remember to
 * always update the GUI on the main thread only (as AppKit and UIKit aren’t
 * thread-safe).
 *
 * - **_Failure blocks_** takes exactly one argument, the error (CDOHError) which
 * was encounterred during the request.
 * - **_Success blocks_** takes exactly one argument, the response (CDOHResponse)
 * recieved from GitHub. The `resource` property models the resouce provided by
 * GitHub. More information is available through this object, such as if the
 * response is paginated and how many pages exists. The response object also
 * makes it easy to get more pages via its `-loadNextPage`, `-loadPreviousPage`
 * and `-loadPages:`.
 *
 *
 * ### Example Usage ###
 *
 *	#import <ObjectiveHub/ObjectiveHub.h>
 *	...
 *	
 *	- (void)loadData {
 *		NSString *username = ...
 *		CDOHClient *client = [[CDOHClient alloc] init];
 *		
 *		[client repositoriesWatchedByUser:username pages:nil success:^(CDOHResponse *response) {
 *			// Handle the response (you will probably want to do something
 *			// smarter than the row below).
 *			[self.watchedRepos addObjectsFromArray:response.resource];
 *			
 *			// Make sure we load all repositories watched by the user. The
 *			// success and failure blocks used in the first request will be re-
 *			// used. Just take care if the user is watching thousands of
 *			// repositories.
 *			if (response.hasNextPage) {
 *				[response loadNextPage];
 *			}
 *		} failure:^(CDOHError *error) {
 *			// Present the error or even better try to fix it for the user.
 *			[self presentError:error];
 *		}];
 *	}
 *
 * @TODO: We should only require a password when GitHub requires us to authenticate else we should not store it (so that we do not expose the user to unnecessary risks. That is, if the user of the library wants this and it is possible.
 */
@interface CDOHClient : NSObject <CDOHClientProtocol>

#pragma mark - Initializing ObjectiveHub
/** @name Initializing ObjectiveHub */
/**
 * Initializes and returns an `ObjectiveHub` instance that uses the default
 * settings.
 *
 * @warning **Important:** To get data which requires authentication you must set
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
 * @warning **Important:** The
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
 * @warning **Note:** Valid range is between 0 to 100 (the upper limit is a
 * [restriction from GitHub](http://developer.github.com/v3/#pagination)).
 * Where 0 (zero) means that we will let GitHub decide what the value should be.
 */
@property (assign) NSUInteger itemsPerPage;


#pragma mark - Network Activity
/** @name Network Activity */
/**
 * Whether the client should update the network activity indicator on iOS
 * automatically or not.
 *
 * @warning Only works on iOS.
 */
@property (nonatomic, assign) BOOL showNetworkActivityStatusAutomatically;


#pragma mark - Controlling Requests
/** @name Controlling Requests */
/**
 * Suspends all requests, including new ones.
 *
 * @see resumeAllRequests
 */
- (void)suspendAllRequests;

/**
 * Resume all requests, including previously sent and new ones.
 *
 * @see suspendAllRequests
 */
- (void)resumeAllRequests;

/**
 * Cancel all sent requests.
 */
- (void)cancelAllRequests;


@end
