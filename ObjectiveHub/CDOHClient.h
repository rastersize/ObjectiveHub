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
#import <ObjectiveHub/CDOHNetworkClient.h>


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
 *	- (id)init {
 *		self = [super init];
 *		if (self) {
 *			// Asume we have an ivar/property "_client".
 *			_client = [[CDOHClient alloc] init];
 *		}
 *		return self;
 *	}
 *	
 *	- (void)loadData {
 *		NSString *username = ...
 *		
 *		__weak MyClass *blockSelf = self;
 *		[_client repositoriesWatchedByUser:username pages:nil success:^(CDOHResponse *response) {
 *			// Handle the response (you will probably want to do something
 *			// smarter than the row below). Assumes we have a property for a
 *			// mutable collection (e.g. NSMutableArray).
 *			[blockSelf.watchedRepos addObjectsFromArray:response.resource];
 *			
 *			// Make sure we load all repositories watched by the user. The
 *			// success and failure blocks used in the first request will be re-
 *			// used. Just take care if the user is watching thousands of
 *			// repositories. As such you would probably want to do something a
 *			// bit more inteligent.
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

#pragma mark - Network Client Adapters
/** @name Network Client Adapters */
/**
 * Attempts to register the given class as a possible network client adapter.
 *
 * Instances of _adapterClass_ must conform to the `CDOHNetworkClient` protocol.
 *
 * @param adapterClass The class which should be registerred as a network client
 * adapter. Must conform to the `CDOHNetworkClient` protocol.
 * @return `YES` if the registration was successful, otherwise `NO`.
 */
+ (BOOL)registerNetworkClientAdapterClass:(Class)adapterClass;

/**
 * Unregisters the given network client adapter class.
 *
 * @param adapterClass The network client adapter class which should be
 * unregistered.
 */
+ (void)unregisterNetworkClientAdapterClass:(Class)adapterClass;


#pragma mark - Initializing ObjectiveHub
/** @name Initializing ObjectiveHub */
/**
 * Initializes and returns an `ObjectiveHub` instance that uses the default
 * settings.
 *
 * Will try to set the network client to one of the known adapters. If this
 * fails (becasue no known library was found). Please see the `CDOHNetworkClient` protocol
 * documentation for a list of bundled adapters.
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

/**
 * The base URL of the GitHub API.
 *
 * The default value is the URL of GitHubs "hosted" API. You can set this to
 * your private GitHub instance.
 */
@property (strong) NSURL *baseURL;

/**
 * The default HTTP headers used to initialize a network client.
 *
 * @return A dictionary containing the default HTTP headers used with a network
 * client.
 */
+ (NSDictionary *)defaultNetworkClientHTTPHeaders;

/**
 * The network client which the library should use for network requests.
 *
 * The default tries to find out which network library have been linked in
 * (that is supported) and use that. You may implement your own adapter class
 * which implement the `CDOHNetworkClient` protocol and use it if you want to. 
 */
@property (strong) id<CDOHNetworkClient>networkClient;

/**
 * The grand central dispatch queue on which supplied blocks will be executed.
 *
 * A queue may be supplied onto which (success and failure) blocks will be
 * schedueled when it is time for them to execute. If no queue is supplied the
 * blocks will be schedueled on a global queue with the priority
 * `DISPATCH_QUEUE_PRIORITY_DEFAULT`.
 *
 * The queue must not be `NULL`.
 *
 * The queue is retained by the receiver.
 *
 * @warning **Note:** Chaning this property while a request is running is
 * considered undefined behavior and might result in a crash. Please only change
 * the value while no requests are running, such as when setting up the client.
 */
@property (strong) dispatch_queue_t queue;

/**
 * The grand central dispatch group which the supplied success and failure
 * blocks belong to.
 *
 * May be `NULL` in which case the blocks will be schedueled onto the `queue`
 * without any grouping.
 *
 * The group is retained by the receiver.
 *
 * @warning **Note:** Chaning this property while a request is running is
 * considered undefined behavior and might result in a crash. Please only change
 * the value while no requests are running, such as when setting up the client.
 */
@property (strong) dispatch_group_t blocksGroup;


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
