//
//  PIPContainerViewController.h
//
//  Created by Guilherme Rambo on 30/10/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

/// A view controller to contain other view controllers to be presented in picture-in-picture mode
@interface PIPContainerViewController : NSViewController

/// Toggles picture-in-picture state for the first child view controller
- (IBAction)togglePIP:(nullable id)sender;

/// Called when the pause button is pressed in the PiP panel
@property (nonatomic, copy, nullable) void (^pipDidPause)();

/// Called when the play button is pressed in the PiP panel
@property (nonatomic, copy, nullable) void (^pipDidPlay)();

/// Called when the PiP panel is about to be opened (TIP: set the isPlaying property here)
@property (nonatomic, copy, nullable) void (^pipWillOpen)();

/// Called when the PiP panel is about to be closed
@property (nonatomic, copy, nullable) void (^pipWillClose)();

/// Called after the PiP panel is closed and the view controller is back to its original position
@property (nonatomic, copy, nullable) void (^pipDidClose)();

/// Set this property so the PiP panel reflects the current state when presented
@property (nonatomic, assign, getter=isPlaying) BOOL playing;

/// Whether the PIP is currently presenting its child view controller in picture-in-picture
@property (nonatomic, readonly, getter=isActive) BOOL active;

@end

