//
//  BlockView.swift
//  hello-eggy-ios-swift
//
//  Created by Melinda Lu on 8/21/21.
//

import SwiftUI

struct BlockView: View {
    fileprivate let colorScheme: [(Color, Color)] = [
        // 2
        (Color(red:0.968, green:0.984, blue:1.000, opacity:1.00), Color.black),
        // 4
        (Color(red:0.871, green:0.922, blue:0.969, opacity:1.00), Color.black),
        // 8
        (Color(red:0.776, green:0.859, blue:0.937, opacity:1.00), Color.white),
        // 16
        (Color(red:0.620, green:0.792, blue:0.882, opacity:1.00), Color.white),
        // 32
        (Color(red:0.420, green:0.682, blue:0.839, opacity:1.00), Color.white),
        // 64
        (Color(red:0.259, green:0.573, blue:0.776, opacity:1.00), Color.white),
        // 128
        (Color(red:0.129, green:0.443, blue:0.710, opacity:1.00), Color.white),
        // 256
        (Color(red:0.031, green:0.188, blue:0.420, opacity:1.00), Color.white),
        // 512
        (Color(red:0.031, green:0.188, blue:0.420, opacity:1.00), Color.white),
        // 1024
        (Color(red:0.031, green:0.188, blue:0.420, opacity:1.00), Color.white),
        // 2048
        (Color(red:0.031, green:0.188, blue:0.420, opacity:1.00), Color.white),
    ]
    
    fileprivate let number: Int?
    fileprivate let textId: String?
    
    init(block: IdentifiedBlock) {
        self.number = block.number
        self.textId = "\(block.id):\(block.number)"
    }
    
    fileprivate init() {
        self.number = nil
        self.textId = ""
    }
    
    static func blank() -> Self {
        return self.init()
    }
    
    fileprivate var numberText: String {
        guard let number = number else {
            return ""
        }
        return String(number)
    }
    
    fileprivate var fontSize: CGFloat {
        let textLength = numberText.count
        if textLength < 3 {
            return 32
        } else if textLength < 4 {
            return 18
        } else {
            return 12
        }
    }
    
    fileprivate var colorPair: (Color, Color) {
        guard let number = number else {
            return (Color(red:0.620, green:0.792, blue:0.882, opacity:1.00), Color.white)
        }
        let index = Int(log2(Double(number))) - 1
        if index < 0 || index >= colorScheme.count {
            fatalError("No color defined for number")
        }
        return colorScheme[index]
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorPair.0)
                .zIndex(1)

            Text(numberText)
                .font(Font.system(size: fontSize).bold())
                .foregroundColor(colorPair.1)
                .id(textId!)
                .zIndex(1000) // removing this breaks removal transition
                .transition(AnyTransition.opacity.combined(with: .scale))
        }
        .clipped()
        .cornerRadius(6)
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach((1...11).map { Int(pow(2, Double($0))) }, id: \.self) { i in
                BlockView(block: IdentifiedBlock(id: 0, number: i))
                    .previewLayout(.sizeThatFits)
            }
            
            BlockView.blank()
                .previewLayout(.sizeThatFits)
        }
    }
}
