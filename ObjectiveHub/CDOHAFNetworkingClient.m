//
//  CDOHAFNetworkingClient.m
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

#import "CDOHAFNetworkingClient.h"
#import "CDOHTypes.h"

#import "CDOHNetworkClientReply.h"
#import "CDOHError.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"


#pragma mark CDOHAFNetwkringClient Private Interface
@interface CDOHAFNetworkingClient (/*Private*/)

#pragma mark - AFNetworking Client Instance
@property (strong) AFHTTPClient *client;


#pragma mark - Authorization Header
- (void)setAuthHeaderAndIncrementCounterWithUsername:(NSString *)username password:(NSString *)password;
- (void)incrementAuthHeadersBalanceCount;
- (void)decrementAuthHeadersBalanceCount;


#pragma mark - Creating Errors From AFHTTPRequestOperations
+ (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation;


#pragma mark - Standard Blocks
- (void (^)(AFHTTPRequestOperation *, id))standardSuccessBlockForReplyBlock:(void (^)(CDOHNetworkClientReply *reply))replyBlock;
- (void (^)(AFHTTPRequestOperation *, NSError *))standardFailureBlockForReplyBlock:(void (^)(CDOHNetworkClientReply *reply))replyBlock;

@end



#pragma mark - CDOHAFNetworkingClient Implementation
@implementation CDOHAFNetworkingClient {
	NSUInteger _authHeadersBalanceCount;
}

#pragma mark - AFNetworking Client Instance
@synthesize client = _client;


#pragma mark - Adapter Dependencies
+ (BOOL)checkDependencies
{
	return (NSClassFromString(@"AFHTTPClient") != nil);
}


#pragma mark - Creating and Initializing Network Clients
- (instancetype)initWithBaseURL:(NSURL *)baseURL defaultHeaders:(NSDictionary *)defaultHeaders
{
	self = [super init];
	if (self) {
		_authHeadersBalanceCount = 0;
		
		_client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
		[_client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
		[_client setParameterEncoding:AFJSONParameterEncoding];
		
		for (NSString *headerKey in defaultHeaders) {
			NSString *headerValue = [defaultHeaders objectForKey:headerKey];
			[_client setDefaultHeader:headerKey value:headerValue];
		}
	}
	
	return self;
}


#pragma mark - Remote Host Information
- (NSURL *)baseURL
{
	return self.client.baseURL;
}


#pragma mark - Request Controls
- (oneway void)suspend
{
	[self.client.operationQueue setSuspended:YES];
}

- (oneway void)resume
{
	[self.client.operationQueue setSuspended:NO];
}

- (oneway void)cancelAll
{
	[self.client.operationQueue cancelAllOperations];
}


#pragma mark - Performing Requests
- (oneway void)getPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	[self setAuthHeaderAndIncrementCounterWithUsername:username password:password];
	
	[self.client getPath:path
			  parameters:parameters
				 success:[self standardSuccessBlockForReplyBlock:replyBlock]
				 failure:[self standardFailureBlockForReplyBlock:replyBlock]];
}

- (oneway void)postPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	[self setAuthHeaderAndIncrementCounterWithUsername:username password:password];
	
	[self.client postPath:path
			   parameters:parameters
				  success:[self standardSuccessBlockForReplyBlock:replyBlock]
				  failure:[self standardFailureBlockForReplyBlock:replyBlock]];
}

- (oneway void)putPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	[self setAuthHeaderAndIncrementCounterWithUsername:username password:password];
	
	[self.client putPath:path
			  parameters:parameters
				 success:[self standardSuccessBlockForReplyBlock:replyBlock]
				 failure:[self standardFailureBlockForReplyBlock:replyBlock]];
}

// TODO: Send pull request to AFNetworking/AFNetworking with patchPath:parameters:success:failure.
// TODO: Send pull request to AFNetworking/AFNetworking with generic(ish) parameters.
- (oneway void)patchPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	[self setAuthHeaderAndIncrementCounterWithUsername:username password:password];
	
	[self.client patchPath:path
				parameters:parameters
				   success:[self standardSuccessBlockForReplyBlock:replyBlock]
				   failure:[self standardFailureBlockForReplyBlock:replyBlock]];
}

- (oneway void)deletePath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(void (^)(CDOHNetworkClientReply *))replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	[self setAuthHeaderAndIncrementCounterWithUsername:username password:password];
	
	[self.client deletePath:path
			   parameters:parameters
				  success:[self standardSuccessBlockForReplyBlock:replyBlock]
				  failure:[self standardFailureBlockForReplyBlock:replyBlock]];
}


#pragma mark - Standard Blocks
- (void (^)(AFHTTPRequestOperation *, NSError *))standardFailureBlockForReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	__weak CDOHAFNetworkingClient *blockSelf = self;
	return ^(AFHTTPRequestOperation *operation, NSError *__unused unusedError) {
		[blockSelf decrementAuthHeadersBalanceCount];
		
		NSDictionary *httpHeaders = [[operation response] allHeaderFields];
		CDOHError *error = [[self class] errorFromFailedOperation:operation];
		
		CDOHNetworkClientReply *reply = nil;
		reply = [[CDOHNetworkClientReply alloc] initWithSuccessStatus:NO
															 response:nil
																error:error
														  HTTPHeaders:httpHeaders];
		
		replyBlock(reply);
	};
}

- (void (^)(AFHTTPRequestOperation *, id))standardSuccessBlockForReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	__weak CDOHAFNetworkingClient *blockSelf = self;
	return ^(AFHTTPRequestOperation *operation, id responseObject) {
		[blockSelf decrementAuthHeadersBalanceCount];
		
		NSDictionary *httpHeaders = [[operation response] allHeaderFields];
		
		CDOHNetworkClientReply *reply = nil;
		reply = [[CDOHNetworkClientReply alloc] initWithSuccessStatus:YES
															 response:responseObject
																error:nil
														  HTTPHeaders:httpHeaders];
		
		replyBlock(reply);
	};
}


#pragma mark - Creating Errors From AFHTTPRequestOperations
+ (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation
{
	NSDictionary *httpHeaders = [operation.response allHeaderFields];
	NSInteger httpStatus = [operation.response statusCode];
	NSData *responseData = [operation responseData];
	
	CDOHError *ohError = [[CDOHError alloc] initWithHTTPHeaders:httpHeaders HTTPStatus:httpStatus responseBody:responseData];
	
	return ohError;
}


#pragma mark - Authorization Header
- (void)setAuthHeaderAndIncrementCounterWithUsername:(NSString *)username password:(NSString *)password
{
	[self incrementAuthHeadersBalanceCount];
	if ([username length] > 0 && [password length] > 0) {
		[self.client setAuthorizationHeaderWithUsername:username password:password];
	}
}

- (void)incrementAuthHeadersBalanceCount
{
	@synchronized(self) {
		_authHeadersBalanceCount++;
	}
}

- (void)decrementAuthHeadersBalanceCount
{
	@synchronized(self) {
		if (_authHeadersBalanceCount > 0) {
			_authHeadersBalanceCount--;
			
			if (_authHeadersBalanceCount == 0) {
				[self.client clearAuthorizationHeader];
			}
		} else {
			_authHeadersBalanceCount = 0;
			
			NSAssert(NO, @"Unbalanced auth headers balance count, already 0 but decremented (i.e. over-decremented).");
		}
	}
}


@end
