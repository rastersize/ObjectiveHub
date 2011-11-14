//
//  FGOHError.h
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


#pragma mark FGOHError User Info Dictionary Default Keys
/// User info dictionary key to get the HTTP headers the error was created from.
extern NSString *const kFGOHErrorUserInfoHTTPHeadersKey;
/// User info dictionary key to get the response data.
extern NSString *const kFGOHErrorUserInfoResponseDataKey;


#pragma mark - ObjectiveHub Error Domain
/// The error domain for errors created by ObjectiveHub.
extern NSString *const kFGOHErrorDomain;


#pragma mark - ObjectiveHub Error Codes
/// The possible error codes for errors created by ObjectiveHub.
/// They have been taken from the article
/// [List of HTTP status codes](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
/// on Wikipedia as well as GitHubs developer site.
enum {
	kFGOHErrorCodeUnknown						= -1,
	
	#pragma mark |- Client Errors
	/* @name Client Errors */
	/// Error code for malformed requests.
	kFGOHErrorCodeBadRequest					= 400,
	/// Error code for request which require authentication which failed.
	kFGOHErrorCodeUnauthorized					= 401,
	/// Error code for when the request was legal but the server refuse to serve
	/// it. Authentication will make no difference.
	kFGOHErrorCodeForbidden						= 403,
	/// Error code if the sought resource did not exist.
	kFGOHErrorCodeNotFound						= 404,
	/// Error code if the method used was not allowed.
	kFGOHErrorCodeMethodNotAllowed				= 405,
	/// Error code if the 
	kFGOHErrorCodeUnprocessableEntity			= 422,
	
	#pragma mark |- Server Errors
	/* @name Server Errors */
	/// Error code for when a generic server error occured.
	kFGOHErrorCodeInternalServerError			= 500,
};
/// The error code type for ObjectiveHub error codes.
typedef NSInteger FGOHErrorCodeType;


#pragma mark - FGOHError Interface
@interface FGOHError : NSError

#pragma mark - Initializing an FGOHError Instance
/** @name Initializing an FGOHError Instance */
/**
 * Initializes and returns an `FGOHError` instance intialized with the values of
 * the given _httpHeaders_ dictionary, the status code specified by _httpStatus_
 * as well as the _body_ data.
 *
 * The code property is set to the HTTP status code.
 *
 * @param httpHeaders A dictionary containing the HTTP response headers.
 * @param httpStatus An integer which containing the HTTP status code.
 * @param responseBody The response body data.
 * @return An `FGOHError` instance initialized with the given http headers,
 * status and response body.
 */
- (id)initWithHTTPHeaders:(NSDictionary *)httpHeaders HTTPStatus:(NSInteger)httpStatus responseBody:(NSData *)responseBody;


#pragma mark - HTTP Headers
/** @name HTTP Header and Status */
/**
 * A convenience method for retrieving the HTTP headers dictionary object.
 *
 * This is the same as getting the value for the key
 * `kFGOHErrorUserInfoHttpHeadersKey` in the userInfo dictionary.
 */
@property (readonly, strong) NSDictionary *HTTPHeaders;


#pragma mark - Response Data
/** @name Response Data */
/**
 * A convenience method for retrieving the response body data object.
 *
 * This is the same as getting the value for the key
 * `kFGOHErrorUserInfoResponseData` in the userInfo dictionary.
 *
 * @see parsedResponseBody
 */
@property (readonly, strong) NSData *responseBody;


/**
 * Will try and parse the response body.
 *
 * The method will return the parsed response body in a container it considers
 * the best match. That might be an `NSDictionary`, `NSArray` and so on so check
 * the returned objects type if you care. Furthermore, `nil` can be returned if
 * the data could not be properly parsed (that is it is probably some binary
 * data and best accessed via the responseBody method).
 *
 * @see responseBody
 */
@property (readonly, strong) id parsedResponseBody;


@end

