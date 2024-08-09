//
//  AspectVGrid.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import SwiftUI

struct AspectVGrid<Items: RandomAccessCollection, ItemView: View>: View where Items.Element: Identifiable {
    var items: Items
    var aspectRatio: CGFloat = 1
    var minWidth: CGFloat
    var allRowsFilled: Bool = false
    @ViewBuilder var contentBuilder: (Items.Element) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let columnCount = properColumnCount(
                itemCount: items.count,
                size: geometry.size,
                minWidth: minWidth,
                allRowsFilled: allRowsFilled
            )
            
            let width = geometry.size.width / CGFloat(columnCount)
            let height = width / aspectRatio
            let rowCount = (CGFloat(items.count) / CGFloat(columnCount)).rounded(.up)
            
            let scrolling = rowCount * height > geometry.size.height
            
            return Group {
                if scrolling {
                    if #available(iOS 16.0, *) {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)], spacing: 0) {
                                ForEach(items) { item in
                                    contentBuilder(item)
                                        .aspectRatio(aspectRatio, contentMode: .fill)
                                }
                            }
                        }.scrollIndicators(.never)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)], spacing: 0) {
                                ForEach(items) { item in
                                    contentBuilder(item)
                                        .aspectRatio(aspectRatio, contentMode: .fill)
                                }
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)], spacing: 0) {
                        ForEach(items) { item in
                            contentBuilder(item)
                                .aspectRatio(aspectRatio, contentMode: .fill)
                        }
                    }
                }
            }
            
        }
    }
    
    func properColumnCount(
        itemCount: Int,
        size: CGSize,
        minWidth: CGFloat = 0,
        allRowsFilled: Bool = false
    ) -> Int {
        var columnCount = itemCount
        let totalWidth = size.width
        
        while columnCount > 0 {
            let itemWidth = totalWidth / CGFloat(columnCount)
            
            if allRowsFilled {
                if itemWidth > minWidth && (itemCount % columnCount == 0) {
                    break
                } else {
                    columnCount -= 1
                }
            } else {
                if itemWidth > minWidth {
                    break
                } else {
                    columnCount -= 1
                }
            }
        }
        return columnCount
    }
}

