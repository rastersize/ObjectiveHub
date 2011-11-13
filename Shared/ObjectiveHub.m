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

#import "AFNetworking.h"
#import "JSONKit.h"


#pragma mark - Constants
/// The base URI for the GitHub API
NSString *const kObjectiveHubGitHubAPIURI	= @"https://api.github.com";

/// A date format string for the ISO 8601 format
NSString *const kObjectiveHubDateFormat		= @"YYYY-MM-DDTHH:MM:SSZ";





#pragma mark - ObjectiveHub Implementation
@implementation ObjectiveHub

#pragma mark - Synthesizing
@synthesize username = _username;
@synthesize password = _password;
@synthesize defaultItemsPerPage = _defaultItemsPerPage;
@synthesize rateLimit = _rateLimit;


#pragma mark - Initializing ObjectiveHub
- (id)init
{
	self = [super init];
	if (self) {
		_defaultItemsPerPage	= kObjectiveHubDefaultItemsPerPage;
		_rateLimit				= kObjectiveHubDefaultRateLimit;
	}
	
	return self;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
	self = [self init];
	if (self) {
		_username = [username copy];
		_password = [password copy];
	}
	
	return self;
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

@end
