//
//  ShakeEffect.swift
//  Set
//
//  Created by Samuel He on 2024/8/13.
//

import SwiftUI

struct ShakeEffect: ViewModifier {
    var shaking: Bool
    var singleShakeDuration: TimeInterval
        
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(shaking ? 7 : 0))
            .animation(
                shaking ?
                .easeInOut(duration: singleShakeDuration)
                .repeatForever() :
                        .default,
                       value: shaking)
    }
}

extension View {
    func shakeEffect(_ shaking: Bool,
                     singleShakeDuration: TimeInterval = 0.06
    ) -> some View {
        modifier(
            ShakeEffect(shaking: shaking,
                        singleShakeDuration: singleShakeDuration)
        )
    }
}
