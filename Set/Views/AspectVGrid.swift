//
//  AspectVGrid.swift
//  Set
//
//  Created by Samuel He on 2024/7/30.
//

import SwiftUI

struct AspectVGrid<
    Items: RandomAccessCollection,
    ItemView: View
>: View where Items.Element: Identifiable {
    var items: Items
    var aspectRatio: CGFloat = 1
    var minWidth: CGFloat
    var allRowsFilled: Bool = false
    @ViewBuilder var contentBuilder: (Items.Element) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            let columnCount = properColumnCount(
                itemCount: items.count,
                totalWidth: geometry.size.width,
                minWidth: minWidth,
                allRowsFilled: allRowsFilled
            )
            
            let itemWidth = geometry.size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            let rowCount = (CGFloat(items.count) / CGFloat(columnCount)).rounded(.up)
            
            let scrolling = rowCount * itemHeight > geometry.size.height
            
            return Group {
                if scrolling {
                    if #available(iOS 16.0, *) {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth),
                                                         spacing: 0)],
                                      spacing: 0
                            ) {
                                ForEach(items) { item in
                                    contentBuilder(item)
                                        .aspectRatio(aspectRatio, contentMode: .fill)
                                }
                            }
                        }.scrollIndicators(.never)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth),
                                                         spacing: 0)],
                                      spacing: 0
                            ) {
                                ForEach(items) { item in
                                    contentBuilder(item)
                                        .aspectRatio(aspectRatio, contentMode: .fill)
                                }
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth), spacing: 0)], spacing: 0) {
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
        totalWidth: CGFloat,
        minWidth: CGFloat = 0,
        allRowsFilled: Bool = false
    ) -> Int {
        var columnCount = min(itemCount, Int(totalWidth / minWidth))
        
        while columnCount > 0 {
            let itemWidth = totalWidth / CGFloat(columnCount)
            
            if itemWidth >= minWidth && (!allRowsFilled || itemCount % columnCount == 0) {
                break
            }
            columnCount -= 1
        }
        return columnCount
    }
}

