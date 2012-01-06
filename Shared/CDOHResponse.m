//
//  CDOHResponse.m
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

#import "CDOHResponse.h"
#import "CDOHResponsePrivate.h"

#import "CDOHLinkRelationshipHeader.h"

#import "CDOHResource.h"

@implementation CDOHResponse {
	NSMutableArray *_pagesIndexSets;
	
	NSUInteger _pagesArgumentIndex;
	NSUInteger _successBlockArgumentIndex;
	NSUInteger _failureBlockArgumentIndex;
}

@synthesize resource = _resource;
@synthesize paginated = _paginated;
@synthesize hasNextPage = _hasNextPage;
@synthesize page = _page;
@synthesize nextPage = _nextPage;
@synthesize hasPreviousPage = _hasPreviousPage;
@synthesize previousPage = _previousPage;
@synthesize lastPage = _lastPage;

@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;

@synthesize invocation = _invocation;
@synthesize arguments = _arguments;

- (id)initWithResource:(id)resource
				target:(CDOHClient *)target
				action:(SEL)action
		  successBlock:(CDOHResponseBlock)successBlock
		  failureBlock:(CDOHFailureBlock)failureBlock
				 links:(NSArray *)links
			 arguments:(NSArray *)arguments
{
	self = [super init];
	if (self) {
		_resource = resource;
		_paginated= NO;
		
		if ([links count] > 0) {
			CDOHLinkRelationshipHeader *lastLink = nil;
			CDOHLinkRelationshipHeader *nextLink = nil;
			
			for (CDOHLinkRelationshipHeader *link in links) {
				if ([link.name isEqualToString:kCDOHResponseHeaderLinkNextKey]) {
					nextLink = link;
				} else if ([link.name isEqualToString:kCDOHResponseHeaderLinkLastKey]) {
					lastLink = link;
				}
			}
			
			_lastPage = [self pageFromLink:lastLink];
			_paginated = (_lastPage > 0);
			
			_nextPage = [self pageFromLink:nextLink];
			_page = _nextPage <= 1 ? 1 : _nextPage - 1;
			_previousPage = _page <= 1 ? 1 : _page - 1;
			
			_hasNextPage = (_nextPage > 1 && _nextPage > _page);
			_hasPreviousPage = (_previousPage >= 1 && _previousPage < _page);
		}
		
		
		if (_paginated) {
			_successBlock = [successBlock copy];
			_failureBlock = [failureBlock copy];
			
			NSMethodSignature *actionSig = [target methodSignatureForSelector:action];
			_invocation = [NSInvocation invocationWithMethodSignature:actionSig];
			[_invocation setSelector:action];
			[_invocation setTarget:target];
			
			_arguments = arguments;
			// 0 == self, 1 == _cmd thus start at 2
			NSUInteger argOffset = 2;
			[_arguments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *__unused stop) {
				[_invocation setArgument:&obj atIndex:idx + argOffset];
			}];
			
			_pagesArgumentIndex			= [_arguments count]     + argOffset;
			_successBlockArgumentIndex	= [_arguments count] + 1 + argOffset;
			_failureBlockArgumentIndex	= [_arguments count] + 2 + argOffset;
			
			[_invocation setArgument:&_successBlock atIndex:_successBlockArgumentIndex];
			[_invocation setArgument:&_failureBlock atIndex:_failureBlockArgumentIndex];
		}
	}
	
	return self;
}


#pragma mark - Load More Data
- (void)loadNextPage
{
	NSIndexSet *pages = [[NSIndexSet alloc] initWithIndex:_nextPage];
	[self loadPages:pages];
}

- (void)loadPreviousPage
{
	NSIndexSet *pages = [[NSIndexSet alloc] initWithIndex:_nextPage];
	[self loadPages:pages];
}

- (void)loadPages:(NSIndexSet *)pages
{
	[_pagesIndexSets addObject:pages];
	[_invocation setArgument:&pages atIndex:_pagesArgumentIndex];
	[_invocation invoke];
}


#pragma mark - Success and Failure Blocks
- (void)setSuccessBlock:(CDOHResponseBlock)successBlock
{
	if (successBlock != _successBlock) {
		_successBlock = [successBlock copy];
		[_invocation setArgument:&_successBlock atIndex:_successBlockArgumentIndex];
	}
}

- (CDOHResponseBlock)successBlock
{
	return _successBlock;
}

- (void)setFailureBlock:(CDOHResponseBlock)failureBlock
{
	if (failureBlock != _failureBlock) {
		_failureBlock = [failureBlock copy];
		[_invocation setArgument:&_failureBlock atIndex:_failureBlockArgumentIndex];
	}
}


#pragma mark - Page From Link
- (NSUInteger)pageFromLink:(CDOHLinkRelationshipHeader *)link
{
	NSUInteger page = 0;
	NSArray *paramComponents = [[[link URL] query] componentsSeparatedByString:@"&"];
	
	for (NSString *paramStr in paramComponents) {
		NSArray *paramPair = [paramStr componentsSeparatedByString:@"="];
		if ([paramPair count] == 2) {
			NSString *key = [paramPair objectAtIndex:0];
			if ([key isEqualToString:@"page"]) {
				page = [[paramPair objectAtIndex:1] integerValue];
			}
		}
	}
	
	return page;
}

@end
