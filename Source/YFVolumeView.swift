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

    /// The **shared** current object. 
    /// You can configure a volume view through this variable
    public static let current: YFVolumeView = YFVolumeView(frame: UIApplication.shared.statusBarFrame)
    
    /// Status changes the activity of the YFVolumeView.
    /// If **true** then instead of the default MPVolumeView will be shown YFVolumeView.
    /// Default is false
    public var isActive: Bool = false {
        didSet {
            isActive ? self.addOutputVolumeObserve() : self.removeOutputVolumeObserve()
            isActive ? MPVolumeView.hide() : MPVolumeView.present()
        }
    }
    
    /// Status of present/hide animation
    /// Default is true
    public var isAnimatingEnable: Bool = true
    
    fileprivate var presentedTimer: Timer? //Hide view timer
    
    fileprivate var progressView: UIProgressView = UIProgressView(progressViewStyle: .default) // Volume
    
    /// The view’s background color.
    /// Default is white color
    public override var backgroundColor: UIColor? {
        didSet {
            guard let newValue = self.backgroundColor else {
                self.backgroundColor = UIColor.white
                return
            }
        
            let lightColor = newValue.colorWithSaturation(0.66)
            let darkColor = newValue.colorWithSaturation(0.33)
            
            self.progressView.progressTintColor = darkColor
            self.progressView.trackTintColor = lightColor
        }
    }
    
    /// Change view bakcground color. If window.rootViewController as UINavigationController, new background color will be equal UINavigationController.navigationBar.barTintColor
    ///
    /// - Parameter window: Window with root UINavigationController
    public func setBackgroundColorAsWindowWithRootNavigationBar(window: UIWindow) {
        guard let navigation = window.rootViewController as? UINavigationController else { return }
        let color = navigation.navigationBar.barTintColor
        self.backgroundColor = color
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
 
    deinit {
        self.isActive = false
    }
    
}

//MARK: - Prepare to init
extension YFVolumeView {
    
    fileprivate func prepareToInit() {
        
        self.setFrame()
        
        self.windowLevel = UIWindowLevelStatusBar
        
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        
        self.addSubview(self.progressView)
        
        self.progressView.progress = AVAudioSession.sharedInstance().outputVolume
        
    }
    
    fileprivate func setFrame() {
        let screenWidth = UIScreen.main.applicationFrame.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.frame = CGRect(x: 0, y: -statusBarHeight, width: screenWidth, height: statusBarHeight)
    }
    
}


//MARK: - Active
extension YFVolumeView {
    
    /// Update AVAudioSession.active state
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
    
    fileprivate func updateProgress(_ progress: Float, animated: Bool) {
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
    
    /// Present view
    public func present() {
        
        self.updateProgress(AVAudioSession.sharedInstance().outputVolume, animated: false)
        
        self.isHidden = false
        
        let delay: TimeInterval = self.isAnimatingEnable ? 0.25 : 0
        
        UIView.animate(withDuration: delay, animations: {
            self.frame.origin.y = 0
        }) { _ in
            self.scheduledPresentedTimer()
        }
        
    }
    
    /// Hide view
    public func hide() {
        
        let delay: TimeInterval = self.isAnimatingEnable ? 0.25 : 0
        
        UIView.animate(withDuration: delay, animations: {
            self.frame.origin.y = -self.frame.size.height
        }) { _ in
            self.isHidden = true
        }

    }
    
}
