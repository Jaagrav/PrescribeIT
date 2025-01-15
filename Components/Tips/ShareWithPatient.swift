//
//  SwiftUIView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 15/01/25.
//

import SwiftUI
import TipKit

@available(iOS 17.0, *)
struct HistoryTip: Tip {
    var id = UUID()
    
    @Parameter
    static var alreadyDiscovered: Bool = false

    var title: Text {
        Text("Access your order's history!")
    }

    var message: Text? {
        Text("You can quickly repeat any order you want")
    }

    var rules: [Rule] {
        [
            #Rule(Self.$alreadyDiscovered) { $0 == false }
        ]
    }
}
