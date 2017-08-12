//
//  MPVolumeView.swift
//  YFVolumeController
//
//  Created by Yuri Fox on 10.08.17.
//  Copyright © 2017 Yuri Lysytsia. All rights reserved.
//

import MediaPlayer

fileprivate let application = UIApplication.shared

extension MPVolumeView {

    static var hiddenVolumeView: MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        
        volumeView.showsRouteButton = true
        volumeView.showsVolumeSlider = true
        
        return volumeView
    }
    
    static func hide() {
        let view = self.hiddenVolumeView
        let window = application.delegate?.window
        window??.addSubview(view)
    }
    
    static func present() {
        let window = application.delegate?.window
        window??.addSubview(MPVolumeView())
    }

}
