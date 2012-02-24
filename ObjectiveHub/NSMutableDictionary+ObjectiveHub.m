//
//  NSMutableDictionary+ObjectiveHub.m
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

#import "NSMutableDictionary+ObjectiveHub.h"

#import "CDOHResource.h"

#import "NSDate+ObjectiveHub.h"
#import "NSString+ObjectiveHub.h"

#import "CDOHCommon.h"


CDOH_FIX_CATEGORY_BUG(NSMutableDictionary_ObjectiveHub)
@implementation NSMutableDictionary (ObjectiveHub)

#pragma mark - Adding Entries to a Mutable Dictionary
- (void)cdoh_setObject:(id)obj forKey:(id)key
{
	if (obj == nil) { return; obj = [NSNull null]; }
	[self setObject:obj forKey:key];
}

- (void)cdoh_encodeAndSetResource:(CDOHResource *)resource forKey:(id)key
{
	NSDictionary *resourceDict = [resource encodeAsDictionary];
	[self cdoh_setObject:resourceDict forKey:key];
}

- (void)cdoh_encodeAndSetDate:(NSDate *)date forKey:(id)key
{
	NSString *dateString = [date cdoh_stringUsingRFC3339Format];
	[self cdoh_setObject:dateString forKey:key];
}

- (void)cdoh_encodeAndSetURL:(NSURL *)url forKey:(id)key
{
	NSString *urlString = [url absoluteString];
	[self cdoh_setObject:urlString forKey:key];
}


#pragma mark - Adding Scalar Entries to a Mutable Dictionary
- (void)cdoh_setBool:(BOOL)flag forKey:(id)key
{
	NSNumber *num = [[NSNumber alloc] initWithBool:flag];
	[self cdoh_setObject:num forKey:key];
}

- (void)cdoh_setInteger:(NSInteger)value forKey:(id)key
{
	NSNumber *num = [[NSNumber alloc] initWithInteger:value];
	[self cdoh_setObject:num forKey:key];
}

- (void)cdoh_setUnsignedInteger:(NSUInteger)value forKey:(id)key
{
	NSNumber *num = [[NSNumber alloc] initWithUnsignedInteger:value];
	[self cdoh_setObject:num forKey:key];
}

- (void)cdoh_setDouble:(double)value forKey:(id)key
{
	NSNumber *num = [[NSNumber alloc] initWithDouble:value];
	[self cdoh_setObject:num forKey:key];
}



@end
