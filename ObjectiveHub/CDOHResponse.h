//
//  CDOHResponse.h
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
#import <ObjectiveHub/CDOHTypes.h>


#pragma mark Forward Class Declarations
@class CDOHResource;
@class CDOHClient;


#pragma mark - CDOHResponse Interface
/**
 * Responses from GitHub is wrapped inside a `CDOHResponse`.
 *
 * You can load more data via the `-loadPages:`, `-loadNextPage` and
 * `-loadPreviousPage` methods. Notice that they will only load more data if the
 * resource response is paginated, as indicated by the paginated property.
 *
 * Please notice that page numbers start at **1**.
 *
 * This class expects that the last argument of the action method is the failure
 * block and the second last the success block. If a request if paginated then
 * CDOHRespone expects that the third last argument is for the `pages` argument.
 */
@interface CDOHResponse : NSObject

#pragma mark - Response Resource
/** @name Response Resource */
/**
 * Resource returned from the request.
 */
@property (strong, readonly) id resource;


#pragma mark - Resource Pagination
/** @name Resource Pagination */
/**
 * Whether the resource response is paginated.
 */
@property (assign, readonly, getter = isPaginated) BOOL paginated;

/**
 * Whether the resource response has a next page.
 */
@property (assign, readonly) BOOL hasNextPage;

/**
 * Whether the resource response has a previous page.
 */
@property (assign, readonly) BOOL hasPreviousPage;

/**
 * The page number of this resource response.
 *
 * Page number one (1) represents the first page.
 */
@property (assign, readonly) NSUInteger page;

/**
 * The page number of the next resource response page.
 */
@property (assign, readonly) NSUInteger nextPage;

/**
 * The page number of the previous resource response page.
 */
@property (assign, readonly) NSUInteger previousPage;

/**
 * The page number of the last resource response page.
 */
@property (assign, readonly) NSUInteger lastPage;


#pragma mark - Loading More Pages
/** @name Loading More Pages */
/**
 * Load the resource response pages specified by _pages_.
 *
 * If the resource response is not paginated this method does nothing.
 *
 * @param pages The pages to load.
 */
- (void)loadPages:(NSIndexSet *)pages;

/**
 * Load the next resource response page.
 *
 * If the resource response is not paginated this method does nothing.
 */
- (void)loadNextPage;

/**
 * Load the previous resource response page.
 *
 * If the resource response is not paginated this method does nothing.
 */
- (void)loadPreviousPage;

/**
 * Load the first resource response page.
 *
 * Even if the resource is not paginated this method will load it again.
 */
- (void)loadFirstPage;

/**
 * Load the last resource response page.
 *
 * If the resource response is not paginated this method does nothing.
 */
- (void)loadLastPage;


#pragma mark - Success and Failure Blocks
/** @name Success and Failure Blocks */
/**
 * The block to be called upon success.
 *
 * Defaults to the success block used in the initial request.
 */
@property (copy, readonly) CDOHSuccessBlock successBlock;

/**
 * The block to be called upon failure.
 *
 * Defaults to the failure block used in the initial request.
 */
@property (copy, readonly) CDOHFailureBlock failureBlock;


@end
