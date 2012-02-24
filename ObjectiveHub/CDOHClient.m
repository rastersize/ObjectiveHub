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
#import "CDOHClientProtocol.h"
#import "CDOHLibraryVersion.h"

#import "AFNetworking.h"
#import "JSONKit.h"

#import "CDOHError.h"
#import "CDOHLinkRelationshipHeader.h"
#import "CDOHResponse.h"
#import "CDOHResponsePrivate.h"

#import "CDOHUser.h"
#import "CDOHRepository.h"


#pragma mark Constants
/// The base URI for the GitHub API
NSString *const kCDOHGitHubBaseAPIURIString	= @"https://api.github.com";

/// ObjectiveHub User Agent Format String
NSString *const kCDOHUserAgentFormat		= @"ObjectiveHub/%@";


#pragma mark - Pages Array Helper
NSArray *_CDOHPagesArrayForPageIndexes(NSUInteger pageIdx, ...)
{
	NSUInteger idx = pageIdx;
	NSNumber *idxNum = nil;
	NSMutableArray *pages = [[NSMutableArray alloc] init];
	
	va_list args;
	va_start(args, pageIdx);
	while (idx != NSUIntegerMax) {
		idxNum = [[NSNumber alloc] initWithUnsignedInteger:idx];
		[pages addObject:idxNum];
		
		idx = va_arg(args, NSUInteger);
	}
	va_end(args);
	
	return pages;
}


#pragma mark - Argument Verification Helper.
/// `YES` == no argument was `nil`, `NO` == one or more arguments were `nil`.
#define CDOHVerifyArgumentsNotNilOrThrowException(...) _CDOHVerifyArgumentsNotNilOrThrowException(__PRETTY_FUNCTION__, @"" # __VA_ARGS__, __VA_ARGS__, [_CDOHVerifyArgumentsNotNilOrThrowExceptionMarker marker])

@interface _CDOHVerifyArgumentsNotNilOrThrowExceptionMarker : NSObject
+ (_CDOHVerifyArgumentsNotNilOrThrowExceptionMarker *)marker;
@end
@implementation _CDOHVerifyArgumentsNotNilOrThrowExceptionMarker
+ (_CDOHVerifyArgumentsNotNilOrThrowExceptionMarker *)marker
{
	static _CDOHVerifyArgumentsNotNilOrThrowExceptionMarker *marker = nil;
	static dispatch_once_t markerOnceToken;
	dispatch_once(&markerOnceToken, ^{
		marker = [[self alloc] init];
	});
	
	return marker;
}
@end

/// Last argument MUST be the `_CDOHVerifyArgumentsNotNilOrThrowExceptionMarker`
/// +marker object.
BOOL _CDOHVerifyArgumentsNotNilOrThrowException(const char *prettyFunction, NSString *commaSeparatedVariableNameString, id firstArgument, ...);

BOOL _CDOHVerifyArgumentsNotNilOrThrowException(const char *prettyFunction, NSString *commaSeparatedVariableNameString, id firstArgument, ...)
{
	id arg = firstArgument;
	BOOL hasNilArg = NO;
	
	id endMarker = [_CDOHVerifyArgumentsNotNilOrThrowExceptionMarker marker];
	
	va_list args;
	va_start(args, firstArgument);
	while (arg != endMarker && !hasNilArg) {
		hasNilArg = arg == nil;
		arg = va_arg(args, id);
	}
	va_end(args);
	
	if (hasNilArg) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied to %s were invalid (nil)", commaSeparatedVariableNameString, prettyFunction];
		return NO;
	}
	
	return YES;
}


#pragma mark - GitHub Mime Types
/// Mime type for getting the default type of data as JSON.
NSString *const kCDOHGitHubMimeGenericJSON	= @"application/vnd.github.beta+json";
/// Mime type for getting the raw data as JSON.
NSString *const kCDOHGitHubMimeRawJSON		= @"application/vnd.github.beta.raw+json";
/// Mime type for getting the text only representation of the data, as JSON.
NSString *const kCDOHGitHubMimeTextInJSON	= @"application/vnd.github.beta.text+json";
/// Mime type for getting the resource rendered as HTML as JSON.
NSString *const kCDOHGitHubMimeHtmlInJSON	= @"application/vnd.github.beta.html+json";
/// Mime type for getting raw, text and html versions of a resource in the same
/// response as JSON.
NSString *const kCDOHGitHubMimeFullInJSON	= @"application/vnd.github.beta.full+json";
/// Mime type for getting raw blob data (**not** wrapped in a JSON object).
NSString *const kCDOHGitHubMimeRaw			= @"application/vnd.github.beta.raw";


#pragma mark - HTTP Header Response Keys
///
NSString *const kCDOHResponseHeaderXRateLimitLimitKey		= @"X-RateLimit-Limit";
///
NSString *const kCDOHResponseHeaderXRateLimitRemainingKey	= @"X-RateLimit-Remaining";
///
NSString *const kCDOHResponseHeaderLocationKey				= @"Location";
///
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
NSString *CDOHRelativeAPIPath(NSString *pathFormat, NSDictionary *__unused options)
{
	// Length of path + 8 extra chars per option (as it is likely the login of
	// a user or the name of a repo to be longer than ":login" or ":repo").
	NSMutableString *path = [[NSMutableString alloc] initWithCapacity:[pathFormat length] + ([options count] * 8)];
	
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
		}
		
		[path appendFormat:@"/%@", pathComponent];
	}
	
	return path;
}


#pragma mark - GitHub Relative API Path (Formats)
#pragma mark |- Users
/// The relative path format for a user with login.
/// Takes one string;
/// 1. the `login` name of the user.
NSString *const kCDOHUserPathFormat							= @"/users/:login";
/// The relative path format for a given users resource (such as "repos",
/// "followers" and so on).
/// Takes two string:
/// 1. the `login` of the user.
/// 2. the `resource` sought for the user.
NSString *const kCDOHUserResourcePathFormat					= @"/users/:login/:resource";

#pragma mark |- Authenticated User
/// The relative path for the authenticated user.
NSString *const kCDOHAuthenticatedUserPath					= @"/user";
/// The relative path format for a resource of the authenticated user (such as
/// "repos", "followers", "emails" and so on).
/// Takes one string:
/// 2. the `resource` sought for the user.
NSString *const kCDOHAuthenticatedUserResourcePath			= @"/user/:resource";
/// The relative path for checking if the authenticated user is watching the
/// given repository. Also used to start/stop watching the given repository.
/// Takes two strings;
/// 1. the `owner` login of the repository,
/// 2. the `repo` name.
NSString *const kCDOHAuthenticatedWatchedRepositoryPath		= @"/user/watched/:owner/:repo";
/// The relative path for checking if the authenticated user is following the
/// given user. Also used to start/stop follow or the given user.
/// Takes one strings;
/// 1. the `login` of the user which should be checked if the authenticated user
/// is following or to start/stop follow.
NSString *const kCDOHAuthenticatedFollowingUserPath			= @"/user/following/:login";

#pragma mark |- Repositories
/// The relative path format for a given repository.
/// Takes two strings:
/// 1. the `owner` login of the repository,
/// 2. the `repo` name.
NSString *const kCDOHRepositoryPathFormat					= @"/repos/:owner/:repo";
/// The relative path format for a resource of the given repository.
/// Takes three strings:
/// 1. the `owner` login of the repository,
/// 2. the `repo` name.
/// 3. the `resource` sought for the repository (such as "forks", "watchers" and
///    so on).
NSString *const kCDOHRepositoryResourcePathFormat			= @"/repos/:owner/:repo/:resource";

#pragma mark |- Organizations
/// The relative path format for a given organizations repositories.
/// Takes one string:
/// 1. the name of the `organization`.
NSString *const kCDOHOrganizationPathFormat					= @"/orgs/:organization";
NSString *const kCDOHOrganizationResourcePathFormat			= @"/orgs/:organization/:resource";
NSString *const kCDOHOrganizationResourceUserPathFormat		= @"/orgs/:organization/:resource/:login";

#pragma mark |- Teams
NSString *const kCDOHTeamPathFormat							= @"/teams/:team";
NSString *const kCDOHTeamResourcePathFormat					= @"/teams/:team/:resource";
NSString *const kCDOHTeamResourceUserPathFormat				= @"/teams/:team/:resource/:user";
NSString *const kCDOHTeamResourceRepositoryPathFormat		= @"/teams/:team/:resource/:owner/:repo";


#pragma mark - GitHub API Path Resources
#pragma mark |- User and Authenticated User Resources
///
NSString *const kCDOHUserRepositoriesResource				= @"repos";
///
NSString *const kCDOHUserWatchedRepositoriesResource		= @"watched";
///
NSString *const kCDOHUserFollowersResource					= @"followers";
///
NSString *const kCDOHUserFollowingResource					= @"following";
///
NSString *const kCDOHAuthenticatedUserEmailsResource		= @"emails";


#pragma mark |- Repository Resources
/// Repository watchers resource.
NSString *const kCDOHRepositoryWatchersResource				= @"watchers";
/// Repository forks resource.
NSString *const kCDOHRepositoryForksResource				= @"forks";
/// Repository contributors resource.
NSString *const kCDOHRepositoryContributorsResource			= @"contributors";
/// Repository languages resource.
NSString *const kCDOHRepositoryLanguagesResource			= @"languages";
/// Repository teams resource.
NSString *const kCDOHRepositoryTeamsResource				= @"teams";
/// Repository tags resource.
NSString *const kCDOHRepositoryTagsResource					= @"tags";
/// Repository branches resource.
NSString *const kCDOHRepositoryBranchesResource				= @"branches";

#pragma mark |- Organization Resources
///
NSString *const kCDOHOrganizationRepositoriesResource		= @"repos";



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
- (void)getRepositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;

/// Get an array of `CDOHUser` objects from a given _path_ using the given
/// _params_ for the given _pages_.
- (void)getUsersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock;


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


#pragma mark - Controlling Requests
- (void)suspendAllRequests
{
	[self.client.operationQueue setSuspended:YES];
}

- (void)resumeAllRequests
{
	[self.client.operationQueue setSuspended:NO];
}

- (void)cancelAllRequests
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
			user = [[CDOHUser alloc] initWithDictionary:parsedResponseObject];
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
					user = [[CDOHUser alloc] initWithDictionary:userDict];
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
			repo = [[CDOHRepository alloc] initWithDictionary:parsedResponseObject];
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
					CDOHRepository *repo = [[CDOHRepository alloc] initWithDictionary:repoDict];
					[reposArray addObject:repo];
				}
			}
		}
		
		return reposArray;
	};
	
	return [self standardSuccessBlockWithResourceCreationBlock:block success:successBlock failure:failureBlock action:action arguments:arguments];
}


#pragma mark - Standard Requests
- (void)getRepositoriesAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	CDOHVerifyArgumentsNotNilOrThrowException(path);
	if ([pages count] == 0) {
		pages = CDOHPagesArrayForPageIndexes(1);
	}
	
	for (NSNumber *idxNum in pages) {
		NSUInteger idx = [idxNum unsignedIntegerValue];
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[self.client getPath:path
				  parameters:paramDict
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(path, params)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}

- (void)getUsersAtPath:(NSString *)path params:(NSDictionary *)params pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	CDOHVerifyArgumentsNotNilOrThrowException(path);
	if ([pages count] == 0) {
		pages = CDOHPagesArrayForPageIndexes(1);
	}
	
	for (NSNumber *idxNum in pages) {
		NSUInteger idx = [idxNum unsignedIntegerValue];
		NSMutableDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		[paramDict addEntriesFromDictionary:params];
		
		[self.client getPath:path
				  parameters:paramDict
					 success:[self standardUserArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(path, params)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
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
- (void)userWithLogin:(NSString *)login success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(login)) { return; }

	NSString *path = CDOHRelativeAPIPath(kCDOHUserPathFormat, CDOHDictionaryOfVariableBindings(login));
	//NSString *getPath = [[NSString alloc] initWithFormat:kCDOHUserPathFormat, login];
	[self.client getPath:path
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)user:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	[self.client getPath:kCDOHAuthenticatedUserPath
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:nil]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
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
	
	[self.client patchPath:kCDOHAuthenticatedUserPath
				parameters:params
				   success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(dictionary)]
				   failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - User Emails
- (void)userEmails:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	
	NSString *resource = kCDOHAuthenticatedUserEmailsResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedUserResourcePath, CDOHDictionaryOfVariableBindings(resource));
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:nil]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)addUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(emails)) { return; }
	
	NSString *resource = kCDOHAuthenticatedUserEmailsResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedUserResourcePath, CDOHDictionaryOfVariableBindings(resource));
	
	[self.client postPath:path
			   parameters:emails
				  success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(emails)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)deleteUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(emails)) { return; }
	
	NSString *resource = kCDOHAuthenticatedUserEmailsResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedUserResourcePath, CDOHDictionaryOfVariableBindings(resource));
	
	[self.client deletePath:path
				 parameters:emails
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Repositories
- (void)repository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)createRepository:(NSString *)name dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(name)) { return; }
	
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
	
	
	NSString *resource = kCDOHUserRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedUserResourcePath, CDOHDictionaryOfVariableBindings(resource));
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(name, dictionary)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)createRepository:(NSString *)name inOrganization:(NSString *)organization dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(name, organization)) { return; }
	
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
	
	NSString *resource = kCDOHOrganizationRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHOrganizationResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, organization));
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(name, organization)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)updateRepository:(NSString *)repo owner:(NSString *)owner dictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!dictionary || [dictionary count] == 0) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
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
	
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryPathFormat, CDOHDictionaryOfVariableBindings(repo,owner));
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner, dictionary)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)repositories:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(type)) { return; }
	
	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSString *resource = kCDOHUserRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedUserResourcePath, CDOHDictionaryOfVariableBindings(resource));
	
	[self getRepositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(login, type)) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSString *resource = kCDOHUserRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHUserResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, login));
	
	[self getRepositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(organization, type)) { return; }

	NSDictionary *params = CDOHParametersDictionary(type, kCDOHParameterRepositoriesTypeKey);
	
	NSString *resource = kCDOHOrganizationRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHOrganizationResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, organization));

	[self getRepositoriesAtPath:path params:params pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoryContributors:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock) successBlock failure:(CDOHFailureBlock) failureBlock
{
	[self repositoryContributors:repository owner:owner anonymous:NO success:successBlock failure:failureBlock];
}

- (void)repositoryContributors:(NSString *)repo owner:(NSString *)owner anonymous:(BOOL)anonymous success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }

	NSDictionary *params = CDOHParametersDictionary([NSNumber numberWithBool:anonymous], @"anon");
	
	NSString *resource = kCDOHRepositoryContributorsResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, owner, repo));
	
	[self getUsersAtPath:path params:params pages:nil success:successBlock failure:failureBlock];
}

- (void)repositoryLanguages:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
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
	
	NSString *resource = kCDOHRepositoryLanguagesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, owner, repo));
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithResourceCreationBlock:resourceCreationBlock success:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner)]
				 failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Watched and Watching Repositories
- (void)repositoryWatchers:(NSString *)repo owner:(NSString *)owner pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *resource = kCDOHRepositoryWatchersResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, repo, owner));
	
	[self getUsersAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(login)) { return; }
	
	NSString *resource = kCDOHUserWatchedRepositoriesResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHUserResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, login));
	
	[self getRepositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)isUserWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedWatchedRepositoryPath, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client getPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)watchRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedWatchedRepositoryPath, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client putPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)stopWatchingRepository:(NSString *)repo owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *path = CDOHRelativeAPIPath(kCDOHAuthenticatedWatchedRepositoryPath, CDOHDictionaryOfVariableBindings(repo, owner));
	
	[self.client deletePath:path
				 parameters:nil
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Repository Forks
- (void)repositoryForks:(NSString *)repo owner:(NSString *)owner pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSString *resource = kCDOHRepositoryForksResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, repo, owner));
	
	[self getRepositoriesAtPath:path params:nil pages:pages success:successBlock failure:failureBlock];
}

- (void)forkRepository:(NSString *)repo owner:(NSString *)owner intoOrganization:(NSString *)intoOrganization success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verifyAuthenticatedUserIsSetOrFail:failureBlock]) { return; }
	if (!CDOHVerifyArgumentsNotNilOrThrowException(repo, owner)) { return; }
	
	NSDictionary *params = nil;
	if ([intoOrganization length] > 0) {
		params = [[NSDictionary alloc] initWithObjectsAndKeys:
				  intoOrganization, @"org",
				  nil];
	}
	
	NSString *resource = kCDOHRepositoryForksResource;
	NSString *path = CDOHRelativeAPIPath(kCDOHRepositoryResourcePathFormat, CDOHDictionaryOfVariableBindings(resource, repo, owner));
	
	[self.client postPath:path
			   parameters:params
				  success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repo, owner, intoOrganization)]
				  failure:[self standardFailureBlock:failureBlock]];
}


@end
