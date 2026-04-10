//
//  MainTabView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    
    let store: Store<AppFeature.State, AppFeature.Action>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.selectedTab,
                send: AppFeature.Action.tabSelected
            )) {
                HomeView(store: store.scope(
                    state: \.home, action: \.home
                ))
                    .tabItem {
                        Label("홈", systemImage: "star.fill")
                    }
                    .tag(AppFeature.State.Tab.home)
                
                TracesView(store: store.scope(
                    state: \.traces, action: \.traces
                ))
                    .tabItem {
                        Label("흔적", systemImage: "moon.stars.fill")
                    }
                    .tag(AppFeature.State.Tab.traces)
                
                SettingsView(store: store.scope(
                    state: \.settings, action: \.settings
                ))
                    .tabItem {
                        Label("설정", systemImage: "gearshape.fill")
                    }
                    .tag(AppFeature.State.Tab.settings)
            }
        }
    }
}

#Preview {
    MainTabView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
