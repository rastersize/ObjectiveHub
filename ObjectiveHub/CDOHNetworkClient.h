//
//  CDOHNetworkClient.h
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


#pragma mark Forward Class Declarations
@class CDOHNetworkClientReply;


#pragma mark - CDOHNetworkClient Protocol
/**
 * The `CDOHNetworkClient` protocol specifies the methods ObjectiveHub needs
 * from a network library and can be used to write adapter classes.
 *
 * *NOTE:* All methods are required.
 *
 * ### Available adapter classes ###
 *
 * ObjectiveHub ships with one concrete adapter class, `CDOHAFNetworkingClient`,
 * which is an (XPC service ready) adapter for the
 * [AFNetworking](https://github.com/AFNetworking/AFNetworking) library.
 */
@protocol CDOHNetworkClient <NSObject>
@required

#pragma mark - Adapter Dependencies
/** @name Adapter Dependencies */
/**
 * Checks the network client adapter dependencies.
 *
 * @return `YES` if all the dependencies of the adapter are satisfied, otherwise
 * `NO`.
 */
+ (BOOL)checkDependencies;



#pragma mark - Creating and Initializing Network Clients
/** @name Creating and Initializing Network Clients */
/**
 * Returns an initialized `CDOHNetworkClient` conformant object setup to send
 * HTTP requests, with the given default headers, to the service at the given
 * base URL.
 *
 * @param baseURL The base URL of the service.
 * @param defaultHeaders The default headers which will be sent to the service
 * on each request.
 * @return An initialized `CDOHNetworkClient` conformant object setup to send
 * HTTP requests, with the given default headers, to the service at the given
 * base URL.
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL defaultHeaders:(NSDictionary *)defaultHeaders;


#pragma mark - Client Configuration
/**
 * The base URL of the service.
 */
@property (strong, readonly) NSURL *baseURL;


#pragma mark - Request Controls
/** @name Request Controls */
/**
 * Suspend the requests which have not yet been sent to the remote host.
 *
 * New requests can be made while the network client is suspended, they should
 * in this case be queued ready to be sent at a later time.
 *
 * @see resume
 */
- (oneway void)suspend;

/**
 * Resume network requests.
 *
 * Requests which were queued while the network client was suspended must now by
 * sent.
 *
 * @see suspend
 */
- (oneway void)resume;

/**
 * Cancel all network requests received up to this point.
 *
 * New requests can be made after this message and they should be treaded
 * normally, i.e. be sent to the remote host.
 */
- (oneway void)cancelAll;


#pragma mark - Performing Requests
/** @name Performing Requests */
/**
 * Perform a HTTP `GET` request for the resource at the given relative path.
 *
 * @param path The relative, to the base URL, path of the resource.
 * @param parameters The parameters which should be used.
 *
 * The following classes are supported:
 * 
 * - `NSString`,
 * - `NSArray` and
 * - `NSDictionary`.
 * @param username The username used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param password The password used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param replyBlock A block which will be executed and passed the reply from
 * the remote host.
 */
- (oneway void)getPath:(NSString *)path
			parameters:(id)parameters
			  username:(NSString *)username
			  password:(NSString *)password
		withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock;

/**
 * Perform a HTTP `POST` request for the resource at the given relative path.
 *
 * @param path The relative, to the base URL, path of the resource.
 * @param parameters The parameters which should be used.
 *
 * The following classes are supported:
 * 
 * - `NSString`,
 * - `NSArray` and
 * - `NSDictionary`.
 * @param username The username used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param password The password used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param replyBlock A block which will be executed and passed the reply from
 * the remote host.
 */
- (oneway void)postPath:(NSString *)path
			 parameters:(id)parameters
			   username:(NSString *)username
			   password:(NSString *)password
		 withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock;

/**
 * Perform a HTTP `PUT` request for the resource at the given relative path.
 *
 * @param path The relative, to the base URL, path of the resource.
 * @param parameters The parameters which should be used.
 *
 * The following classes are supported:
 * 
 * - `NSString`,
 * - `NSArray` and
 * - `NSDictionary`.
 * @param username The username used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param password The password used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param replyBlock A block which will be executed and passed the reply from
 * the remote host.
 */
- (oneway void)putPath:(NSString *)path
			parameters:(id)parameters
			  username:(NSString *)username
			  password:(NSString *)password
		withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock;

/**
 * Perform a HTTP `PATCH` request for the resource at the given relative path.
 *
 * @param path The relative, to the base URL, path of the resource.
 * @param parameters The parameters which should be used.
 *
 * The following classes are supported:
 * 
 * - `NSString`,
 * - `NSArray` and
 * - `NSDictionary`.
 * @param username The username used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param password The password used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param replyBlock A block which will be executed and passed the reply from
 * the remote host.
 */
- (oneway void)patchPath:(NSString *)path
			  parameters:(id)parameters
				username:(NSString *)username
				password:(NSString *)password
		  withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock;

/**
 * Perform a HTTP `DELETE` request for the resource at the given relative path.
 *
 * @param path The relative, to the base URL, path of the resource.
 * @param parameters The parameters which should be used.
 *
 * The following classes are supported:
 * 
 * - `NSString`,
 * - `NSArray` and
 * - `NSDictionary`.
 * @param username The username used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param password The password used to authenticate the user with. May be `nil`
 * in which case no authentication header will be set for this request.
 * @param replyBlock A block which will be executed and passed the reply from
 * the remote host.
 */
- (oneway void)deletePath:(NSString *)path
			   parameters:(id)parameters
				 username:(NSString *)username
				 password:(NSString *)password
		   withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock;


#pragma mark - Performing Multipart Form Data Requests
// TODO: Multipart Data


@end
