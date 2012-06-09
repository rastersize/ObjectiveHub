//
//  CDOHClientPrivate.h
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


#pragma mark Forward Class Declarations
@class JSONDecoder;


#pragma mark - Relative API Path
/// Creates a dictionary wherein the keys are string representations of the
/// corresponding values’ variable names.
///
/// More or less the same macro that was introduced in Mac OS X 10.7 with auto-
/// layout, but as it does not exist on the iOS platform we re-implement it
/// here.
#define CDOHDictionaryOfVariableBindings(...) _CDOHDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)

NSDictionary *_CDOHDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, id firstValue, ...); // not for direct use

/// Create the relative API path for the given _pathFormat_. The given _options_
/// are substituted into the path format.
///
/// As such if the path format is `/users/:login` you should supply a dictionary
/// with a key named `login` the object for that key should then be what you
/// wish to substitute `:login`.
///
/// For example:
/// 
///		// Assume the following path format is defined.
///		NSString *const kCDOHUserPathFormat = @"/users/:login";
///		...
///		
///		NSString *login = @"octocat";
///		NSDictionary *options = CDOHDictionaryOfVariableBindings(login);
///		NSString *path = CDOHRelativeAPIPath(
///			kCDOHUserPathFormat,
///			options
///		);
///
/// If an option is not supplied the key (including the colon, ":") will be
/// used.
NSString *CDOHRelativeAPIPath(NSString *pathFormat, NSDictionary *options);

/**
 * To get/use the relative API path "/repos/:user/:repo/issues/:id/labels/:id"
 * you can do the following (psuedo codeish):
 *
 *     NSArray *pathFormats = @[
 *         kCDOHRepositoryPathFormat,
 *         kCDOHResourcePropertyPathFormat,
 *         kCDOHResourcePropertyPathFormat
 *     ];
 *     NSArray *optionDicts = @[
 *         @{@"owner", owner, @"repo", repo},
 *         @{@"resource", kCDOHResourceIssues, @"identifier", issueIdentifier},
 *         @{@"resource", kCDOHResourceLabels, @"identifier", labelIdentifier}
 *     ];
 *     
 *     NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
 *
 */
NSString *CDOHConcatenatedRelativeAPIPaths(NSArray *pathFormats, NSArray *optionDicts);


#pragma mark - Create Parameter Dictionaries
/// Creates an `NSDictionary` object of the objects passed into it (parameter
/// value and then followed by the parameter key).
#define CDOHParametersDictionary(...) [[NSDictionary alloc] initWithObjectsAndKeys: __VA_ARGS__, nil]


#pragma mark - Create Argument Arrays
/// Creates an `NSArray` object of the objects passed into it.
#define CDOHArrayOfArguments(...)	[[NSArray alloc] initWithObjects: __VA_ARGS__, nil]


#pragma mark - CDOHClient Internal Block Types
/// Block type for creating the resource from parsed JSON data.
typedef id (^CDOHInternalResponseCreationBlock)(id parsedResponseData);


#pragma mark - Private CDOHClient Interface
@interface CDOHClient (/*Private*/)

#pragma mark - Network Client Adapters
/**
 * An array of all the registered network client adapters.
 * The first object (index = 0) has the highest priority. 
 */
+ (NSMutableArray *)registeredNetworkClientAdapters;


#pragma mark - Request Helpers
/**
 * Creates the standard request parameter dictionary.
 */
- (NSMutableDictionary *)standardRequestParameterDictionaryForPage:(NSUInteger)page;

/**
 * Creates a request parameter dictionary from a user supplied dictionary only
 * containing the keys in the given _validKeys_ array.
 *
 * Also converts objects not directly supported by JSON such as `NSURL` objects
 * to a suitable JSON format.
 */
- (NSMutableDictionary *)requestParameterDictionaryForDictionary:(NSDictionary *)dictionary validKeys:(NSArray *)validKeys;

/**
 * Verify that an authenticated user has been set (will not verify that the
 * user is actually authorized) or call the given failureBlock.
 */
- (BOOL)verifyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock;


#pragma mark - Standard Requests
/**
 * Get an array of `CDOHRepository` objects from a given _path_ using the given
 * _params_ for the given _pages_.
 */
- (void)repositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * Get an array of `CDOHUser` objects from a given _path_ using the given
 * _params_ for the given _pages_.
 */
- (void)usersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Generic Standard Reply Blocks
/**
 * The standard reply block when no data is expected. The _successBlock_ will be
 * called with `nil`.
 */
- (CDOHNetworkClientReplyBlock)standardReplyBlockForNoDataResponse:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/**
 * The standard reply block when some data is expected, the resource is created
 * by the _resourceCreationBlock_.
 */
- (CDOHNetworkClientReplyBlock)standardReplyBlockWithResourceCreationBlock:(CDOHInternalResponseCreationBlock)resourceCreationBlock success:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;


#pragma mark - Concrete Standard Reply Blocks
/**
 * The standard success block for requests returning a user.
 */
- (CDOHNetworkClientReplyBlock)standardUserReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;

/**
 * The standard success block for requests returning an array of users.
 */
- (CDOHNetworkClientReplyBlock)standardUserArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;

/**
 * The standard success block for requests returning an array of email
 * addresses.
 */
- (CDOHNetworkClientReplyBlock)standardArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;

/**
 * The standard success block for requests returning a repository.
 */
- (CDOHNetworkClientReplyBlock)standardRepositoryReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;

/**
 * The standard success block for requests returning an array of repositories.
 */
- (CDOHNetworkClientReplyBlock)standardRepositoryArrayReplyBlock:(CDOHSuccessBlock)successBlock failure:(CDOHFailureBlock)failureBlock selector:(SEL)selector arguments:(NSArray *)arguments;


#pragma mark - Block Execution
/** @name Block Execution */
/**
 * Perform the given block on the current queue and if set using the
 * blocks group.
 */
- (void)cdoh_performBlock:(void (^)(id))block withObject:(id)object;


@end


