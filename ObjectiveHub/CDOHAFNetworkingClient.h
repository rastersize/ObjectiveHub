//
//  CDOHAFNetworkingClient.h
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
#import <ObjectiveHub/CDOHNetworkClient.h>


#pragma mark Forward Declarations
@class AFHTTPClient;


#pragma mark - CDOHAFNetworkingClient Interface
/**
 * The `CDOHAFNetworkingClient` class makes the `AFNetworking` library available
 * to the ObjectiveHub client (`CDOHClient`).
 */
@interface CDOHAFNetworkingClient : NSObject <CDOHNetworkClient>

#pragma mark - AFNetworking HTTP Client
/** @name AFNetworking HTTP Client */
/**
 * The _AFNetworking_ HTTP client instance used for the acctual network
 * communication.
 *
 * At the time of initialization this property gets set with an automatically
 * created client. If you want to use your own client object then you can set
 * this property. Please note that the client will be configured by the adapter.
 *
 * More precisely, a few default headers will be set as well as the HTTP
 * operations class and the parameter encoding which should be used.
 *
 * @see [AFNetworking’s website](http://afnetworking.com)
 * @see [AFNetworking’s documentation](https://github.com/AFNetworking/AFNetworking/blob/master/README.md)
 */
@property (strong) AFHTTPClient *client;

@end
