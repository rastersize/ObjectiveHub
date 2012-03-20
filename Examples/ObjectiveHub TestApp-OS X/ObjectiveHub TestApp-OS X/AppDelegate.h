//
//  AppDelegate.h
//  ObjectiveHub TestApp-OS X
//
//  Created by Aron Cedercrantz on 2012-03-20.
//  Copyright (c) 2012 Aron Cedercrantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CDOHClient;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) CDOHClient *client; 

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
