//
//  Extension.swift
//  YFVolumeController
//
//  Created by Yuri Fox on 08.08.17.
//  Copyright © 2017 Yuri Lysytsia. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate let audioSession = AVAudioSession.sharedInstance()
let outputVolumeKey = "outputVolume"

extension UIApplication {
    
    func setOutputVolumeActive(_ active: Bool) {
        try? audioSession.setActive(active)
    }
    
    func addOutputVolumeObserve() {
        
        self.setOutputVolumeActive(true)
        audioSession.addObserver(self, forKeyPath: outputVolumeKey, options: [.new], context: nil)
        
    }
    
    func removeOutputVolumeObserve() {
        
        setOutputVolumeActive(false)
        audioSession.removeObserver(self, forKeyPath: outputVolumeKey)
        
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == outputVolumeKey else { return }
        guard let audioSession = object as? AVAudioSession else { return }
        
        let name = Notification.Name.AVAudioSessionOutputVolumeDidChange
        NotificationCenter.default.post(name: name, object: audioSession.outputVolume)
        
    }
    
}

public extension Notification.Name {
    
    static let AVAudioSessionOutputVolumeDidChange = Notification.Name(outputVolumeKey)
    
}
