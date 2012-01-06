//
//  CDOHResponsBlockTypes.h
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

#import <Foundation/Foundation.h>


#pragma mark Forward Class Declarations
@class CDOHError;
@class CDOHResponse;


#pragma mark - ObjectiveHub Generic Block Types
/**
 * The type of blocks called when a user request failed.
 *
 * @param error The error encountered.
 */
typedef void (^CDOHFailureBlock)(CDOHError *error);

/**
 * The type of blocks called when a user request succeeded and contains a
 * response.
 *
 * The sought object will be available at `response.resource`. If the response
 * is paginated the response parameter will let you find this out as well as
 * load more pages.
 *
 * @param response The response from the service. Is of the type CDOHResponse.
 */
typedef void (^CDOHResponseBlock)(CDOHResponse *response);

/**
 * The type of blocks called when a user request succeeded but does not contain
 * a response.
 */
typedef void (^CDOHNoResponseBlock)(void);

