//
//  CDOHNetworkClientReply.h
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


#pragma mark Forward Class Declarations
@class CDOHError;


#pragma mark - CDOHNetworkClientReply Interface
/**
 * An immutable class which represent a reply from a network client.
 */
@interface CDOHNetworkClientReply : NSObject <NSCoding, NSCopying>

#pragma mark - Creating and Initializing Network Client Replies
/** @name Creating and Initializing Network Client Replies */
/**
 *
 */
- (instancetype)initWithSuccessStatus:(BOOL)success response:(id<NSCoding>)response error:(CDOHError *)error HTTPHeaders:(NSDictionary *)httpHeaders;


#pragma mark - Reply Message
/** @name Reply Message */
/**
 * Whether the request was successful or not.
 *
 * That is; if `success` is `YES` the request was successful (HTTP status code
 * within the interval 200-299).
 */
@property (assign, readonly) BOOL success;

/**
 * The response from the remote host.
 *
 * If `success` is `YES` it should be be an `NSData` object representing the
 * data received, otherwise it should be `nil`.
 */
@property (strong, readonly) id<NSCoding> response;

/**
 * The error received from the remote host.
 *
 * If `success` is `NO` it should be be an `CDOHError` object, otherwise it
 * should be `nil`.
 */
@property (strong, readonly) CDOHError *error;

/**
 * The HTTP headers the remote host replied with.
 */
@property (copy, readonly) NSDictionary *HTTPHeaders;


@end
