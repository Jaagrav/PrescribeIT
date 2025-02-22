//
//  RootNavView.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 23/02/25.
//

import SwiftUI

struct RootNavView<SidebarContent: View, DetailContent: View>: View {
    @ViewBuilder let sidebar: SidebarContent
    @ViewBuilder let detail: DetailContent
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom != .phone {
            NavigationSplitView {
                sidebar
            } detail: {
                FeaturesView()
                detail
            }
        } else {
            detail
        }
    }
}
