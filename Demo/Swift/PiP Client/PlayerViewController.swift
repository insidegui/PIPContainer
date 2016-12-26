//
//  PlayerViewController.swift
//  PiP Client
//
//  Created by Guilherme Rambo on 26/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa

import PIPContainer
import AVFoundation

class PlayerViewController: NSViewController {

    private struct Constants {
        static let video = "http://p.events-delivery.apple.com.edgesuite.net/16oibfvohbfvoihbdfvoihbefv10/m3u8/atv_vod_mvp.m3u8"
    }
    
    private var player: AVPlayer!
    
    private var pip: PIPContainerViewController? {
        return parent as? PIPContainerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: Constants.video) else { return }
        
        player = AVPlayer(url: url)
        
        view.layer = AVPlayerLayer(player: player)
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        player.seek(to: CMTimeMakeWithSeconds(912, Int32(NSEC_PER_SEC)))
        player.play()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.titleVisibility = .hidden
        
        setupPIPSupport()
    }
    
    private func setupPIPSupport() {
        pip?.pipWillOpen = { [weak self] in
            guard let rate = self?.player.rate else { return }
            
            self?.pip?.isPlaying = (rate != 0.0)
        }
        
        pip?.pipDidPause = { [weak self] in
            self?.player.pause()
        }
        
        pip?.pipDidPlay = { [weak self] in
            self?.player.play()
        }
    }

}

