//
//  YFVolumeView.swift
//  YFVolumeView
//
//  Created by Yuri Fox on 04.08.17.
//  Copyright © 2017 Yuri Lysytsia. All rights reserved.
//

import UIKit
import MediaPlayer

public class YFVolumeView: UIWindow {

    /// The shared current object
    public static var current: YFVolumeView = YFVolumeView(frame: UIApplication.shared.statusBarFrame)
    
    /// Статус который показывает или работает static let current при изменении громкости
    public var isActive: Bool = false {
        didSet {
            isActive ? self.addOutputVolumeObserve() : self.removeOutputVolumeObserve()
            MPVolumeView.hide()
        }
    }
    
    /// Таймер который отвечает за hide view
    fileprivate var presentedTimer: Timer?
    
    /// Progress view
    fileprivate var progressView: UIProgressView = UIProgressView(progressViewStyle: .default)
    
    
    /// Background color change view color and progressView color
    public override var backgroundColor: UIColor? {
        
        didSet {
            
            guard let newValue = self.backgroundColor else { return }
        
            let lightColor = newValue.colorWithSaturation(0.66)
            let darkColor = newValue.colorWithSaturation(0.33)
            
            self.progressView.progressTintColor = darkColor
            self.progressView.trackTintColor = lightColor
            
        }
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareToInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareToInit()
    }
    
    public override func draw(_ rect: CGRect) {
        self.makeProgressViewConstraints(rect: rect)
    }
    
}

//MARK: - Init
extension YFVolumeView {
    
    fileprivate func prepareToInit() {
        
        self.windowLevel = UIWindowLevelStatusBar
        
        self.addSubview(self.progressView)
        
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        
        self.progressView.progress = AVAudioSession.sharedInstance().outputVolume
        
    }
    
    public func setBackgroundColorAsWindowWithRootNavigationBar(window: UIWindow) {
        guard let navigation = window.rootViewController as? UINavigationController else { return }
        let color = navigation.navigationBar.barTintColor
        self.backgroundColor = color
    }
    
}


//MARK: - Active
extension YFVolumeView {
    
    public func updateActiveState() {
        UIApplication.shared.setOutputVolumeActive(self.isActive)
    }
    
}

//MARK: - Presented Timer
fileprivate extension YFVolumeView {
    
    func scheduledPresentedTimer() {
        
        if let timer = self.presentedTimer, timer.isValid {
            self.invalidatePresentedTimer()
        }
        
        self.presentedTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
    }
    
    func invalidatePresentedTimer() {
        self.presentedTimer?.invalidate()
        self.presentedTimer = nil
    }
    
}

//MARK: - Progress
extension YFVolumeView {
    
    func updateProgress(_ progress: Float, animated: Bool) {
        self.progressView.setProgress(progress, animated: animated)
        self.scheduledPresentedTimer()
    }
    
    fileprivate func makeProgressViewConstraints(rect: CGRect) {
        
        let centerY = rect.midY - 1
        let width = rect.width - 16
        
        self.progressView.frame = CGRect(x: 8, y: centerY, width: width, height: 2)
        
    }
}

//MARK: - Output Volume Observe
extension YFVolumeView {
    
    fileprivate func addOutputVolumeObserve() {
        UIApplication.shared.addOutputVolumeObserve()
        
        NotificationCenter.default.addObserver(forName: .AVAudioSessionOutputVolumeDidChange, object: nil, queue: nil) { (notification) in
            
            guard let outputVolume = notification.object as? Float else { return }
            
            self.isHidden ? self.present() : self.updateProgress(outputVolume, animated: true)
            
        }
    }
    
    fileprivate func removeOutputVolumeObserve() {
        UIApplication.shared.removeOutputVolumeObserve()
        
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionOutputVolumeDidChange, object: nil)
    }
    
}

//MARK: - Present
extension YFVolumeView {
    
    public func present() {
        
        self.isHidden = false
        self.scheduledPresentedTimer()
        
    }
    
    public func hide() {
        
        self.isHidden = true

    }
    
}
