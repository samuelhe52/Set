//
//  BrightnessGradient.swift
//  Set
//
//  Created by Samuel He on 2024/6/10.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

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
    private func getHSB(_ col: Color) -> (h: CGFloat,
                                          s: CGFloat,
                                          b: CGFloat,
                                          a: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        #if os(macOS)
        NSColor(col)
            .usingColorSpace(.sRGB)?
            .getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        #else
        UIColor(col).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        #endif
        
        return (h, s, b, a)
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
