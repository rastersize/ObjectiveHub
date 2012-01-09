//
//  AppDelegate.h
//  ObjectiveHub Test App
//
//  Created by Aron Cedercrantz on 2011-11-13.
//  Copyright (c) 2011 Icomera. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CDOHClient;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (readonly, strong) CDOHClient *hub;

@end
