# YFVolumeView
Convenient, beautiful and easy to use volume indicator written in Swift 3

![YFVolumeView: Elegant Volume View as Instagram](https://github.com/YuriFox/YFVolumeView/blob/master/example.gif)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)


## Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build.


To integrate YFVolumeView into your Xcode project using CocoaPods, create `Podfile`. 
Run the following command in root folder of your project:

```bash
$ pod init
```

In the `Podfile` that appears, specify:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘8.0’
use_frameworks!

target '<Your Target Name>' do
	pod 'YFVolumeView'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

In your project AppDelegate.swift:

```swift
import YFVolumeView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    ...
    
    func setVolumeIndicator() {
        
        let volumeIndicator = YFVolumeView.current
        volumeIndicator.isActive = true // Make active YFVolumeView and hide native HUD
        volumeIndicator.backgroundColor = .white // Set custom background color
        volumeIndicator.isAnimatingEnable = true // Change animation enable 

//        if let window = self.window {
//            volumeIndicator.setBackgroundColorAsWindowWithRootNavigationBar(window: window)
//            // If AppDelegate.window.rootViewController is UINavigationController, volume indicator color will be as UINavigationController.navigationBar.barTintColor
//        }


    }

    ...

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ...
        
        self.setVolumeIndicator()
        
        ...

    }

    ...
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        YFVolumeView.current.updateActiveState() // FIX.
    }

...

}

```
