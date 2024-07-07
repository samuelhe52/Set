//
//  SetCard.swift
//  Set
//
//  Created by Samuel He on 2024/7/6.
//

import Foundation
import SwiftUI

struct SetCard: Identifiable, CustomStringConvertible {
    // card properties declaration
    private(set) var shape: Shapes
    private(set) var shapeCount: ShapeCount
    private(set) var shading: Shadings
    private(set) var color: CardColor
    
    var selected: Bool = false
    
    var id: UUID = UUID()
    var description: String { "A card with \(shapeCount.rawValue) \(color.description) \(shading.description) \(shape.description)(s)" }
    
    // MARK: - Enumerations for card properties
    
    enum Shapes: CustomStringConvertible, CaseIterable, Identifiable {
        case diamond, squiggle, oval
        
        var description: String {
            switch self {
            case .diamond:
                return "diamond"
            case .squiggle:
                return "squiggle"
            case .oval:
                return "oval"
            }
        }
        
        var id: String { self.description }
    }

    enum ShapeCount: Int, CaseIterable {
        case one = 1, two, three
    }

    enum Shadings: CustomStringConvertible, CaseIterable {
        case solid, striped, open
        
        var description: String {
            switch self {
            case .solid:
                return "solid"
            case .striped:
                return "striped"
            case .open:
                return "open"
            }
        }
    }
    
    enum CardColor: CustomStringConvertible, CaseIterable {
        case purple, pink, blue
        
        var description: String {
            switch self {
            case .purple:
                return "purple"
            case .pink:
                return "green"
            case .blue:
                return "blue"
            }
        }
    }
}
