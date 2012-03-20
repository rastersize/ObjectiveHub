//
//  CDOHResource.h
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

#import "CDOHResource.h"
#import "CDOHResourcePrivate.h"

#import "NSString+ObjectiveHub.h"


#pragma mark GitHub JSON Keys
NSString *const kCDOHResourceJSONURLKey							=  @"url";


#pragma mark - Mapped Attribute Name Keys
NSString *const kCDOHResourceResourceURLAttributeNameKey		= @"p_resourceURL";


#pragma mark - 
@implementation CDOHResource

#pragma mark - Creating and Initializing CDOHResources
+ (instancetype)resourceWithJSONDictionary:(NSDictionary *)jsonDictionary inManagedObjectContex:(NSManagedObjectContext *)managedObjectContext
{
	CDOHResource *resource = [self insertInManagedObjectContext:managedObjectContext];
	
	[resource setValuesForAttributesWithJSONDictionary:jsonDictionary];
	[resource setValuesForRelationshipsWithJSONDictionary:jsonDictionary];
	
	return resource;
}


#pragma mark - Handling JSON
- (void)setValuesForAttributesWithJSONDictionary:(NSDictionary *)keyedValues
{
	NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
		NSAttributeDescription *description = [attributes objectForKey:attribute];
		NSString *classString = [[description userInfo] objectForKey:@"class"];
		
		NSString *jsonKey = [[description userInfo] objectForKey:@"jsonKey"];
		jsonKey = jsonKey != nil ? jsonKey : attribute;
		
        id value = [keyedValues objectForKey:jsonKey];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
		
        NSAttributeType attributeType = [description attributeType];
        if (attributeType == NSStringAttributeType && [value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        } else if ((attributeType == NSInteger16AttributeType ||
					attributeType == NSInteger32AttributeType ||
					attributeType == NSInteger64AttributeType ||
					attributeType == NSBooleanAttributeType) &&
				   [value isKindOfClass:[NSString class]]) {
			
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if (attributeType == NSFloatAttributeType && [value isKindOfClass:[NSString class]]) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if (attributeType == NSDateAttributeType && [value isKindOfClass:[NSString class]]) {
            value = [value cdoh_dateUsingRFC3339Format];
        } else if (attributeType == NSTransformableAttributeType && [classString length] > 0) {
			if ([classString isEqualToString:@"NSURL"] && [value isKindOfClass:[NSString class]]) {
				value = [NSURL URLWithString:value];
			}
		}
        [self setValue:value forKey:attribute];
    } 
}

- (void)setValuesForRelationshipsWithJSONDictionary:(NSDictionary *)keyedValues
{
	NSDictionary *relationships = [[self entity] relationshipsByName];
	for (NSString *relationship in relationships) {
		NSRelationshipDescription *description = [relationships objectForKey:relationship];
		
		NSString *jsonKey = [[description userInfo] objectForKey:@"jsonKey"];
		jsonKey = jsonKey != nil ? jsonKey : relationship;
		
		id value = [keyedValues objectForKey:jsonKey];
		if (value == nil || [value isKindOfClass:[NSNull class]]) {
			continue;
		}
		
		if ([description isToMany]) {
			if ([value isKindOfClass:[NSArray class]]) {
				NSMutableSet *resources = [self valueForKey:relationship];
				
				for (NSDictionary *dict in value) {
					if ([dict isKindOfClass:[NSDictionary class]]) {
						Class resourceClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
						CDOHResource *resource = [resourceClass resourceWithJSONDictionary:value inManagedObjectContex:[self managedObjectContext]];
						
						[resources addObject:resource];
					}
				}
			}
		} else if ([value isKindOfClass:[NSDictionary class]]) {
			Class resourceClass = NSClassFromString([[description destinationEntity] managedObjectClassName]);
			CDOHResource *resource = [resourceClass resourceWithJSONDictionary:value inManagedObjectContex:[self managedObjectContext]];
			
			[self setValue:resource forKey:relationship];
		}
	}
}


#pragma mark - Resource Attributes
- (NSURL *)resourceURL
{
	return self.p_resourceURL;
}

- (void)setResourceURL:(NSURL *)resourceURL
{
	self.p_resourceURL = resourceURL;
}


@end
