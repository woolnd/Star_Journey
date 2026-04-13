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
            ZStack(alignment: .bottom) {
                // 탭 콘텐츠
                Group {
                    switch viewStore.selectedTab {
                    case .home:
                        HomeView(store: store.scope(state: \.home, action: \.home))
                    case .traces:
                        TracesView(store: store.scope(state: \.traces, action: \.traces),
                                   homeStore: store.scope(state: \.home, action: \.home))
                    case .settings:
                        SettingsView(store: store.scope(state: \.settings, action: \.settings))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 커스텀 탭바
                customTabBar(viewStore: viewStore)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    // MARK: - 커스텀 탭바
    private func customTabBar(viewStore: ViewStore<AppFeature.State, AppFeature.Action>) -> some View {
        HStack(spacing: 0) {
            tabBarItem(
                icon: "star.fill",
                label: "홈",
                tab: .home,
                viewStore: viewStore
            )
            tabBarItem(
                icon: "moon.stars.fill",
                label: "별자취",
                tab: .traces,
                viewStore: viewStore
            )
            tabBarItem(
                icon: "gearshape.fill",
                label: "설정",
                tab: .settings,
                viewStore: viewStore
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            ZStack {
                // 블러 배경
                Color.Yunseul.surface
                    .opacity(0.95)
                
                // 상단 미세 선
                VStack {
                    Rectangle()
                        .fill(Color.Yunseul.border.opacity(0.3))
                        .frame(height: 0.5)
                    Spacer()
                }
            }
        )
    }
    
    private func tabBarItem(
        icon: String,
        label: String,
        tab: AppFeature.State.Tab,
        viewStore: ViewStore<AppFeature.State, AppFeature.Action>
    ) -> some View {
        let isSelected = viewStore.selectedTab == tab
        
        return Button {
            viewStore.send(.tabSelected(tab))
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    // 선택된 탭 배경 글로우
                    if isSelected {
                        Circle()
                            .fill(Color.Yunseul.starBlue.opacity(0.12))
                            .frame(width: 44, height: 44)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(
                            isSelected
                            ? Color.Yunseul.starBlue
                            : Color.Yunseul.textTertiary
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                .frame(width: 44, height: 44)
                
                Text(label)
                    .font(.Yunseul.captionLight)
                    .foregroundColor(
                        isSelected
                        ? Color.Yunseul.starBlue
                        : Color.Yunseul.textTertiary
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
