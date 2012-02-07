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

/// A date format string for the ISO 8601 format
NSString *const kCDOHDateFormat				= @"YYYY-MM-DDTHH:MM:SSZ";

/// ObjectiveHub User Agent Format String
NSString *const kCDOHUserAgentFormat		= @"ObjectiveHub/%@";

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


#pragma mark - GitHub Relative API Path (Formats)
#pragma mark |- Users
/// The relative path format for a user with login.
/// Takes one string;
/// 1. the login name of the user.
NSString *const kCDOHUserPathFormat							= @"/users/%@";
/// The relative path for an authenticated user.
NSString *const kCDOHUserAuthenticatedPath					= @"/user";
/// The relative path for the authenticated users emails.
NSString *const kCDOHUserEmailsPath							= @"/user/emails";
#pragma mark |- User Repositories
/// The relative path for the authenticated users repositories.
NSString *const kCDOHUserRepositoriesPath					= @"/user/repos";
/// The relative path format for a given users repositories.
/// Takes one string:
/// 1. the login of the user.
NSString *const kCDOHUserRepositoriesPathFormat				= @"/users/%@/repos";
/// The relative path format for a given repository.
/// Takes two strings:
/// 1. the login of the repository owner,
/// 2. the name of the repository.
NSString *const kCDOHRepositoryPathFormat					= @"/repos/%@/%@";
#pragma mark |- Watched Repositories
/// The relative path format for the watchers of a repository.
/// Takes two strings;
/// 1. the login of the repository owner,
/// 2. the name of the repository.
NSString *const kCDOHRepositoryWatchersPathFormat			= @"/repos/%@/%@/watchers";
/// The relative path for repositories watched by a user.
/// Takes one string;
/// 1. the login name of the user.
NSString *const kCDOHWatchedRepositoriesByUserPathFormat	= @"/users/%@/watched";
/// The relative path for a specific repository watched by the authenticated
/// user.
/// Takes two strings;
/// 1. the login of the repository owner,
/// 2. the name of the repository.
NSString *const kCDOHUserWatchedRepositoryPathFormat		= @"/user/watched/%@/%@";

#pragma mark |- Organizations

#pragma mark |- Organization Repositories
/// The relative path format for a given organizations repositories.
/// Takes one string:
/// 1. the name of the organization.
NSString *const kCDOHOrganizationRepositoriesPathFormat		= @"/orgs/%@/repos";


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
- (BOOL)verfiyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock;


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
@implementation CDOHClient

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
		_itemsPerPage					= kCDOHDefaultItemsPerPage;
		
		_client					= [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kCDOHGitHubBaseAPIURIString]];
		[_client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
		[_client setParameterEncoding:AFJSONParameterEncoding];
		[_client setDefaultHeader:@"Accept" value:kCDOHGitHubMimeGenericJSON];
		[_client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:kCDOHUserAgentFormat, kCDOHLibraryVersion]];

		_jsonDecoder			= [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
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
	if (username != _username) {
		_username = username;
		
		[_client setAuthorizationHeaderWithUsername:_username password:_password];
	}
}

- (NSString *)username
{
	return _username;
}

- (void)setPassword:(NSString *)password
{
	if (password != _password) {
		_password = password;
		
		[_client setAuthorizationHeaderWithUsername:_username password:_password];
	}
}

- (NSString *)password
{
	return _password;
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

- (BOOL)verfiyAuthenticatedUserIsSetOrFail:(CDOHFailureBlock)failureBlock
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
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!login) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"login"];
	}

	NSString *getPath = [[NSString alloc] initWithFormat:kCDOHUserPathFormat, login];
	[self.client getPath:getPath
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)user:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	
	return [self userWithLogin:self.username success:successBlock failure:failureBlock];
}

- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!dictionary || [dictionary count] == 0) {
		return;
	}
	
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


	NSString *patchPath = kCDOHUserAuthenticatedPath;
	[self.client patchPath:patchPath
				parameters:params
				   success:[self standardUserSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(dictionary)]
				   failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - User Emails
- (void)userEmails:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	
	NSString *getPath = kCDOHUserEmailsPath;
	[self.client getPath:getPath
			  parameters:nil
				 success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:nil]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)addUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!emails) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"emails"];
	}
	
	NSString *postPath = kCDOHUserEmailsPath;
	[self.client postPath:postPath
			   parameters:emails
				  success:[self standardUserEmailSuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(emails)]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)deleteUserEmails:(NSArray *)emails success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!emails) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"emails"];
	}
	
	NSString *deletePath = kCDOHUserEmailsPath;
	[self.client deletePath:deletePath
				 parameters:emails
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Repositories
- (void)repository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!repository || !owner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repository", @"owner"];
	}
	
	NSString *path = [[NSString alloc] initWithFormat:kCDOHRepositoryPathFormat, owner, repository];
	[self.client getPath:path
			  parameters:nil
				 success:[self standardRepositorySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repository, owner)]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)repositories:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!type) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"type"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:1], nil];
	}
	
	for (NSNumber *idxNum in pages) {
		NSUInteger idx = [idxNum unsignedIntegerValue];
		NSMutableDictionary *params = [self standardRequestParameterDictionaryForPage:idx];
		[params setObject:type forKey:kCDOHParameterRepositoriesTypeKey];
		[self.client getPath:kCDOHUserRepositoriesPath
				  parameters:params
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(type)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}

- (void)repositoriesForUser:(NSString *)login type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!type || !login) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"login", @"type"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:1], nil];
	}
	
	NSString *path = [NSString stringWithFormat:kCDOHUserRepositoriesPathFormat, login];
	
	NSUInteger idx;
	NSMutableDictionary *params = nil;
	for (NSNumber *idxNum in pages) {
		idx = [idxNum unsignedIntegerValue];
		params = [self standardRequestParameterDictionaryForPage:idx];
		[params setObject:type forKey:kCDOHParameterRepositoriesTypeKey];
	
		[self.client getPath:path
				  parameters:params
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login, type)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}

- (void)repositoriesForOrganization:(NSString *)organization type:(NSString *)type pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!type || !organization) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"login", @"type"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:1], nil];
	}
	
	NSString *path = [NSString stringWithFormat:kCDOHOrganizationRepositoriesPathFormat, organization];
	
	NSUInteger idx;
	NSMutableDictionary *params = nil;
	for (NSNumber *idxNum in pages) {
		idx = [idxNum unsignedIntegerValue];
		params = [self standardRequestParameterDictionaryForPage:idx];
		[params setObject:type forKey:kCDOHParameterRepositoriesTypeKey];
		
		[self.client getPath:path
				  parameters:params
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(organization, type)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}


#pragma mark - Watched and Watching Repositories
- (void)watchersOfRepository:(NSString *)repository owner:(NSString *)owner pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!repository || !owner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repository", @"owner"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:1], nil];
	}
	
	NSString *watchersPath = [[NSString alloc] initWithFormat:kCDOHRepositoryWatchersPathFormat, owner, repository];
	for (NSNumber *idxNum in pages) {
		NSUInteger idx = [idxNum unsignedIntegerValue];
		NSDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		
		[self.client getPath:watchersPath
				  parameters:paramDict
					 success:[self standardUserArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(repository, owner)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}

- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSArray *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!login) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"login"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:1], nil];
	}
	
	NSString *watchedReposPath = [[NSString alloc] initWithFormat:kCDOHWatchedRepositoriesByUserPathFormat, login];
	for (NSNumber *idxNum in pages) {
		NSUInteger idx = [idxNum unsignedIntegerValue];
		NSDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		
		[self.client getPath:watchedReposPath
				  parameters:paramDict
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login)]
					 failure:[self standardFailureBlock:failureBlock]];
	}
}

- (void)isUserWatchingRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!repository || !owner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repository", @"owner"];
	}
	
	NSString *path = [[NSString alloc] initWithFormat:kCDOHUserWatchedRepositoryPathFormat, owner, repository];
	[self.client getPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)watchRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!repository || !owner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repository", @"owner"];
	}
	
	NSString *path = [[NSString alloc] initWithFormat:kCDOHUserWatchedRepositoryPathFormat, owner, repository];
	[self.client putPath:path
			  parameters:nil
				 success:[self standardSuccessBlockWithNoData:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)stopWatchingRepository:(NSString *)repository owner:(NSString *)owner success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (![self verfiyAuthenticatedUserIsSetOrFail:failureBlock]) {
		return;
	}
	if (!repository || !owner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repository", @"owner"];
	}
	
	NSString *path = [[NSString alloc] initWithFormat:kCDOHUserWatchedRepositoryPathFormat, owner, repository];
	[self.client deletePath:path
				 parameters:nil
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


@end
