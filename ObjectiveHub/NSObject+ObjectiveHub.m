//
//  NSObject+ObjectiveHub.m
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

#import "NSObject+ObjectiveHub.h"
#import "CDOHCommon.h"

#import <objc/runtime.h>


#pragma mark NSURL(ObjectiveHub) Category Implementation
CDOH_FIX_CATEGORY_BUG(NSObject_ObjectiveHub)
@implementation NSObject (ObjectiveHub)

+ (NSArray *)cdoh_instancePropertiesForClass:(Class)aClass
{
	static NSArray *cdoh_instanceProperties = nil;
	static dispatch_once_t cdoh_instancePropertiesForClassOnceToken;
	dispatch_once(&cdoh_instancePropertiesForClassOnceToken, ^{
		unsigned int propertiesCount;
		objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
		
		NSMutableArray *keyPaths = [NSMutableArray arrayWithCapacity:propertiesCount];
		
		for (unsigned int i = 0; i < propertiesCount; ++i) {
			objc_property_t property = properties[i];
			const char *propertyName = property_getName(property);
			NSString *keyPath = [NSString stringWithUTF8String:propertyName];
			
			[keyPaths addObject:keyPath];
		}
		free(properties);
		
		cdoh_instanceProperties = [keyPaths copy];
	});
	
	return cdoh_instanceProperties;
}

@end
