//
//  FGOHError.m
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

#import "FGOHError.h"
#import "JSONKit.h"


#pragma mark FGOHError User Info Dictionary Default Keys
NSString *const kFGOHErrorUserInfoHttpHeadersKey			= @"httpHeaders";
NSString *const kFGOHErrorUserInfoResponseDataKey			= @"responseData";


#pragma mark - ObjectiveHub Error Domain
NSString *const kFGOHErrorDomain							= @"com.fruitisgood.objectivehub.error";


#pragma mark - FGOHError Implementation
@implementation FGOHError

#pragma mark - Initializing an FGOHError Instance
- (id)initWithHTTPHeaders:(NSDictionary *)httpHeaders httpStatus:(NSInteger)httpStatus responseBody:(NSData *)responseBody
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  httpHeaders,	kFGOHErrorUserInfoHttpHeadersKey,
							  responseBody,	kFGOHErrorUserInfoResponseDataKey,
							  nil];
	
	self = [self initWithDomain:kFGOHErrorDomain code:httpStatus userInfo:userInfo];
	return self;
}


#pragma mark - HTTP Headers
- (NSDictionary *)httpHeaders
{
	return [[self userInfo] objectForKey:kFGOHErrorUserInfoHttpHeadersKey];
}


#pragma mark - Response Data
- (NSData *)responseBody
{
	return [[self userInfo] objectForKey:kFGOHErrorUserInfoResponseDataKey];
}

- (id)parsedResponseBody
{
	// TODO: Verify that JSONKit returns nil if the NSData object couldn't be converted from JSON.
	id parsed = [self.responseBody objectFromJSONData];
	
	return parsed;
}


@end

