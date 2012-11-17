//
//  CDOHError.m
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

#import "CDOHError.h"


#pragma mark CDOHError User Info Dictionary Default Keys
NSString *const kCDOHErrorUserInfoHTTPHeadersKey			= @"httpHeaders";
NSString *const kCDOHErrorUserInfoResponseDataKey			= @"responseData";
NSString *const kCDOHErrorUserInfoOriginalErrorKey			= @"originalError";


#pragma mark - ObjectiveHub Error Domain
NSString *const kCDOHErrorDomain							= @"com.fruitisgood.objectivehub.error";


#pragma mark - CDOHError Implementation
@implementation CDOHError

#pragma mark - Initializing an CDOHError Instance
- (id)initWithHTTPHeaders:(NSDictionary *)httpHeaders HTTPStatus:(NSInteger)httpStatus responseBody:(NSData *)responseBody
{
	self = [self initWithHTTPHeaders:httpHeaders HTTPStatus:httpStatus responseBody:responseBody originalError:nil];
	return self;
}

- (id)initWithHTTPHeaders:(NSDictionary *)httpHeaders HTTPStatus:(NSInteger)httpStatus responseBody:(NSData *)responseBody originalError:(NSError *)error
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
	if (httpHeaders) {
		[userInfo setObject:httpHeaders forKey:kCDOHErrorUserInfoHTTPHeadersKey];
	}
	if (responseBody) {
		[userInfo setObject:responseBody forKey:kCDOHErrorUserInfoResponseDataKey];
	}
	if (error) {
		[userInfo setObject:error forKey:kCDOHErrorUserInfoOriginalErrorKey];
	}
	
	self = [self initWithDomain:kCDOHErrorDomain code:httpStatus userInfo:userInfo];
	return self;
}


#pragma mark - HTTP Headers
- (NSDictionary *)HTTPHeaders
{
	return [[self userInfo] objectForKey:kCDOHErrorUserInfoHTTPHeadersKey];
}


#pragma mark - Response Data
- (NSData *)responseBody
{
	return [[self userInfo] objectForKey:kCDOHErrorUserInfoResponseDataKey];
}

- (id)parsedResponseBody
{
	id parsed = nil;
	if (self.responseBody && [self.responseBody length] > 0) {
		parsed = [NSJSONSerialization JSONObjectWithData:self.responseBody options:0 error:NULL];
	}
	
	return parsed;
}


#pragma mark - Original Error
- (NSError *)originalError
{
	return [[self userInfo] objectForKey:kCDOHErrorUserInfoOriginalErrorKey];
}


#pragma mark - Describing a User Object
- (NSString *)description
{
	NSString *descriptionFormat = [NSString stringWithFormat:@"<%@: %p { code = %ld, %s }>", [self class], self, (long)self.code, "%@"];
	NSString *varDescs = nil;
	
	if (self.code >= kCDOHErrorCodeFrameworkErrors) {
		varDescs = @"";
	} else {
		id body = nil;
		if (!(body = [self parsedResponseBody])) {
			body = self.responseBody;
		}
	
		varDescs = [NSString stringWithFormat:@"headers = %@, body = %@", self.HTTPHeaders, body];
	}
	
	NSString *description = [NSString stringWithFormat:descriptionFormat, varDescs];
	return description;
}


#pragma mark - Remedy
- (NSString *)localizedFailureReason
{
	NSString *localizedFailureReason = nil;
	
	//TODO: Add strings files with localization data for this!
	switch (self.code) {
		default:
			localizedFailureReason = [super localizedFailureReason];
			break;
	}
	
	return localizedFailureReason;
}

- (NSString *)localizedRecoverySuggestion
{
	NSString *localizedRecoverySuggestion = nil;
	
	//TODO: Add strings files with localization data for this!
	switch (self.code) {
		default:
			localizedRecoverySuggestion = [super localizedRecoverySuggestion];
			break;
	}
	
	return localizedRecoverySuggestion;
}


@end

