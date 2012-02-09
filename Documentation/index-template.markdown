<div class="section-header">
	<h1 class="title title-header">ObjectiveHub Documentation</h1>
</div>

This is the documentation for the  [ObjectiveHub library](http://libobjectivehub.com/). If you are wondering were to start or how to use some part of the library please see the guides [usage guides](guides.html) and the [API reference](../index.html).

## Install Documentation Into Xcode ##
Use the following URL to install the ObjectiveHub documentation into Xcode: `http://libobjectivehub.com/docs/com.libobjectivehub.ObjectiveHub.atom`. Follow the step by step guide below (for Xcode 4).

1. In Xcode, open the preferences and click the _Downloads_ tab.
2. Then select the _Documentation_ tab (below the _Downloads_ tab).
3. Click the plus button in the lower left region of the window.
4. Enter the URL `http://libobjectivehub.com/docs/com.libobjectivehub.ObjectiveHub.atom` into the modal window and click _Add_.
5. Let Xcode download and parse the documentation set (enter your password of needed).

You are now done, go ahead and search the documentation in Xcode’s documentation view.

## Usage Example ##
An example on how to get all the repositories watched by a user and then adding them to a mutable array.

	#import <ObjectiveHub/ObjectiveHub.h>
	...
	
	- (void)loadData {
		NSString *username = ...
		CDOHClient *client = [[CDOHClient alloc] init];
		
		[client repositoriesWatchedByUser:username pages:nil success:^(CDOHResponse *response) {
			// Handle the respone (you will probably want to do something 
			// smarter than the row below).
			[self.watchedRepos addObjectsFromArray:response.resource];
			
			// Make sure we load all repositories watched by the user. The
			// success and failure blocks used in the first request will be re-
			// used. Just take care if the user is watching thousands of
			// repositories.
			if (response.hasNextPage) {
				[response loadNextPage];
			}
		} failure:^(CDOHError *error) {
			// Present the error or even better try to fix it for the user.
			[self presentError:error];
		}];
	}

You will probably not want to just add the repositories (of the type `CDOHRepository`) to the mutable array in your code as that would lead to duplicates if `-loadData` is called twice.

The success and failure blocks might not be called on the main thread so if you need to update any GUI-element please make sure you do so on the main thread. Updating of other data structures should also be performed in a thread-safe manner. That is, do something like `[self performSelectorOnMainThread:@selector(updateMyGUI) withObject:nil waitUntilDone:NO]` or similair. For more information please see the blocks section in the CDOHClient class documentation.
