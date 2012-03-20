//
//  CDOHResponsePrivate.h
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
@class CDOHResource;
@class CDOHLinkRelationshipHeader;


#pragma mark - CDOHResponse Private Interface
/**
 * Private members of the CDOHResponse class.
 */
@interface CDOHResponse ()

#pragma mark - Initializing a CDOHResponse Instance
/**
 * Intialize a newly allocated `CDOHResponse` instance using the given
 * parameters.
 *
 * @param resource The requested resource. May be `nil`.
 * @param target The target for loading more data.
 * @param action The action used to load the data.
 * @param successBlock The block to be called upon success.
 * @param failureBlock The block to be called upon failure.
 * @param httpHeaders The HTTP header returned by the remote.
 * @param arguments The arguments to send to the action. Excluding the `self`,
 * `_cmd`, `successBlock`, `failureBlock` and `pages` arguments.
 * @return A `CDOHResponse` initialized using the given parameters.
 *
 * @see CDOHClient
 * @see CDOHSuccessBlock
 * @see CDOHFailureBlock
 */
- (id)initWithResource:(id)resource
				client:(CDOHClient *)client
			  selector:(SEL)selector
		  successBlock:(CDOHSuccessBlock)successBlock
		  failureBlock:(CDOHFailureBlock)failureBlock
		   HTTPHeaders:(NSDictionary *)httpHeaders
			 arguments:(NSArray *)arguments;


#pragma mark - 
/**
 * The invocation used for subsquent page requests.
 *
 * @see arguments
 */
@property (strong, readonly) NSInvocation *invocation;

/**
 * The arguments that should be used on subsequent requests.
 *
 * @see invocation
 */
@property (copy, readonly) NSArray *arguments;

@end

