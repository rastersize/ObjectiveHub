//
//  CDOHLinkRelationshipHeader.m
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

#import "CDOHLinkRelationshipHeader.h"
#import "NSURL+ObjectiveHub.h"


#pragma mark Relationship Name Keys
NSString *const kCDOHResponseHeaderLinkNextKey			= @"next";
NSString *const kCDOHResponseHeaderLinkPreviousKey		= @"prev";
NSString *const kCDOHResponseHeaderLinkFirstKey			= @"first";
NSString *const kCDOHResponseHeaderLinkLastKey			= @"last";


#pragma mark - Link Separator
NSString *const kCDOHResponseHeaderLinkSeparatorKey		= @",";


#pragma mark - Query Keys
NSString *const kCDOHResponseHeaderPageKey				= @"page";
NSString *const kCDOHResponseHeaderPerPageKey			= @"per_page";


#pragma mark CDOHLinkRelationshipHeader Implementation
@implementation CDOHLinkRelationshipHeader


#pragma mark - Link Relationship Properties
@synthesize name = _name;
@synthesize URL = _url;


#pragma mark - Initialize a Link Relationship
- (id)initWithName:(NSString *)name URL:(NSURL *)url
{
	self = [super init];
	if (self) {
		_name = [name copy];
		_url = url;
	}
	
	return self;
}

+ (CDOHLinkRelationshipHeader *)linkRelationshipFromLinkString:(NSString *)linkString
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


#pragma mark - Extracting Information From Link Relationships
- (NSUInteger)pageNumber
{
	NSString *pageString = [self.URL cdoh_queryValueForKey:kCDOHResponseHeaderPageKey];
	NSUInteger page = [pageString integerValue];
	
	return page;
}

- (NSUInteger)perPageNumber
{
	NSString *perPageString = [self.URL cdoh_queryValueForKey:kCDOHResponseHeaderPerPageKey];
	NSUInteger perPage = [perPageString integerValue];
	
	return perPage;
}



#pragma mark - Describing a Link Relationship
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p { name = %@, URL = %@ }>",
			[self class],
			self,
			_name,
			_url];
}

@end