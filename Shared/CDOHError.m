//
//  CDOHError.m
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

#import "CDOHError.h"
#import "JSONKit.h"


#pragma mark CDOHError User Info Dictionary Default Keys
NSString *const kCDOHErrorUserInfoHTTPHeadersKey			= @"httpHeaders";
NSString *const kCDOHErrorUserInfoResponseDataKey			= @"responseData";
NSString *const kCDOHErrorInvalidArgumentsKey				= @"invalidArguments";


#pragma mark - ObjectiveHub Error Domain
NSString *const kCDOHErrorDomain							= @"com.fruitisgood.objectivehub.error";


#pragma mark - CDOHError Implementation
@implementation CDOHError

#pragma mark - Initializing an CDOHError Instance
- (id)initWithHTTPHeaders:(NSDictionary *)httpHeaders HTTPStatus:(NSInteger)httpStatus responseBody:(NSData *)responseBody
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  httpHeaders,	kCDOHErrorUserInfoHTTPHeadersKey,
							  responseBody,	kCDOHErrorUserInfoResponseDataKey,
							  nil];
	
	self = [self initWithDomain:kCDOHErrorDomain code:httpStatus userInfo:userInfo];
	return self;
}

- (id)initWithInvalidArgument:(CDOHErrorCodeType)code arguments:(NSArray *)arguments
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:arguments forKey:kCDOHErrorInvalidArgumentsKey];
	
	self = [self initWithDomain:kCDOHErrorDomain code:code userInfo:userInfo];
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
	// TODO: Verify that JSONKit returns nil if the NSData object couldn't be converted from JSON.
	id parsed = nil;
	if (self.responseBody && [self.responseBody length] > 0) {
		parsed = [self.responseBody objectFromJSONData];
	}
	
	return parsed;
}


#pragma mark - Describing a User Object
- (NSString *)description
{
	NSString *descriptionFormat = [NSString stringWithFormat:@"<%@: %p { code = %d, %s }>", [self class], self, self.code, "%@"];
	NSString *varDescs = nil;
	
	if (self.code >= kCDOHErrorCodeFrameworkErrors) {
		varDescs = [NSString stringWithFormat:@"arguments = %@", [self.userInfo objectForKey:kCDOHErrorInvalidArgumentsKey]];
	} else {
		id body = nil;
		if (!(body = [self parsedResponseBody])) {
			body = self.responseBody;
		}
	
		varDescs = [NSString stringWithFormat:@"headers = %@, body = %@", self.code, self.HTTPHeaders, body];
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
		case kCDOHErrorCodeInvalidArgument:
			localizedFailureReason = NSLocalizedString(@"One or more of the supplied arguments were invalid", @"Invalid argument supplied error message");
			break;
		case kCDOHErrorCodeInvalidNilArgument:
			localizedFailureReason = NSLocalizedString(@"One or more arguments which may not be nil were nil", @"Invalid nil argument supplied error message");
			break;
			
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
		case kCDOHErrorCodeInvalidArgument:
			localizedRecoverySuggestion = NSLocalizedString(@"Correct the invalid arguments", @"Invalid argument supplied error message");
			break;
		case kCDOHErrorCodeInvalidNilArgument:
			localizedRecoverySuggestion = NSLocalizedString(@"Correct the arguments which were nil", @"Invalid nil argument supplied error message");
			break;
			
		default:
			localizedRecoverySuggestion = [super localizedRecoverySuggestion];
			break;
	}
	
	return localizedRecoverySuggestion;
}


@end

