//
//  YFColor.swift
//  YFVolumeController
//
//  Created by Yuri Fox on 12.08.17.
//  Copyright © 2017 Yuri Lysytsia. All rights reserved.
//

import UIKit

extension UIColor {
    
    var rgbComponents: UIColorRGBComponents? {
        return UIColorRGBComponents(color: self)
    }
    
    var whiteComponents: UIColorWhiteComponents? {
        return UIColorWhiteComponents(color: self)
    }
    
    func colorWithSaturation(_ saturation: CGFloat) -> UIColor? {
        
        if let rgbComponents = self.rgbComponents {
            return rgbComponents.color(saturation: saturation)
        }
        
        if let whiteComponents = self.whiteComponents {
            return whiteComponents.color(saturation: saturation)
        }
        
        return nil
        
    }
    
}

struct UIColorRGBComponents {
    
    var red, green, blue, alpha: CGFloat
    
    init?(color: UIColor) {
        guard let components = color.cgColor.components, components.count == 4 else { return nil }
        
        self.red = components[0]
        self.green = components[1]
        self.blue = components[2]
        self.alpha = color.cgColor.alpha
        
    }
    
    func color(saturation: CGFloat) -> UIColor {
        let red = saturation * self.red
        let green = saturation * self.green
        let blue = saturation * self.blue
        
        return UIColor(red: red, green: green, blue: blue, alpha: self.alpha)
    }
    
}

struct UIColorWhiteComponents {
    
    var white, alpha: CGFloat
    
    init?(color: UIColor) {
        guard let components = color.cgColor.components, components.count == 2 else { return nil }
        
        self.white = components[0]
        self.alpha = color.cgColor.alpha
    }
    
    func color(saturation: CGFloat) -> UIColor {
        let white = saturation * self.white
        
        return UIColor(white: white, alpha: self.alpha)
    }

    
}
