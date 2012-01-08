//
//  CDOHClient.m
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

#import "CDOHClient.h"
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
/// The relative path for a user with login.
/// Takes one string;
/// - the login name of the user.
NSString *const kCDOHUserPathFormat					= @"/users/%@";
/// The relative path for an authenticated user.
NSString *const kCDOHUserAuthenticatedPath			= @"/user";
/// The relative path for the authenticated users emails.
NSString *const kCDOHUserEmailsPath					= @"/user/emails";
/// The relative path for the watchers of a repository.
/// Takes two strings;
/// - the first is the username of the repository owner,
/// - the second is the name of the repository.
NSString *const kCDOHRepositoryWatchersPath			= @"/repos/%@/%@/watchers";
/// The relative path for repositories watched by a user.
/// Takes one string;
/// - the login name of the user.
NSString *const kCDOHWatchedRepositoriesByUserPath	= @"/users/%@/watched";


#pragma mark - ObjectiveHub Generic Block Types
/// Block type for succesful requests.
typedef void (^CDOHInternalSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
/// Block type for failed requests.
typedef void (^CDOHInternalFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);


#pragma mark - Macro to Create Argument Arrays
/// Creates an NSArray object of the objects passed into it.
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


#pragma mark - Response Helpers
/// Create an error from a failed request operation.
- (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation;

/// Create a respone dictionary from an response.
- (NSDictionary *)responseDictionaryFromOperation:(AFHTTPRequestOperation *)operation;

/// Create a CDOHLinkRelationshipHeader object from a link string.
/// The link string should be of the following format:
/// `<https://api.github.com/resource?page=3&per_page=100>; rel="next"`
- (CDOHLinkRelationshipHeader *)linkRelationshipFromLinkString:(NSString *)linkString;

#pragma mark - Standard Blocks
#pragma mark |- Standard Error Block
/// The standard failure block.
///
- (CDOHInternalFailureBlock)standardFailureBlock:(CDOHFailureBlock)failureBlock;

#pragma mark |- Standard Success Blocks
/// The standard success block for requests which return no data.
- (CDOHInternalSuccessBlock)standardSuccessBlockWithNoData:(void (^)(void))successBlock;

/// The standard success block for requests returning a user.
- (CDOHInternalSuccessBlock)standardUserSuccessBlock:(void (^)(CDOHUser *user))successBlock;

/// The standard success block for requests returning an array of email
/// addresses.
- (CDOHInternalSuccessBlock)standardUserEmailSuccessBlock:(void (^)(NSArray *emails))successBlock;

/// The standard success block for requests returning an array of users.
- (CDOHInternalSuccessBlock)standardUserArraySuccessBlock:(void (^)(NSArray *users, NSDictionary *responseInfo))successBlock;

/// The standard success block for requests returning a repository.
- (CDOHInternalSuccessBlock)standardRepositorySuccessBlock:(void (^)(CDOHRepository * repository, NSDictionary *responseInfo))successBlock;

/// The standard success block for requests returning an array of repositories.
- (CDOHInternalSuccessBlock)standardRepositoryArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments;

@end



#pragma mark - ObjectiveHub Implementation
@implementation CDOHClient

#pragma mark - Synthesizing
@synthesize username = _username;
@synthesize password = _password;
@synthesize itemsPerPage = _itemsPerPage;
@synthesize rateLimit = _rateLimit;

@synthesize client = _client;
@synthesize JSONDecoder = _jsonDecoder;


#pragma mark - Initializing ObjectiveHub
- (id)init
{
	self = [super init];
	if (self) {
		_itemsPerPage			= kCDOHDefaultItemsPerPage;
		_rateLimit				= kCDOHDefaultRateLimit;
		
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


#pragma mark - Standard Blocks
- (CDOHInternalFailureBlock)standardFailureBlock:(CDOHFailureBlock)failureBlock
{
	return ^(AFHTTPRequestOperation *operation, __unused NSError *error) {
		if (failureBlock) {
			CDOHError *ohError = [self errorFromFailedOperation:operation];
			failureBlock(ohError);
		}
	};
}

- (CDOHInternalSuccessBlock)standardSuccessBlockWithNoData:(void (^)(void))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, __unused id responseObject) {
		if (successBlock) {
			successBlock();
		}
	};
}

- (CDOHInternalSuccessBlock)standardUserSuccessBlock:(void (^)(CDOHUser *user))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			CDOHUser *user = nil;
			if (responseObject && [responseObject length] > 0) {
				NSDictionary *userDict = [self.JSONDecoder objectWithData:responseObject];
//TODO: Should the library call the failure block instead here as the library can not understand the returrend data (wrong format)?
				user = [[CDOHUser alloc] initWithDictionary:userDict];
			}
			
			successBlock(user);
		}
	};
}

- (CDOHInternalSuccessBlock)standardUserArraySuccessBlock:(void (^)(NSArray *users, NSDictionary *responseInfo))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			NSArray *users = nil;
			NSDictionary *responseInfo = nil;
			
			if (responseObject && [responseObject length] > 0) {
				NSArray *userDicts = [self.JSONDecoder objectWithData:responseObject];
//TODO: Should the library call the failure block instead here as the library can not understand the returrend data (wrong format)?
				
				if ([userDicts isKindOfClass:[NSArray class]]) {
					CDOHUser *user = nil;
					NSMutableArray *mutableUsers = [[NSMutableArray alloc] initWithCapacity:[userDicts count]];
					for (NSDictionary *userDict in userDicts) {
						if ([userDict isKindOfClass:[NSDictionary class]]) {
							user = [[CDOHUser alloc] initWithDictionary:userDict];
							[mutableUsers addObject:user];
						}
					}
					users = mutableUsers;
					
					responseInfo = [self responseDictionaryFromOperation:operation];
					
					successBlock(users, responseInfo);
				} else {
					[NSException raise:NSInternalInconsistencyException format:@"The using app should be notified that the response was incorrect so that we can gracefully handle the problem."];
				}
			}
		}
	};
}

- (CDOHInternalSuccessBlock)standardUserEmailSuccessBlock:(void (^)(NSArray *emails))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			NSArray *emails = nil;
			if (responseObject && [responseObject length] > 0) {
				emails = [self.JSONDecoder objectWithData:responseObject];
			}
			
			successBlock(emails);
		}
	};
}

- (CDOHInternalSuccessBlock)standardRepositorySuccessBlock:(void (^)(CDOHRepository *, NSDictionary *))successBlock
{
	return ^(AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			if (responseObject && [responseObject length] > 0) {
				NSDictionary *repoDict = [self.JSONDecoder objectWithData:responseObject];
				
				if ([repoDict isKindOfClass:[NSDictionary class]]) {
					CDOHRepository *repo = [[CDOHRepository alloc] initWithDictionary:repoDict];
					
					NSDictionary *responseInfo = [self responseDictionaryFromOperation:operation];
					
					successBlock(repo, responseInfo);
				} else {
					[NSException raise:NSInternalInconsistencyException format:@"The using app should be notified that the response was incorrect so that we can gracefully handle the problem."];
				}
			}
		}
	};
}

- (CDOHInternalSuccessBlock)standardRepositoryArraySuccessBlock:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock action:(SEL)action arguments:(NSArray *)arguments
{
	return ^(AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			if (responseObject && [responseObject length] > 0) {
				id repoDicts = [self.JSONDecoder objectWithData:responseObject];
				
				if ([repoDicts isKindOfClass:[NSArray class]]) {
					NSMutableArray *reposArray = [[NSMutableArray alloc] initWithCapacity:[repoDicts count]];
					
					for (id repoDict in repoDicts) {
						if ([repoDict isKindOfClass:[NSDictionary class]]) {
							CDOHRepository *repo = [[CDOHRepository alloc] initWithDictionary:repoDict];
							[reposArray addObject:repo];
						}
					}
					
					NSDictionary *responseInfoDict = [self responseDictionaryFromOperation:operation];
					NSArray *links = [responseInfoDict objectForKey:kCDOHResponseHeaderLinkKey];
					
					CDOHResponse *response = [[CDOHResponse alloc] initWithResource:reposArray
																			 target:self
																			 action:action
																	   successBlock:successBlock failureBlock:failureBlock
																			  links:links
																		  arguments:arguments];
					successBlock(response);
				} else if (failureBlock) {
					NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
											  operation, @"operation",
											  responseObject, kCDOHErrorUserInfoResponseDataKey,
											  nil];
					CDOHError *error = [[CDOHError alloc] initWithDomain:kCDOHErrorDomain code:kCDOHErrorCodeResponseObjectNotOfExpectedType userInfo:userInfo];
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


#pragma mark - Response Helpers
- (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation
{
	NSDictionary *httpHeaders = [operation.response allHeaderFields];
	NSInteger httpStatus = [operation.response statusCode];
	NSData *responseData = [operation responseData];
	
	CDOHError *ohError = [[CDOHError alloc] initWithHTTPHeaders:httpHeaders HTTPStatus:httpStatus responseBody:responseData];
	
	return ohError;
}

- (NSDictionary *)responseDictionaryFromOperation:(AFHTTPRequestOperation *)operation
{
	NSDictionary *allHeaders = [[operation response] allHeaderFields];
	
	id rateLimitLimit		= [allHeaders objectForKey:kCDOHResponseHeaderXRateLimitLimitKey];
	id rateLimitRemaining	= [allHeaders objectForKey:kCDOHResponseHeaderXRateLimitRemainingKey];
	id location				= [allHeaders objectForKey:kCDOHResponseHeaderLocationKey];
	NSString *link			= [allHeaders objectForKey:kCDOHResponseHeaderLinkKey];
	
	rateLimitLimit			= (rateLimitLimit		? rateLimitLimit		: [NSNull null]);
	rateLimitRemaining		= (rateLimitRemaining	? rateLimitRemaining	: [NSNull null]);
	location				= (location				? location				: [NSNull null]);

	id links = nil;
	if ([link length] > 0) {
		NSArray *linkComps = [link componentsSeparatedByString:kCDOHResponseHeaderLinkSeparatorKey];
		links = [[NSMutableArray alloc] initWithCapacity:[linkComps count]];
		
		// Link format: 
		// <https://api.github.com/resource?page=10>; rel="__name__"
		for (NSString *singleLink in linkComps) {
			CDOHLinkRelationshipHeader *linkRel = [self linkRelationshipFromLinkString:singleLink];
			[links addObject:linkRel];
		}
	} else {
		links = [NSNull null];
	}
	
	NSDictionary *responseInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
								  rateLimitLimit,		kCDOHResponseHeaderXRateLimitLimitKey,
								  rateLimitRemaining,	kCDOHResponseHeaderXRateLimitRemainingKey,
								  links,				kCDOHResponseHeaderLinkKey,
								  location,				kCDOHResponseHeaderLocationKey,
								  nil];
	
	return responseInfo;
}

- (CDOHLinkRelationshipHeader *)linkRelationshipFromLinkString:(NSString *)linkString
{
	CDOHLinkRelationshipHeader *link = nil;
	NSArray *singleLinkComp = [linkString componentsSeparatedByString:@">; rel=\""];
	
	if ([singleLinkComp count] == 2) {
		NSString *linkUrlString = [singleLinkComp objectAtIndex:0];
		linkUrlString = [linkUrlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *linkName = [singleLinkComp objectAtIndex:1];
		linkName = [linkName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if ([linkUrlString length] > 2 && [linkName length] > 2) {
			linkUrlString = [linkUrlString substringFromIndex:1];
			NSURL *linkUrl = [[NSURL alloc] initWithString:linkUrlString];
			linkName = [linkName substringToIndex:[linkName length] - 1];
			
			link = [[CDOHLinkRelationshipHeader alloc] initWithName:linkName URL:linkUrl];
		}
	}
	
	return link;
}


#pragma mark - Getting and Updating Users
- (void)userWithLogin:(NSString *)login success:(void (^)(CDOHUser *user))successBlock failure:(CDOHFailureBlock)failureBlock
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
				 success:[self standardUserSuccessBlock:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)user:(void (^)(CDOHUser *user))successBlock failure:(CDOHFailureBlock)failureBlock
{
	return [self userWithLogin:self.username success:successBlock failure:failureBlock];
}

- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(void (^)(CDOHUser *))successBlock failure:(CDOHFailureBlock)failureBlock
{
	NSString *patchPath = kCDOHUserAuthenticatedPath;
	[self.client patchPath:patchPath
				parameters:dictionary
				   success:[self standardUserSuccessBlock:successBlock]
				   failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Getting and Modyfing User Emails
- (void)userEmails:(void (^)(NSArray *))successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	
	NSString *getPath = kCDOHUserEmailsPath;
	[self.client getPath:getPath
			  parameters:nil
				 success:[self standardUserEmailSuccessBlock:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)addUserEmails:(NSArray *)emails success:(void (^)(NSArray *))successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!emails) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"emails"];
	}
	
	NSString *postPath = kCDOHUserEmailsPath;
	[self.client postPath:postPath
			   parameters:emails
				  success:[self standardUserEmailSuccessBlock:successBlock]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)deleteUserEmails:(NSArray *)emails success:(void (^)(void))successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!emails) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"emails"];
	}
	
	NSString *deletePath = kCDOHUserEmailsPath;
	[self.client deletePath:deletePath
				 parameters:emails
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}


#pragma mark - Getting Watched and Watching Repositories
- (void)watchersOfRepository:(NSString *)repositoryName repositoryOwner:(NSString *)repositoryOwner success:(void (^)(NSArray *, NSDictionary *))successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!repositoryName || !repositoryOwner) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@, %@) supplied were invalid (nil)", @"repositoryName", @"repositoryOwner"];
	}
	
	NSString *watchersPath = [[NSString alloc] initWithFormat:kCDOHRepositoryWatchersPath, repositoryOwner, repositoryName];
	[self.client getPath:watchersPath
			  parameters:nil
				 success:[self standardUserArraySuccessBlock:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)repositoriesWatchedByUser:(NSString *)login pages:(NSIndexSet *)pages success:(CDOHResponseBlock)successBlock failure:(CDOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!login) {
		[NSException raise:NSInvalidArgumentException format:@"One or more arguments (%@) supplied were invalid (nil)", @"login"];
	}
	
	if ([pages count] == 0) {
		pages = [[NSIndexSet alloc] initWithIndex:1];
	}
	
	NSString *watchedReposPath = [[NSString alloc] initWithFormat:kCDOHWatchedRepositoriesByUserPath, login];
	[pages enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *__unused stop) {
		NSDictionary *paramDict = [self standardRequestParameterDictionaryForPage:idx];
		
		[self.client getPath:watchedReposPath
				  parameters:paramDict
					 success:[self standardRepositoryArraySuccessBlock:successBlock failure:failureBlock action:_cmd arguments:CDOHArrayOfArguments(login)]
					 failure:[self standardFailureBlock:failureBlock]];
	}];
}

@end
