//
//  PlayerViewController.m
//  PiP Client
//
//  Created by Guilherme Rambo on 26/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

#import "PlayerViewController.h"

@import PIPContainer;

@import AVFoundation;

@interface PlayerViewController ()

@property (strong) AVPlayer *player;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://p.events-delivery.apple.com.edgesuite.net/16oibfvohbfvoihbdfvoihbefv10/m3u8/atv_vod_mvp.m3u8"]];
    self.view.layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.view.layer.backgroundColor = [NSColor blackColor].CGColor;
    [self.player seekToTime:CMTimeMakeWithSeconds(912, NSEC_PER_SEC)];
    [self.player play];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    self.view.window.titleVisibility = NSWindowTitleHidden;
    
    [self setupPIPSupport];
}

- (void)setupPIPSupport
{
    if (![self.parentViewController isKindOfClass:[PIPContainerViewController class]]) return;
    
    __weak PIPContainerViewController *pipContainer = (PIPContainerViewController *)self.parentViewController;
    
    __weak typeof(self) welf = self;
    
    [pipContainer setPipWillOpen:^{
        [pipContainer setPlaying:(self.player.rate != 0)];
    }];
    
    [pipContainer setPipDidPlay:^{
        [welf.player play];
    }];
    
    [pipContainer setPipDidPause:^{
        [welf.player pause];
    }];
}

@end
