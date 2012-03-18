//
//  CDOHClient.m
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

#import "CDOHClient.h"
#import "CDOHClientPrivate.h"
#import "CDOHClientProtocol.h"

#import "CDOHCommon.h"
#import "CDOHLibraryVersion.h"
#import "CDOHError.h"
#import "CDOHLinkRelationshipHeader.h"
#import "CDOHResponse.h"
#import "CDOHResponsePrivate.h"

#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"
#import "CDOHAbstractUser.h"
#import "CDOHUser.h"
#import "CDOHOrganization.h"
#import "CDOHOrganizationTeam.h"
#import "CDOHPlan.h"
#import "CDOHRepository.h"

#import "UIApplication+ObjectiveHub.h"

#import "AFNetworking.h"
#import "JSONKit.h"


#pragma mark GitHub API Base URI
/// The base URI for the GitHub API
NSString *const kCDOHGitHubBaseAPIURIString	= @"https://api.github.com";


#pragma mark - GitHub Mime Types
/// Mime type for getting the default type of data as JSON.
NSString *const kCDOHGitHubMimeGenericJSON	= @"application/vnd.github.v3+json";
/// Mime type for getting the raw data as JSON.
NSString *const kCDOHGitHubMimeRawJSON		= @"application/vnd.github.v3.raw+json";
/// Mime type for getting the text only representation of the data, as JSON.
NSString *const kCDOHGitHubMimeTextInJSON	= @"application/vnd.github.v3.text+json";
/// Mime type for getting the resource rendered as HTML as JSON.
NSString *const kCDOHGitHubMimeHtmlInJSON	= @"application/vnd.github.v3.html+json";
/// Mime type for getting raw, text and html versions of a resource in the same
/// response as JSON.
NSString *const kCDOHGitHubMimeFullInJSON	= @"application/vnd.github.v3.full+json";
/// Mime type for getting raw blob data (**not** wrapped in a JSON object).
NSString *const kCDOHGitHubMimeRaw			= @"application/vnd.github.v3.raw";


#pragma mark - ObjectiveHub User Agent
/// ObjectiveHub User Agent Format String
NSString *const kCDOHUserAgentFormat		= @"ObjectiveHub/%@";


#pragma mark - HTTP Header Response Keys
NSString *const kCDOHResponseHeaderXRateLimitLimitKey		= @"X-RateLimit-Limit";
NSString *const kCDOHResponseHeaderXRateLimitRemainingKey	= @"X-RateLimit-Remaining";
NSString *const kCDOHResponseHeaderLocationKey				= @"Location";
NSString *const kCDOHResponseHeaderLinkKey					= @"Link";


#pragma mark - Relative API Path
/// Creates a dictionary wherein the keys are string representations of the
/// corresponding values’ variable names.
///
/// More or less the same macro that was introduced in Mac OS X 10.7 with auto-
/// layout, but as it does not exist on the iOS platform we re-implement it
/// here.
#define CDOHDictionaryOfVariableBindings(...) _CDOHDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)

NSDictionary *_CDOHDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, id firstValue, ...); // not for direct use
NSDictionary *_CDOHDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, id firstValue, ...)
{
	NSDictionary *dictionary = nil;
	NSMutableArray *keys = nil;
	NSMutableArray *objects = nil;
	
	NSArray *tmpKeys = [commaSeparatedKeysString componentsSeparatedByString:@","];
	keys = [[NSMutableArray alloc] initWithCapacity:[tmpKeys count]];
	for (NSString *tmpKey in tmpKeys) {
		NSString *key = [tmpKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		[keys addObject:key];
	}
	
	objects = [[NSMutableArray alloc] initWithCapacity:[keys count]];
	id obj = firstValue;
	
	va_list args;
	va_start(args, firstValue);
	while (obj != nil) {
		[objects addObject:obj];
		obj = va_arg(args, id);
	}
	va_end(args);
	
	dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	return dictionary;
}


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
NSString *CDOHRelativeAPIPath(NSString *pathFormat, NSDictionary *options)
{
	// No need to do anything if options is empty or even nil, the end result
	// would have been to return the pathFormat anyway.
	if ([options count] == 0) { return pathFormat; }
	
	NSMutableString *path = [[NSMutableString alloc] init];
	NSArray *pathComponents = [pathFormat pathComponents];
	
	for (NSString *component in pathComponents) {
		NSString *pathComponent = nil;
		if ([component isEqualToString:@"/"]) {
			continue;
		} else if ([[component substringToIndex:1] isEqualToString:@":"]) {
			NSString *key = [component substringFromIndex:1];
			pathComponent = [options objectForKey:key];
		}
		
		if (pathComponent == nil) {
			pathComponent = component;
#if DEBUG
			NSLog(@"=== %s: No option for '%@'", __PRETTY_FUNCTION__, component);
#endif
		}
		
		[path appendFormat:@"/%@", pathComponent];
	}
	
	return path;
}

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
NSString *CDOHConcatenatedRelativeAPIPaths(NSArray *pathFormats, NSArray *optionDicts)
{
	NSMutableString *path = [[NSMutableString alloc] init];
	
	[pathFormats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL __unused *stop) {
		NSString *pathFormat = obj;
		
		NSDictionary *options = nil;
		if (idx < [optionDicts count]) {
			options = [optionDicts objectAtIndex:idx];
		}
		
		NSString *relativeApiPath = CDOHRelativeAPIPath(pathFormat, options);
		[path appendString:relativeApiPath];
	}];
	
	return path;
}


#pragma mark - GitHub Relative API Path (Formats)
#pragma mark |- Path Format Keys
NSString *const kCDOHResourceKey							= @"resource";
NSString *const kCDOHPropertyKey							= @"property";
NSString *const kCDOHIdentifierKey							= @"identifier";
NSString *const kCDOHOwnerKey								= @"owner";
NSString *const kCDOHRepositoryKey							= @"repo";
NSString *const kCDOHBaseKey								= @"base";
NSString *const kCDOHHeadKey								= @"head";

#pragma mark |- Resource Path Formats
/// The relative path for a :resource.
NSString *const kCDOHResourcePathFormat						= @"/:resource";
/// The relative path for a :property of a :resource.
NSString *const kCDOHResourcePropertyPathFormat				= @"/:resource/:property";
/// The relative path for a specific :resource identified using :identifier.
NSString *const kCDOHIdentifiedResourcePathFormat			= @"/:resource/:identifier";
/// The relative path for a :property of a :resource identified using :identifier.
NSString *const kCDOHIdentifiedResourcePropertyPathFormat	= @"/:resource/:identifier/:property";
/// The relative path for a :property identified using :identfier of a :resource.
NSString *const kCDOHResourcePropertyIdentifiedPathFormat	= @"/:resource/:property/:identifier";
/// The relative path for a repository (:owner, :repo) for a specific :property
/// of a :resource.
NSString *const kCDOHResourcePropertyRepositoryPathFormat	= @"/:resource/:property/:owner/:repo";

#pragma mark |- Repository Path Formats
NSString *const kCDOHRepositoryPathFormat					= @"/repos/:owner/:repo";
NSString *const kCDOHRepositoryComparePathFormat			= @"/repos/:owner/:repo/compare/:base...:head";

#pragma mark |- Git Data Path Formats
NSString *const kCDOHGitDataResourcePathFormat				= @"/repos/:owner/:repo/git/:resource";
NSString *const kCDOHGitDataResourcePropertyPathFormat		= @"/repos/:owner/:repo/git/:resource/:property";

#pragma mark |- Resources
NSString *const kCDOHResourceBlobs							= @"blobs";
NSString *const kCDOHResourceBranches						= @"branches";
NSString *const kCDOHResourceCollaborators					= @"collaborators";
NSString *const kCDOHResourceCommits						= @"commits";
NSString *const kCDOHResourceCompare						= @"compare";
NSString *const kCDOHResourceContributors					= @"contributors";
NSString *const kCDOHResourceDownloads						= @"downloads";
NSString *const kCDOHResourceForks							= @"forks";
NSString *const kCDOHResourceGists							= @"gists";
NSString *const kCDOHResourceHooks							= @"hooks";
NSString *const kCDOHResourceHub							= @"hub";
NSString *const kCDOHResourceIssues							= @"issues";
NSString *const kCDOHResourceKeys							= @"keys";
NSString *const kCDOHResourceLabels							= @"labels";
NSString *const kCDOHResourceLanguages						= @"languages";
NSString *const kCDOHResourceMilestones						= @"milestones";
NSString *const kCDOHResourceOrganizations					= @"orgs";
NSString *const kCDOHResourcePulls							= @"pulls";
NSString *const kCDOHResourceReceivedEvents					= @"received_events";
NSString *const kCDOHResourceReferences						= @"refs";
NSString *const kCDOHResourceRepositories					= @"repos";
NSString *const kCDOHResourceTags							= @"tags";
NSString *const kCDOHResourceTeams							= @"teams";
NSString *const kCDOHResourceTrees							= @"trees";
NSString *const kCDOHResourceAuthenticatedUser				= @"user";
NSString *const kCDOHResourceUsers							= @"users";
NSString *const kCDOHResourceWatchers						= @"watchers";

#pragma mark |- Resource Properties
NSString *const kCDOHResourcePropertyComments				= @"comments";
NSString *const kCDOHResourcePropertyEmails					= @"emails";
NSString *const kCDOHResourcePropertyEvents					= @"events";
NSString *const kCDOHResourcePropertyFiles					= @"files";
NSString *const kCDOHResourcePropertyFollowers				= @"followers";
NSString *const kCDOHResourcePropertyFollowing				= @"following";
NSString *const kCDOHResourcePropertyForks					= @"forks";
NSString *const kCDOHResourcePropertyMembers				= @"members";
NSString *const kCDOHResourcePropertyMerge					= @"merge";
NSString *const kCDOHResourcePropertyOrganizations			= @"orgs";
NSString *const kCDOHResourcePropertyPublic					= @"public";
NSString *const kCDOHResourcePropertyPublicMembers			= @"public_members";
NSString *const kCDOHResourcePropertyPush					= @"push";
NSString *const kCDOHResourcePropertyRepositories			= @"repos";
NSString *const kCDOHResourcePropertyStar					= @"star";
NSString *const kCDOHResourcePropertyStarred				= @"starred";
NSString *const kCDOHResourcePropertyTeams					= @"teams";
NSString *const kCDOHResourcePropertyWatched				= @"watched";


#pragma mark - Request Parameter Keys
/// The repositories type parameter key.
NSString *const kCDOHParameterRepositoriesTypeKey			= @"type";


#pragma mark - ObjectiveHub Generic Block Types
/// Block type for succesful requests.
typedef void (^CDOHInternalSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
/// Block type for failed requests.
typedef void (^CDOHInternalFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
/// Block type for creating the resource from parsed JSON data.
typedef id (^CDOHInternalResponseCreationBlock)(id parsedResponseData);


#pragma mark - Create Parameter Dictionaries
/// Creates an `NSDictionary` object of the objects passed into it (parameter
/// value and then followed by the parameter key).
#define CDOHParametersDictionary(...) [[NSDictionary alloc] initWithObjectsAndKeys: __VA_ARGS__, nil]


#pragma mark - Create Argument Arrays
/// Creates an `NSArray` object of the objects passed into it.
#define CDOHArrayOfArguments(...) [[NSArray alloc] initWithObjects: __VA_ARGS__, nil]


#pragma mark - ObjectiveHub Private Interface
@interface CDOHClient ()


#pragma mark - HTTP Client
/// The HTTP client used to communicate with GitHub internally.
@property (readonly, strong) AFHTTPClient *client;


#pragma mark - JSON Decoder
/// The JSON decoder object used for decoding JSON strings.
@property (readonly, strong) JSONDecoder *JSONDecoder;


#pragma mark - Request Helpers
/// Creates the standard request parameter dictionary.
- (NSMutableDictionary *)standardRequestParameterDictionaryForPage:(NSUInteger)page;

/// Creates a request parameter dictionary from a user supplied dictionary only
/// containing the keys in the given _validKeys_ array.
///
/// Also converts objects not directly supported by JSON such as `NSURL` objects
/// to a suitable JSON format.
- (NSMutableDictionary *)requestParameterDictionaryForDictionary:(NSDictionary *)dictionary validKeys:(NSArray *)validKeys;

/// Verify that an authenticated user has been set (will not verify that the
/// user is actually authorized) or call the given failureBlock.
- (BOOL)verifyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock;


#pragma mark - Standard Requests
/// Get an array of `CDOHRepository` objects from a given _path_ using the given
/// _params_ for the given _pages_.
- (void)repositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/// Get an array of `CDOHUser` objects from a given _path_ using the given
/// _params_ for the given _pages_.
- (void)usersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


#pragma mark - Response Helpers
/// Create an error from a failed request operation.
- (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation;


#pragma mark - Standard Blocks
#pragma mark |- Standard Error Block
/// The standard failure block.
- (CDOHInternalFailureBlock)standardFailureBlock:(CDOHFailureBlock)failureBlock;


#pragma mark |- Generic Standard Success Blocks
/// The standard success block for requests which return no data.
- (CDOHInternalSuccessBlock)standardSuccessBlockWithNoData:(CDOHResponseBlock)successBlock;

/// The standard success block for requests which return data.
- (CDOHInternalSuccessBlock)standardSuccessBlockWithResourceCreationBlock:(CDOHInternalResponseCreationBlock)block success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;


#pragma mark |- Concrete Standard Success Blocks
/// The standard success block for requests returning a user.
- (CDOHInternalSuccessBlock)standardUserSuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

/// The standard success block for requests returning an array of email
/// addresses.
- (CDOHInternalSuccessBlock)standardUserEmailSuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

/// The standard success block for requests returning an array of users.
- (CDOHInternalSuccessBlock)standardUserArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

/// The standard success block for requests returning a repository.
- (CDOHInternalSuccessBlock)standardRepositorySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

/// The standard success block for requests returning an array of repositories.
- (CDOHInternalSuccessBlock)standardRepositoryArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

@end


#pragma mark - ObjectiveHub Implementation
@implementation CDOHClient {
	NSLock *_usernameLock;
	NSLock *_passwordLock;
}

#pragma mark - Synthesizing
@synthesize username = _username;
@synthesize password = _password;
@synthesize itemsPerPage = _itemsPerPage;
@synthesize showNetworkActivityStatusAutomatically = _showNetworkActivityStatusAutomatically;

@synthesize client = _client;
@synthesize JSONDecoder = _jsonDecoder;


#pragma mark - Initializing ObjectiveHub
- (id)init
{
	self = [super init];
	if (self) {
		
		_itemsPerPage = kCDOHDefaultItemsPerPage;

		_usernameLock = [[NSLock alloc] init];
		_passwordLock = [[NSLock alloc] init];

		_client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kCDOHGitHubBaseAPIURIString]];
		[_client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
		[_client setParameterEncoding:AFJSONParameterEncoding];
		[_client setDefaultHeader:@"Accept" value:kCDOHGitHubMimeGenericJSON];
		[_client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:kCDOHUserAgentFormat, kCDOHLibraryVersion]];

		_jsonDecoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
	}
	
	return self;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
	self = [self init];
	if (self) {
		_username = [username copy];
		_password = [password copy];

		// TODO: This need to to be reset if the username or password is set during the lifetime of the object.
		[_client setAuthorizationHeaderWithUsername:_username password:_password];
	}
	
	return self;
}


#pragma mark - Describing a User Object
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { github API URI = %@, username is set = %@, password is set = %@ }>", [self class], self, kCDOHGitHubBaseAPIURIString, (self.username ? @"YES" : @"NO"), (self.password ? @"YES" : @"NO")];
}


#pragma mark - Configuration Options
- (NSUInteger)itemsPerPage
{
	return _itemsPerPage;
}

- (void)setItemsPerPage:(NSUInteger)itemsPerPage
{
	// Make sure "itemsPerPage" is in the range 0-100.
	if (itemsPerPage > 100) {
		[NSException raise:NSInvalidArgumentException format:@"itemsPerPage must be in the range (including) 0 and 100"];
		return;
	}
	
	_itemsPerPage = itemsPerPage;
}

// FIXME: Auth header should be set per request.
- (void)setUsername:(NSString *)username
{
	[_usernameLock lock];
	if (username != _username) {
		_username = [username copy];
		
		// FIXME: This should be set per request.
		[_client setAuthorizationHeaderWithUsername:_username password:_password];
	}
	[_usernameLock unlock];
}

- (NSString *)username
{
	NSString *username = nil;
	[_usernameLock lock];
	username = _username;
	[_usernameLock unlock];

	return username;
}

// FIXME: Auth header should be set per request.
- (void)setPassword:(NSString *)password
{
	[_passwordLock lock];
	if (password != _password) {
		_password = [password copy];
		
		// FIXME: This should be set per request.
		[_client setAuthorizationHeaderWithUsername:_username password:_password];
	}
	[_passwordLock unlock];
}

- (NSString *)password
{
	NSString *password = nil;
	[_passwordLock lock];
	password = _password;
	[_passwordLock unlock];

	return password;
}


#pragma mark - Network Activity
- (void)setShowNetworkActivityStatusAutomatically:(BOOL)flag
{
	_showNetworkActivityStatusAutomatically = flag;
#if TARGET_OS_IPHONE
	if (flag == NO) {
		[[UIApplication sharedApplication] cdoh_resetNetworkActivity];
	}
#endif // TARGET_OS_IPHONE
}


#pragma mark - Controlling Requests
- (oneway void)suspendAllRequests
{
	[self.client.operationQueue setSuspended:YES];
}

- (oneway void)resumeAllRequests
{
	[self.client.operationQueue setSuspended:NO];
}

- (oneway void)cancelAllRequests
{
	[self.client.operationQueue cancelAllOperations];

}


#pragma mark - Standard Error Block
- (CDOHInternalFailureBlock)standardFailureBlock:(CDOHFailureBlock)failureBlock
{
	return ^(AFHTTPRequestOperation *operation, __unused NSError *error) {
		if (failureBlock) {
			CDOHError *ohError = [self errorFromFailedOperation:operation];
			failureBlock(ohError);
		}
	};
}


#pragma mark - Generic Standard Success Blocks
- (CDOHInternalSuccessBlock)standardSuccessBlockWithNoData:(CDOHResponseBlock)successBlock
{
	return ^(__unused AFHTTPRequestOperation *__unused operation, __unused id responseObject) {
		if (successBlock) {
			successBlock(nil);
		}
	};
}

- (CDOHInternalSuccessBlock)standardSuccessBlockWithResourceCreationBlock:(CDOHInternalResponseCreationBlock)resourceCreationBlock success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	return ^(AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			if (responseObject && [responseObject length] > 0) {
				id parsedResponseObject = [self.JSONDecoder objectWithData:responseObject];
				id resource = resourceCreationBlock(parsedResponseObject);
				
				if (resource != nil) {
					NSHTTPURLResponse *httpUrlResponse = operation.response;
					NSDictionary *httpHeaders = [httpUrlResponse allHeaderFields];
					
					CDOHResponse *response = [[CDOHResponse alloc] initWithResource:resource
																			 target:self
																			 action:action
																	   successBlock:successBlock 
																	   failureBlock:failureBlock
																		HTTPHeaders:httpHeaders
																		  arguments:arguments];
					successBlock(response);
				} else if (failureBlock) {
					NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
											  operation, @"operation",
											  responseObject, kCDOHErrorUserInfoResponseDataKey,
											  nil];
					CDOHError *error = [[CDOHError alloc] initWithDomain:kCDOHErrorDomain code: kCDOHErrorCodeResponseObjectNotOfExpectedType userInfo:userInfo];
					failureBlock(error);
				}
			} else if (failureBlock) {
				NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
										  operation, @"operation", nil];
				CDOHError *error = [[CDOHError alloc] initWithDomain:kCDOHErrorDomain code:kCDOHErrorCodeResponseObjectEmpty userInfo:userInfo];
				failureBlock(error);
			}
		}
	};
}


#pragma mark - Concrete Standard Success Blocks
- (CDOHInternalSuccessBlock)standardUserSuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		CDOHUser *user = nil;
		if ([parsedResponseObject isKindOfClass:[NSDictionary class]]) {
			user = [[CDOHUser alloc] initWithJSONDictionary:parsedResponseObject];
		}
		
		return user;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}

- (CDOHInternalSuccessBlock)standardUserArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		NSMutableArray *users = nil;
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			CDOHUser *user = nil;
			users = [[NSMutableArray alloc] initWithCapacity:[parsedResponseObject count]];
			
			for (id userDict in parsedResponseObject) {
				if ([userDict isKindOfClass:[NSDictionary class]]) {
					user = [[CDOHUser alloc] initWithJSONDictionary:userDict];
					[users addObject:user];
				}
			}
		}
		
		return users;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}

- (CDOHInternalSuccessBlock)standardUserEmailSuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		NSArray *emails = nil;
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			emails = [parsedResponseObject copy];
		}
		
		return emails;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}

- (CDOHInternalSuccessBlock)standardRepositorySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		CDOHRepository *repo = nil;
		if ([parsedResponseObject isKindOfClass:[NSDictionary class]]) {
			repo = [[CDOHRepository alloc] initWithJSONDictionary:parsedResponseObject];
		}
		
		return repo;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}

- (CDOHInternalSuccessBlock)standardRepositoryArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	CDOHInternalResponseCreationBlock block = ^id (id parsedResponseObject) {
		NSMutableArray *reposArray = nil;
		if ([parsedResponseObject isKindOfClass:[NSArray class]]) {
			reposArray = [[NSMutableArray alloc] initWithCapacity:[parsedResponseObject count]];
		
			for (id repoDict in parsedResponseObject) {
				if ([repoDict isKindOfClass:[NSDictionary class]]) {
					CDOHRepository *repo = [[CDOHRepository alloc] initWithJSONDictionary:repoDict];
					[reposArray addObject:repo];
				}
			}
		}
		
		return reposArray;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}


#pragma mark - Standard Requests
- (void)repositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(path);
	if ([pages count] == 0) {
		pages = [NSIndexSet indexSetWithIndex:1];
	}
	
	__weak CDOHClient *blockSelf = self;
	[pages enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL __unused *stop) {
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[blockSelf.client getPath:path
					   parameters:paramDict
						  success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(path, params)]
						  failure:[self standardFailureBlock:failureBlock]];
	}];
}

- (void)usersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(path);
	if ([pages count] == 0) {
		pages = [NSIndexSet indexSetWithIndex:1];
	}
	
	__weak CDOHClient *blockSelf = self;
	[pages enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL __unused *stop) {
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[blockSelf.client getPath:path
					   parameters:paramDict
						  success:[blockSelf standardUserArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(path, params)]
						  failure:[blockSelf standardFailureBlock:failureBlock]];
	}];
}


#pragma mark - Request Helpers
- (NSMutableDictionary *)standardRequestParameterDictionaryForPage:(NSUInteger)page
{
	// Make room for page and perPage and some extra for custom stuff
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	if (page != 0) {
		NSNumber *pageIdx = [[NSNumber alloc] initWithUnsignedInteger:page];
		[dict setObject:pageIdx forKey:@"page"];
	}
	
	NSUInteger perPage = self.itemsPerPage;
	if (perPage != 0) {
		NSNumber *perPageIdx = [[NSNumber alloc] initWithUnsignedInteger:perPage];
		[dict setObject:perPageIdx forKey:@"per_page"];
	}
	
	return dict;
}

- (NSMutableDictionary *)requestParameterDictionaryForDictionary:(NSDictionary *)dictionary validKeys:(NSArray *)validKeys
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[validKeys count]];
	
	for (id key in validKeys) {
		id obj = [dictionary objectForKey:key];
		
		// Whitelisted classes
		if ([obj isKindOfClass:[NSString class]] ||
			[obj isKindOfClass:[NSNumber class]] ||
			[obj isKindOfClass:[NSArray class]] ||
			[obj isKindOfClass:[NSDictionary class]] ||
			[obj isKindOfClass:[NSNull class]] ||
			[obj isKindOfClass:[NSString class]]) {
			
			[params setObject:obj forKey:key];
		}
		// Transformable classes
		else if ([obj isKindOfClass:[NSURL class]]) {
			NSString *objStr = [(NSURL *)obj absoluteString];
			[params setObject:objStr forKey:key];
		}
		// Unkown classes
		else {
			NSLog(@"Invalid type of class '%@' for key '%@' skipping.", [obj class], [key class]);
		}
	}
	
	return params;
}

- (BOOL)verifyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock
{
	BOOL hasAuthenticatedUser = (self.username != nil && self.password != nil);

	if (!hasAuthenticatedUser && failureBlock != NULL) {
		CDOHError *error = [[CDOHError alloc] initWithDomain:kCDOHErrorDomain code:kCDOHErrorCodeNoAuthenticatedUser userInfo:nil];
		failureBlock(error);
	} else if (!hasAuthenticatedUser) {
		[NSException raise:NSInternalInconsistencyException format:@"No authenticated user set."];
	}
	
	return hasAuthenticatedUser;
}


#pragma mark - Response Helpers
- (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation
{
	NSDictionary *httpHeaders = [operation.response allHeaderFields];
	NSInteger httpStatus = [operation.response statusCode];
	NSData *responseData = [operation responseData];
	
	CDOHError *ohError = [[CDOHError alloc] initWithHTTPHeaders:httpHeaders HTTPStatus:httpStatus responseBody:responseData];
	
	return ohError;
}


#pragma mark - Users
- (oneway void)userWithLogin:(NSString *)login success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,	kCDOHResourceKey,
										 login,					kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePathFormat, options);
	[self.client getPath:path
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)user:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser, kCDOHResourceKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePathFormat, options);
	[self.client getPath:path
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:nil]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!dictionary || [dictionary count] == 0) { return; }
	
	NSMutableDictionary *params = nil;
	NSArray *keys = [[NSArray alloc] initWithObjects:
					 kCDOHUserNameKey,
					 kCDOHUserEmailKey,
					 kCDOHUserBlogKey,
					 kCDOHUserCompanyKey,
					 kCDOHUserLocationKey,
					 kCDOHUserHireableKey,
					 kCDOHUserBioKey,
					 nil];
	params = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser, kCDOHResourceKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePathFormat, options);
	[self.client patchPath:path
				parameters:params
				   success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(dictionary)]
				   failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - User Emails
- (oneway void)userEmails:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:nil]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)addUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(emails);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.client postPath:path
			   parameters:emails
				  success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(emails)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)deleteUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(emails);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyEmails,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.client deletePath:path
				 parameters:emails
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Repositories
- (oneway void)repository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)createRepository:(NSString *)name dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(name);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[dictionary count] + 1];
	if ([dictionary count] > 0) {
		NSArray *keys = [[NSArray alloc] initWithObjects:
						 kCDOHRepositoryDescriptionKey,
						 kCDOHRepositoryHomepageKey,
						 kCDOHRepositoryPrivateKey,
						 kCDOHRepositoryHasIssuesKey,
						 kCDOHRepositoryHasWikiKey,
						 kCDOHRepositoryHasDownloadsKey,
						 nil];
		NSDictionary *optionalDictionary = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
		[params addEntriesFromDictionary:optionalDictionary];
	}
	[params setObject:name forKey:kCDOHRepositoryNameKey];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(name, dictionary)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)createRepository:(NSString *)name inOrganization:(NSString *)organization dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(name);
	NSParameterAssert(organization);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:[dictionary count] + 1];
	if ([dictionary count] > 0) {
		NSArray *keys = [[NSArray alloc] initWithObjects:
						 kCDOHRepositoryDescriptionKey,
						 kCDOHRepositoryHomepageKey,
						 kCDOHRepositoryPrivateKey,
						 kCDOHRepositoryHasIssuesKey,
						 kCDOHRepositoryHasWikiKey,
						 kCDOHRepositoryHasDownloadsKey,
						 kCDOHRepositoryTeamIDKey,
						 nil];
		NSDictionary *optionalDictionary = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
		[params addEntriesFromDictionary:optionalDictionary];
	}
	[params setObject:name forKey:kCDOHRepositoryNameKey];
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceOrganizations,		kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 organization,						kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(name, organization)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)updateRepository:(NSString *)repo owner:(NSString *)owner dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!dictionary || [dictionary count] == 0) { return; }
	
	NSMutableDictionary *params = nil;
	NSArray *keys = [[NSArray alloc] initWithObjects:
					 kCDOHRepositoryNameKey,
					 kCDOHRepositoryDescriptionKey,
					 kCDOHRepositoryHomepageKey,
					 kCDOHRepositoryPrivateKey,
					 kCDOHRepositoryHasIssuesKey,
					 kCDOHRepositoryHasWikiKey,
					 kCDOHRepositoryHasDownloadsKey,
					 nil];
	params = [self requestParameterDictionaryForDictionary:dictionary validKeys:keys];
	
	if (![params objectForKey:kCDOHRepositoryNameKey]) {
		[params setObject:repo forKey:kCDOHRepositoryNameKey];
	}
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner, dictionary)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)repositories:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (oneway void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,				kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 login,								kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (oneway void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(organization);
	NSParameterAssert(type);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceOrganizations,		kCDOHResourceKey,
										 kCDOHResourcePropertyRepositories,	kCDOHPropertyKey,
										 organization,						kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);

	[self repositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (oneway void)repositoryContributors:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock) successBlock failure:(CDOHFailureBlock) failureBlock
{
	[self repositoryContributors:repository owner:owner anonymous:NO success:successBlock failure:failureBlock];
}

// TODO: This should create an array of dictionaries instead of user-objects (#42)
- (oneway void)repositoryContributors:(NSString *)repo owner:(NSString *)owner anonymous:(BOOL)anonymous success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }

	NSDictionary *params = CDOHParametersDictionary([NSNumber numberWithBool:anonymous], @"anon");
	
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceContributors, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self usersAtPath:path params:params pages:nil success:successBlock failure:failureBlock];
}

- (oneway void)repositoryLanguages:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	CDOHInternalResponseCreationBlock resourceCreationBlock = ^id (id parsedResponseObject) {
		NSDictionary *languagesDict = parsedResponseObject;
		
		NSMutableArray *languagesArray = nil;
		if ([languagesDict isKindOfClass:[NSDictionary class]]) {
			languagesArray = [[NSMutableArray alloc] initWithCapacity:[languagesDict count]];
			[languagesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *__unused stop) {
				NSDictionary *lang = [[NSDictionary alloc] initWithObjectsAndKeys:
									  key, kCDOHRepositoryLanguageNameKey,
									  obj, kCDOHRepositoryLanguageCharactersKey,
									  nil];
				
				[languagesArray addObject:lang];
			}];
		}
		
		return languagesArray;
	};
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceLanguages, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithResourceCreationBlock:resourceCreationBlock success:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner)]
				 failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Watched and Watching Repositories
- (oneway void)repositoryWatchers:(NSString *)repo owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceWatchers, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self usersAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (oneway void)repositoriesWatchedByUser:(NSString *)login pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(login);
	if (!successBlock && !failureBlock) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 login,							kCDOHIdentifierKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHIdentifiedResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

// TODO: Send message to repositoriesAtPath:params:pages:success:failure:
- (oneway void)repositoriesWatchedForPages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceAuthenticatedUser,	kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,		kCDOHPropertyKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyPathFormat, options);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}


- (oneway void)isUserWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)watchRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.client putPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (oneway void)stopWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *options = CDOHMakeDict(kCDOHResourceUsers,			kCDOHResourceKey,
										 kCDOHResourcePropertyWatched,	kCDOHPropertyKey,
										 repo,							kCDOHRepositoryKey,
										 owner,							kCDOHOwnerKey);
	NSString *path = CDOHRelativeAPIPath(kCDOHResourcePropertyRepositoryPathFormat, options);
	
	[self.client deletePath:path
				 parameters:nil
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Repository Forks
- (oneway void)repositoryForks:(NSString *)repo owner:(NSString *)owner pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (!successBlock && !failureBlock) { return; }
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceForks, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self repositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (oneway void)forkRepository:(NSString *)repo owner:(NSString *)owner intoOrganization:(NSString *)intoOrganization success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSParameterAssert(repo);
	NSParameterAssert(owner);
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSDictionary *params = nil;
	if ([intoOrganization length] > 0) {
		params = [[NSDictionary alloc] initWithObjectsAndKeys:
				  intoOrganization, @"org",
				  nil];
	}
	
	NSArray *pathFormats = CDOHMakeArray(kCDOHRepositoryPathFormat,
										 kCDOHResourcePathFormat);
	NSArray *optionDicts = CDOHMakeArray(CDOHMakeDict(repo,		kCDOHRepositoryKey,
													  owner,	kCDOHOwnerKey),
										 CDOHMakeDict(kCDOHResourceForks, kCDOHResourceKey));
	NSString *path = CDOHConcatenatedRelativeAPIPaths(pathFormats, optionDicts);
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner, intoOrganization)]
				  failure:[self standardFailureBlock:failureBlock]];
}


@end
