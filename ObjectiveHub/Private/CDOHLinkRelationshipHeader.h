//
//  CDOHLinkRelationshipHeader.h
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

#import <Foundation/Foundation.h>


#pragma mark Relationship Name Keys
/// The HTTP Link next relationship key.
extern NSString *const kCDOHResponseHeaderLinkNextKey;
/// The HTTP Link last relationship key.
extern NSString *const kCDOHResponseHeaderLinkLastKey;


#pragma mark - Link Separator
/// The HTTP Link relationship separator.
extern NSString *const kCDOHResponseHeaderLinkSeparatorKey;


#pragma mark - Query Keys
/// The HTTP Link relationship current page query key.
extern NSString *const kCDOHResponseHeaderPageKey;
/// The HTTP Link relationship current per page query key.
extern NSString *const kCDOHResponseHeaderPerPageKey;


#pragma mark - CDOHLinkRelationshipHeader Interface
/**
 * Wrapper class of relationship link header objects.
 *
 * @private
 */
@interface CDOHLinkRelationshipHeader : NSObject

#pragma mark - Initialize a Link Relationship
/** @name Initialize a Link Relationship */
/**
 * Initialize a newly allocated link relationship instance.
 *
 * @param name The link relationship name.
 * @param url The link relationship URL.
 * @private
 */
- (id)initWithName:(NSString *)name URL:(NSURL *)url;

/**
 * Create a link relationship instance using the given link string.
 *
 * The link string must be on the format `<__URL__>; rel="__NAME__"`
 */
+ (CDOHLinkRelationshipHeader *)linkRelationshipFromLinkString:(NSString *)linkString;

#pragma mark - Link Relationship Properties
/** @name Link Relationship Properties */
/**
 * The name of the relationship.
 *
 * Can be one of;
 * - kCDOHResponseHeaderLinkNextKey,
 * - kCDOHResponseHeaderLinkLastKey.
 *
 * @private
 */
@property (copy, readonly) NSString *name;

/**
 * The URL the relationship points to.
 *
 * @private
 */
@property (strong, readonly) NSURL *URL;


#pragma mark - Extracting Information From Link Relationships
/** @name Extracting Information From Link Relationships */
/**
 * The page number specified in the query part of the link relationship URL.
 *
 * @private
 */
- (NSUInteger)pageNumber;

/**
 * The per page number specified in the query part of the link relationship URL.
 *
 * @private
 */
- (NSUInteger)perPageNumber;

@end