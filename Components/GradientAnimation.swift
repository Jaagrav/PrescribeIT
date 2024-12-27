//
//  GradientAnimation.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/12/24.
//

import SwiftUI
import FluidGradient
import UIKit

struct GradientAnimation: View {    
    var body: some View {
        VStack {
            ZStack {
                FluidGradient(
                    blobs: [.red, .green, .blue],
                    highlights: [.orange, .purple, .teal],
                    speed: 1.0,
                    blur: 0.7
                )
                .background(.quaternary)
                .frame(height: 350)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color(UIColor.systemBackground)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 350)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
}

#Preview {
    GradientAnimation()
}
