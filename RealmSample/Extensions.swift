//
//  Extensions.swift
//  RealmSample
//
//  Created by Artem Kvashnin on 26.05.2023.
//

import UIKit

extension UIColor {
    convenience init(rgb: Int) {
        let alpha = (rgb & 0xFF000000) >> 24
        let red = (rgb & 0x00FF0000) >> 16
        let green = (rgb & 0x0000FF00) >> 8
        let blue = (rgb & 0x000000FF)
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    func rgb() -> Int? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255)
            let iGreen = Int(fGreen * 255)
            let iBlue = Int(fBlue * 255)
            let iAlpha = Int(fAlpha * 255)
            
            let rgb: Int = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            return nil
        }
    }
}
