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
#import "NSString+ObjectiveHub.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"


#pragma mark CDOHAFNetwkringClient Private Interface
@interface CDOHAFNetworkingClient (/*Private*/)

#pragma mark - AFNetworking Client Instance
- (void)configureClient;
@property (copy) NSDictionary *defaultHeaders;


#pragma mark - Creating Errors From AFHTTPRequestOperations
+ (CDOHError *)errorFromFailedOperation:(AFHTTPRequestOperation *)operation;


#pragma mark - Object To Dictionary
+ (NSDictionary *)queryDictionaryFromObject:(id)object;


#pragma mark - 
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password;


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
@synthesize defaultHeaders = _defaultHeaders;


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
		
		_defaultHeaders = [defaultHeaders copy];
		
		Class clientClass = NSClassFromString(@"AFHTTPClient");
		_client = [[clientClass alloc] initWithBaseURL:baseURL];
	}
	
	return self;
}


- (AFHTTPClient *)client
{
	return _client;
}

- (void)setClient:(AFHTTPClient *)client
{
	if (_client != client) {
		_client = client;
		[self configureClient];
	}
}

- (void)configureClient
{
	Class requestClass = NSClassFromString(@"AFHTTPRequestOperation");
	
	[_client registerHTTPOperationClass:requestClass];
	[_client setParameterEncoding:AFJSONParameterEncoding];
	
	for (NSString *headerKey in self.defaultHeaders) {
		NSString *headerValue = [self.defaultHeaders objectForKey:headerKey];
		[_client setDefaultHeader:headerKey value:headerValue];
	}
}


#pragma mark - Remote Host Information
- (NSURL *)baseURL
{
	return ((AFHTTPClient *)self.client).baseURL;
}


#pragma mark - Request Controls
- (oneway void)suspend
{
	[((AFHTTPClient *)self.client).operationQueue setSuspended:YES];
}

- (oneway void)resume
{
	[((AFHTTPClient *)self.client).operationQueue setSuspended:NO];
}

- (oneway void)cancelAll
{
	[((AFHTTPClient *)self.client).operationQueue cancelAllOperations];
}


#pragma mark - Performing Requests
- (oneway void)requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	
	NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters username:username password:password];
	AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request success:[self standardSuccessBlockForReplyBlock:replyBlock] failure:[self standardFailureBlockForReplyBlock:replyBlock]];
	[self.client enqueueHTTPRequestOperation:operation];
}

- (oneway void)getPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	[self requestPath:path parameters:parameters method:@"GET" username:username password:password withReplyBlock:replyBlock];
}

- (oneway void)postPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSAssert(([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSArray class]]), @"The parameters argument may only be of the type NSArray or NSDictionary");
	[self requestPath:path parameters:parameters method:@"POST" username:username password:password withReplyBlock:replyBlock];
}

- (oneway void)putPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	[self requestPath:path parameters:parameters method:@"PUT" username:username password:password withReplyBlock:replyBlock];
}

- (oneway void)patchPath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	[self requestPath:path parameters:parameters method:@"PATCH" username:username password:password withReplyBlock:replyBlock];
}

- (oneway void)deletePath:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password withReplyBlock:(void (^)(CDOHNetworkClientReply *))replyBlock
{
	NSParameterAssert(path);
	NSParameterAssert(replyBlock);
	[self requestPath:path parameters:parameters method:@"DELETE" username:username password:password withReplyBlock:replyBlock];
}


#pragma mark - Standard Blocks
- (void (^)(AFHTTPRequestOperation *, NSError *))standardFailureBlockForReplyBlock:(CDOHNetworkClientReplyBlock)replyBlock
{
	return ^(AFHTTPRequestOperation *operation, NSError *__unused unusedError) {
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
	return ^(AFHTTPRequestOperation *operation, id responseObject) {
		NSDictionary *httpHeaders = [[operation response] allHeaderFields];
		CDOHNetworkClientReply *reply = nil;
		reply = [[CDOHNetworkClientReply alloc] initWithSuccessStatus:YES
															 response:responseObject
																error:nil
														  HTTPHeaders:httpHeaders];
		replyBlock(reply);
	};
}


#pragma mark - Object To Dictionary
+ (NSDictionary *)queryDictionaryFromObject:(id)object
{
	NSDictionary *queryDictionary = object;
	
	if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray *strings = [NSMutableArray arrayWithCapacity:[object count]];
		for (NSUInteger i = 0; i < [object count]; ++i) {
			[strings addObject:@""];
		}
		queryDictionary = [NSDictionary dictionaryWithObjects:strings forKeys:object];
	} else if ([object isKindOfClass:[NSString class]]) {
		queryDictionary = [NSDictionary dictionaryWithObject:@"" forKey:object];
	}
	
	return queryDictionary;
}


#pragma mark - 
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters username:(NSString *)username password:(NSString *)password
{
	NSMutableURLRequest *request = [self.client requestWithMethod:method path:path parameters:nil];
	
	if (![method isEqualToString:@"GET"] && ![method isEqualToString:@"HEAD"] && ![method isEqualToString:@"DELETE"]) {
		NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(((AFHTTPClient *)self.client).stringEncoding));
		[request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
		
		if (parameters) {
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
			[request setHTTPBody:jsonData];
		}
	}
	
	if ([username length] != 0 && [password length] != 0) {
		NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
		NSString *base64EncodedCredentials = [basicAuthCredentials cdoh_base64String];
		[request setValue:[@"Basic " stringByAppendingString:base64EncodedCredentials] forHTTPHeaderField:@"Authorization"];
	}
	
	return request;
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


@end
