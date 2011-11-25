//
//  ObjectiveHub.m
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

#import "ObjectiveHub.h"
#import "CDOHLibraryVersion.h"

#import "AFNetworking.h"
#import "JSONKit.h"

#import "CDOHError.h"

#import "CDOHUser.h"
#import "CDOHUserPrivate.h"


#pragma mark Constants
/// The base URI for the GitHub API
NSString *const kFGOHGitHubBaseAPIURIString	= @"https://api.github.com";

/// A date format string for the ISO 8601 format
NSString *const kFGOHDateFormat				= @"YYYY-MM-DDTHH:MM:SSZ";

/// ObjectiveHub User Agent Format String
NSString *const kFGOHUserAgentFormat		= @"ObjectiveHub/%@";

#pragma mark - GitHub Mime Types
/// Mime type for getting the default type of data as JSON.
NSString *const kFGOHGitHubMimeGenericJSON	= @"application/vnd.github.beta+json";
/// Mime type for getting the raw data as JSON.
NSString *const kFGOHGitHubMimeRawJSON		= @"application/vnd.github.beta.raw+json";
/// Mime type for getting the text only representation of the data, as JSON.
NSString *const kFGOHGitHubMimeTextInJSON	= @"application/vnd.github.beta.text+json";
/// Mime type for getting the resource rendered as HTML as JSON.
NSString *const kFGOHGitHubMimeHtmlInJSON	= @"application/vnd.github.beta.html+json";
/// Mime type for getting raw, text and html versions of a resource in the same
/// response as JSON.
NSString *const kFGOHGitHubMimeFullInJSON	= @"application/vnd.github.beta.full+json";
/// Mime type for getting raw blob data (**not** wrapped in a JSON object).
NSString *const kFGOHGitHubMimeRaw			= @"application/vnd.github.beta.raw";


#pragma mark - GitHub Relative API Path (Formats)
/// The relative path for a user with login.
/// Takes one string with the login name.
NSString *const kFGOHUserPathFormat					= @"/users/%@";
/// The relative path for an authenticated user.
NSString *const kFGOHUserAuthenticatedPath			= @"/user";
/// The relative path for the authenticated users emails.
NSString *const kFGOHUserEmailsPath					= @"/user/emails";


#pragma mark - ObjectiveHub Generic Block Types
/// Block type for succesful requests.
typedef void (^FGOHInternalSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
/// Block type for failed requests.
typedef void (^FGOHInternalFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);


#pragma mark - ObjectiveHub Private Interface
@interface ObjectiveHub ()


#pragma mark - HTTP Client
/// The HTTP client used to communicate with GitHub internally.
@property (readonly, strong) AFHTTPClient *client;


#pragma mark - Creating Errors
/// Create an error from a failed request operation.
- (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation;


#pragma mark - Standard Blocks
#pragma mark |- Standard Error Block
/// The standard failure block.
///
- (FGOHInternalFailureBlock)standardFailureBlock:(FGOHFailureBlock)failureBlock;

#pragma mark |- Standard Success Blocks
/// The standard success block for requests which return no data.
- (FGOHInternalSuccessBlock)standardSuccessBlockWithNoData:(void (^)(void))successBlock;

/// The standard success block for requests returning a user.
- (FGOHInternalSuccessBlock)standardUserSuccessBlock:(void (^)(CDOHUser *user))successBlock;

/// The standard success block for requests returning an array of email
/// addresses.
- (FGOHInternalSuccessBlock)standardUserEmailSuccessBlock:(void (^)(NSArray *emails))successBlock;


@end



#pragma mark - ObjectiveHub Implementation
@implementation ObjectiveHub

#pragma mark - Synthesizing
@synthesize username = _username;
@synthesize password = _password;
@synthesize defaultItemsPerPage = _defaultItemsPerPage;
@synthesize rateLimit = _rateLimit;

@synthesize client = _client;


#pragma mark - Initializing ObjectiveHub
- (id)init
{
	self = [super init];
	if (self) {
		_defaultItemsPerPage	= kObjectiveHubDefaultItemsPerPage;
		_rateLimit				= kObjectiveHubDefaultRateLimit;
		
		_client					= [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kFGOHGitHubBaseAPIURIString]];
		[_client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
		[_client setParameterEncoding:AFJSONParameterEncoding];
		[_client setDefaultHeader:@"Accept" value:kFGOHGitHubMimeGenericJSON];
		[_client setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:kFGOHUserAgentFormat, kCDOHLibraryVersion]];
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
	return [NSString stringWithFormat:@"<%@: %p { github API URI = %@, username is set = %@, password is set = %@ }>", [self class], self, kFGOHGitHubBaseAPIURIString, (self.username ? @"YES" : @"NO"), (self.password ? @"YES" : @"NO")];
}


#pragma mark - Configuration Options
- (NSUInteger)defaultItemsPerPage
{
	return _defaultItemsPerPage;
}

- (void)setDefaultItemsPerPage:(NSUInteger)defaultItemsPerPage
{
	NSAssert(defaultItemsPerPage >= 1 && defaultItemsPerPage <= 100,
			 @"The defaultItemsPerPage must be between (including) 1 and 100");
	
	if (_defaultItemsPerPage != defaultItemsPerPage) {
		_defaultItemsPerPage = defaultItemsPerPage;
	}
}


#pragma mark - Standard Blocks
- (FGOHInternalFailureBlock)standardFailureBlock:(FGOHFailureBlock)failureBlock
{
	return ^(AFHTTPRequestOperation *operation, __unused NSError *error) {
		if (failureBlock) {
			CDOHError *ohError = [self errorFromFailedOperation:operation];
			failureBlock(ohError);
		}
	};
}

- (FGOHInternalSuccessBlock)standardSuccessBlockWithNoData:(void (^)(void))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, __unused id responseObject) {
		if (successBlock) {
			successBlock();
		}
	};
}

- (FGOHInternalSuccessBlock)standardUserSuccessBlock:(void (^)(CDOHUser *user))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			CDOHUser *user = nil;
			if (responseObject && [responseObject length] > 0) {
				NSDictionary *userDict = [responseObject objectFromJSONData];
				user = [[CDOHUser alloc] initWithDictionary:userDict];
			}
			
			successBlock(user);
		}
	};
}

- (FGOHInternalSuccessBlock)standardUserEmailSuccessBlock:(void (^)(NSArray *emails))successBlock
{
	return ^(__unused AFHTTPRequestOperation *operation, id responseObject) {
		if (successBlock) {
			NSArray *emails = nil;
			if (responseObject && [responseObject length] > 0) {
				emails = [responseObject objectFromJSONData];
			}
			
			successBlock(emails);
		}
	};
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


#pragma mark - Getting and Updating Users
- (void)userWithLogin:(NSString *)login success:(void (^)(CDOHUser *user))successBlock failure:(FGOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	if (!login) {
		[NSException raise:NSInvalidArgumentException format:@"The login argument is not set."];
	}

	NSString *getPath = [[NSString alloc] initWithFormat:kFGOHUserPathFormat, login];
	[self.client getPath:getPath
			  parameters:nil
				 success:[self standardUserSuccessBlock:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)user:(void (^)(CDOHUser *user))successBlock failure:(FGOHFailureBlock)failureBlock
{
	if (!self.username || !self.password) {
		[NSException raise:NSInternalInconsistencyException format:@"Username or password not set."];
	}
	
	return [self userWithLogin:self.username success:successBlock failure:failureBlock];
}

- (void)updateUserWithDictionary:(NSDictionary *)dictionary success:(void (^)(CDOHUser *))successBlock failure:(FGOHFailureBlock)failureBlock
{	
	if (!self.username || !self.password) {
		[NSException raise:NSInternalInconsistencyException format:@"Username or password not set."];
	}
	
	NSString *patchPath = kFGOHUserAuthenticatedPath;
	[self.client patchPath:patchPath
				parameters:dictionary
				   success:[self standardUserSuccessBlock:successBlock]
				   failure:[self standardFailureBlock:failureBlock]];
}

- (void)userEmails:(void (^)(NSArray *))successBlock failure:(FGOHFailureBlock)failureBlock
{
	if (!successBlock && !failureBlock) {
		return;
	}
	
	NSString *getPath = kFGOHUserEmailsPath;
	
	[self.client getPath:getPath
			  parameters:nil
				 success:[self standardUserEmailSuccessBlock:successBlock]
				 failure:[self standardFailureBlock:failureBlock]];
}

- (void)addUserEmails:(NSArray *)emails success:(void (^)(NSArray *))successBlock failure:(FGOHFailureBlock)failureBlock
{
	if (!emails) {
		return;
	}
	
	NSString *postPath = kFGOHUserEmailsPath;
	[self.client postPath:postPath
			   parameters:emails
				  success:[self standardUserEmailSuccessBlock:successBlock]
				  failure:[self standardFailureBlock:failureBlock]];
}

- (void)deleteUserEmails:(NSArray *)emails success:(void (^)(void))successBlock failure:(FGOHFailureBlock)failureBlock
{
	if (!emails) {
		return;
	}
	
	NSString *deletePath = kFGOHUserEmailsPath;
	[self.client deletePath:deletePath
				 parameters:emails
					success:[self standardSuccessBlockWithNoData:successBlock]
					failure:[self standardFailureBlock:failureBlock]];
}

@end
