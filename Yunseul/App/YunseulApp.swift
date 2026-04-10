//
//  YunseulApp.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct YunseulApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: YunseulApp.store)
                .preferredColorScheme(.dark)
        }
    }
}
