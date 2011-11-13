//
//  ObjectiveHub.h
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

//#import <ObjectiveHub/FGOHUser.h>

#pragma mark Constants
/// The default default items per page.
#define kObjectiveHubDefaultItemsPerPage				30

/// The default rate limit of API requests, where zero (0) means automatic.
#define kObjectiveHubDefaultRateLimit					0


#pragma mark - ObjectiveHub Interface
/**
 * Objective-C class for comunicating with GitHub.
 *
 * Currently version 3 of the GitHub API is used internally.
 *
 * The framework will handle the rate limiting of GitHub automatically but you
 * tell the framework that you app has been whitelisted by GitHub if needed.
 * That is you might have a different limit than the default. But for the sake
 * of all of us be nice towards the service.
 *
 * @TODO: We should only require a password when GitHub requires us to authenticate else we should not store it (so that we do not expose the user to unnecessary risks. 
 */
@interface ObjectiveHub : NSObject

#pragma mark - Initializing ObjectiveHub
/** @name Initializing ObjectiveHub */
/**
 * Initializes and returns an `ObjectiveHub` instance that uses the given
 * username and password for authentication with GitHub.
 *
 * @warning *Important* The
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
 * The default value is 30 items per page, this can be customized on a per
 * request basis if needed.
 *
 * @warning *Note* Valid range is between 1 to 100 (the upper limit is a
 * [restriction from GitHub](http://developer.github.com/v3/#pagination)).
 */
@property (assign) NSUInteger defaultItemsPerPage;

/**
 * The API request rate limit.
 *
 * @warning *Note* setting the rate limit to zero (`0`) will make the framework
 * manage the rate limiting automatically.
 */
@property (assign) NSUInteger rateLimit;




@end
