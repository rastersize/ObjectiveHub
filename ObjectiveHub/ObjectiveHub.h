//
//  ObjectiveHub.h
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


//----------------------------------------------------------------------------//
#pragma mark Basic Classes And Types
//----------------------------------------------------------------------------//
#import <ObjectiveHub/CDOHError.h>
#import <ObjectiveHub/CDOHTypes.h>


//----------------------------------------------------------------------------//
#pragma mark - Resource Models
//----------------------------------------------------------------------------//
#import <ObjectiveHub/CDOHResource.h>
#import <ObjectiveHub/CDOHPlan.h>
#import <ObjectiveHub/CDOHAbstractUser.h>
#import <ObjectiveHub/CDOHUser.h>
#import <ObjectiveHub/CDOHOrganization.h>
#import <ObjectiveHub/CDOHOrganizationTeam.h>
#import <ObjectiveHub/CDOHRepository.h>


//----------------------------------------------------------------------------//
#pragma mark - Network Client
//----------------------------------------------------------------------------//
#import <ObjectiveHub/CDOHNetworkClient.h>
#import <ObjectiveHub/CDOHNetworkClientReply.h>
#import <ObjectiveHub/CDOHAFNetworkingClient.h>


//----------------------------------------------------------------------------//
#pragma mark - Making Requests and Handling Responses
//----------------------------------------------------------------------------//
#import <ObjectiveHub/CDOHClientProtocol.h>
#import <ObjectiveHub/CDOHClient.h>
#import <ObjectiveHub/CDOHResponse.h>
