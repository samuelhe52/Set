//
//  BrightnessGradient.swift
//  Set
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

extension Color {
    /// Returns a `Gradient` with the lighter
    /// and the darker versions of the base color as its stops.
    var brightnessGradient: Gradient { brightnessGradient(contrast: 0.8) }
    
    /// Returns a `Gradient` with a given `contrast`, which is the difference
    /// of brightness between the lighter and the darker version of the base color used.
    func brightnessGradient(contrast: CGFloat) -> Gradient {
        let lighter = self.lightened(strength: contrast / 2)
        let darker = self.darkened(strength: contrast / 2)
        return Gradient(colors: [lighter, self, darker])
    }
}

extension Color {
    private func getHSB(_ col: Color) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        let uiColor = UIColor(col)
        uiColor.getHue(&hue,
                       saturation: &saturation,
                       brightness: &brightness,
                       alpha: &alpha)
        
        return (hue, saturation, brightness, alpha)
    }
    
    var lighter: Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0,
                     saturation: baseHSB.1,
                     brightness: baseHSB.2 + 0.4,
                     opacity: baseHSB.3)
    }
    
    func lightened(strength: Double) -> Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0,
                     saturation: baseHSB.1,
                     brightness: baseHSB.2 + strength,
                     opacity: baseHSB.3)
    }
    
    var darker: Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0,
                     saturation: baseHSB.1,
                     brightness: baseHSB.2 - 0.4,
                     opacity: baseHSB.3)
    }
    
    func darkened(strength: Double) -> Color {
        let baseHSB = getHSB(self)
        return Color(hue: baseHSB.0,
                     saturation: baseHSB.1,
                     brightness: baseHSB.2 - strength,
                     opacity: baseHSB.3)
    }
}

#Preview("Brightness Gradient") {
    RoundedRectangle(cornerRadius: 20)
        .fill(.linearGradient(Color.blue.brightnessGradient,
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading))
        .frame(width: 300, height: 400)
}
