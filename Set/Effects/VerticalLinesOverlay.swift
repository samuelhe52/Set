//
//  VerticalLinesOverlay.swift
//  Set
//
//  Created by Samuel He on 2024/7/12.
//

import SwiftUI

struct VerticalLinesShape: Shape {
    var lineSpacing: CGFloat = 15
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let numberOfLines = Int(rect.width / lineSpacing)
        
        for lineCount in 0...numberOfLines {
            let x = CGFloat(lineCount) * lineSpacing
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        return path
    }
}

extension Shape {
    func verticalLinesOverlay(lineWidth: CGFloat = 2, lineSpacing: CGFloat = 15) -> some View {
        let base = VerticalLinesShape(lineSpacing: lineSpacing).stroke(lineWidth: lineWidth)
        return ZStack {
            self.stroke(lineWidth: lineWidth)
            base.clipShape(self)
        }
    }
}

#Preview("Vertical Lines") {
    HStack {
        VerticalLinesShape(lineSpacing: 15)
            .stroke(lineWidth: 2)
            .padding()
        Circle()
            .verticalLinesOverlay()
            .frame(width: 150)
            .padding()
    }
    .background(.blue)
    .padding()
}
