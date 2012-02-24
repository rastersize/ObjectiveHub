//
//  UIApplication+ObjectiveHub.m
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

#import "UIApplication+ObjectiveHub.h"


#if TARGET_OS_IPHONE
@interface UIApplication (ObjectiveHub_Private)

@property (nonatomic, assign, readonly) NSInteger cdoh_networkActivityCount;

- (void)cdoh_refreshActivityIndicator;

@end

@implementation UIApplication (ObjectiveHub)

static NSInteger _networkActivityCount;


- (NSInteger)cdoh_networkActivityCount
{
	@synchronized(self) {
		return _networkActivityCount;
	}
}

- (void)cdoh_refreshActivityIndicator
{
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
		return;
	}
	
	BOOL active = (self.cdoh_networkActivityCount > 0);
	self.networkActivityIndicatorVisible = active;
}

- (void)cdoh_pushNetworkActivity
{
	@synchronized(self) {
		_networkActivityCount++;
	}
	[self cdoh_refreshActivityIndicator];
}

- (void)cdoh_popNetworkActivity
{
	@synchronized(self) {
		if (_networkActivityCount > 0) {
			_networkActivityCount--;
		} else {
			_networkActivityCount = 0;
#if DEBUG
			NSAssert(NO, @"Unbalanced network activity: count already 0.");
#else
			NSLog(@"Unbalanced network activity: count already 0.");
#endif
		}
	}
	[self cdoh_refreshActivityIndicator];
}

- (void)cdoh_resetNetworkActivity
{
	@synchronized(self) {
		_networkActivityCount = 0;
	}
	[self cdoh_refreshActivityIndicator];
}

@end

#endif // TARGET_OS_IPHONE
