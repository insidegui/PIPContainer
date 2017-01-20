//
//  PIPContainerViewController.m
//
//  Created by Guilherme Rambo on 30/10/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

#import "PIPContainerViewController.h"

#import "PIP.h"

@interface PIPContainerViewController () <PIPViewControllerDelegate>

@property (nonatomic, strong) PIPViewController *pip;
@property (assign) BOOL isInPip;
@property (weak) NSViewController *viewControllerForPip;

@end

@implementation PIPContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
}

- (IBAction)togglePIP:(id)sender
{
    if (self.isInPip) {
        [self __prepareForPipExit];
        [self.pip dismissViewController:self.viewControllerForPip];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pipWillOpen) self.pipWillOpen();
        });
        
        self.viewControllerForPip = self.childViewControllers.firstObject;
        [self.pip presentViewControllerAsPictureInPicture:self.viewControllerForPip];
        self.isInPip = YES;
    }
}

- (void)__prepareForPipExit
{
    // exiting PiP mode when the app is not active doesn't look right, so we make sure the app is active before the PiP exits here
    if (!NSApp.isActive) {
        [NSApp activateIgnoringOtherApps:YES];
        [self.view.window makeKeyAndOrderFront:nil];
    }
    
    // deminiaturize the window when exiting PiP mode
    if (self.view.window.isMiniaturized) {
        [self.view.window deminiaturize:nil];
    }
    
    // setup the pip for exiting
    self.pip.replacementRect = self.view.frame;
    self.pip.replacementWindow = self.view.window;
    self.pip.replacementView = self.view;
}

- (void)__finishPipExit
{
    // when the PiP is closed, it doesn't add the view back to the original superview, we have to do it manually
    self.viewControllerForPip.view.frame = self.view.bounds;
    [self.view addSubview:self.viewControllerForPip.view];
    self.viewControllerForPip.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
}

- (PIPViewController *)pip
{
    if (!_pip) {
        _pip = [[PIPViewController alloc] init];
        [_pip setAspectRatio:self.view.frame.size];
        [_pip setDelegate:self];
    }
    
    return _pip;
}

- (void)setPlaying:(BOOL)playing
{
    _playing = playing;
    
    [self.pip setPlaying:playing];
}

#pragma mark PIPViewControllerDelegate

- (void)pipWillClose:(PIPViewController *)pip
{
    if (self.pipWillClose) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pipWillClose) self.pipWillClose();
        });
    }
    
    [self __prepareForPipExit];
}

- (void)pipDidClose:(PIPViewController *)pip
{
    [self __finishPipExit];
    
    // pip is not needed (until the user clicks "toggle pip" again)
    self.pip = nil;
    self.isInPip = NO;
    
    if (self.pipDidClose) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pipDidClose) self.pipDidClose();
        });
    }
}

- (void)pipActionPlay:(PIPViewController *)pip
{
    if (self.pipDidPlay) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pipDidPlay) self.pipDidPlay();
        });
    }
}

- (void)pipActionPause:(PIPViewController *)pip
{
    if (self.pipDidPause) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pipDidPause) self.pipDidPause();
        });
    }
}

- (BOOL)isActive
{
    return _isInPip;
}

@end
