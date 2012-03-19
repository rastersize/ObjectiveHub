//
//  CDOHNetworkClientReply.m
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

#import "CDOHNetworkClientReply.h"

#pragma mark - 
NSString *const kCDOHNetworkClientReplySuccessKey		= @"CDOHNCRSuccess";
NSString *const kCDOHNetworkClientReplyResponseKey		= @"CDOHNCRResponse";
NSString *const kCDOHNetworkClientReplyHTTPHeadersKey	= @"CDOHNCRHTTPHeaders";


#pragma mark - 
@implementation CDOHNetworkClientReply

#pragma mark - 
@synthesize success = _success;
@synthesize response = _response;
@synthesize HTTPHeaders = _httpHeaders;


#pragma mark - Creating and Initializing Network Client Replies
- (instancetype)initWithSuccessStatus:(BOOL)success response:(id<NSCoding>)response HTTPHeaders:(NSDictionary *)httpHeaders
{
	self = [super init];
	if (self) {
		_success = success;
		_response = response;
		_httpHeaders = [httpHeaders copy];
	}
	
	return self;
}


#pragma mark - NSCoding Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
	BOOL success = [aDecoder decodeBoolForKey:kCDOHNetworkClientReplySuccessKey];
	id<NSCoding> response = [aDecoder decodeObjectForKey:kCDOHNetworkClientReplyResponseKey];
	NSDictionary *httpHeaders = [aDecoder decodeObjectForKey:kCDOHNetworkClientReplyHTTPHeadersKey];
	
	self = [self initWithSuccessStatus:success response:response HTTPHeaders:httpHeaders];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeBool:_success forKey:kCDOHNetworkClientReplySuccessKey];
	[aCoder encodeObject:_response forKey:kCDOHNetworkClientReplyResponseKey];
	[aCoder encodeObject:_httpHeaders forKey:kCDOHNetworkClientReplyHTTPHeadersKey];
}


#pragma mark - NSCopying Method
- (id)copyWithZone:(NSZone *__unused)zone
{
	return self;
}



@end
