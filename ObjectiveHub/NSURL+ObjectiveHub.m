//
//  NSURL+ObjectiveHub.m
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

#import "NSURL+ObjectiveHub.h"
#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSURL_ObjectiveHub)
@implementation NSURL (ObjectiveHub)

#pragma mark - Accessing Query Values
- (NSDictionary *)cdoh_queryDictionary
{
	NSDictionary *dict = nil;
	
	NSMutableCharacterSet *trimmedCharactersSet = [NSMutableCharacterSet whitespaceCharacterSet];
	[trimmedCharactersSet addCharactersInString:@"?&"];
	NSString *query = [[self query] stringByTrimmingCharactersInSet:trimmedCharactersSet];
	
	NSArray *paramComponents = [query componentsSeparatedByString:@"&"];
	NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:[paramComponents count]];
	NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[paramComponents count]];
	
	for (NSString *parameter in paramComponents) {
		id key = nil;
		id value = nil;
		NSArray *paramKeyValueArray = [parameter componentsSeparatedByString:@"="];
		
		if ([paramKeyValueArray count] >= 1) {
			key = [paramKeyValueArray objectAtIndex:0];
			
			if ([paramKeyValueArray count] >= 2) {
				value = [paramKeyValueArray objectAtIndex:1];
			} else {
				value = [NSNull null];
			}
			
			[keys addObject:key];
			[values addObject:value];
		}
	}
	
	dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	return dict;
}

- (NSString *)cdoh_queryValueForKey:(NSString *)key
{
	NSDictionary *queryDict = [self cdoh_queryDictionary];
	NSString *value = [queryDict objectForKey:key];
	if ([value isKindOfClass:[NSNull class]]) {
		value = nil;
	}
	return value;
}

@end
