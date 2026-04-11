//
//  SplashView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    let store: Store<SplashFeature.State, SplashFeature.Action>
    
    @State private var starOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // 배경
            Color.Yunseul.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Spacer()
                
                // 별 아이콘
                Image(systemName: "star.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .opacity(titleOpacity)
                    .padding(.bottom, 28)
                
                // 앱 이름
                Text("윤슬")
                    .font(.custom("Georgia", size: 36))
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .tracking(12)
                    .opacity(titleOpacity)
                    .padding(.bottom, 12)
                
                // 영문
                Text("Yunseul")
                    .font(.custom("Georgia-Italic", size: 13))
                    .foregroundColor(Color.Yunseul.starBlue)
                    .tracking(6)
                    .opacity(titleOpacity)
                    .padding(.bottom, 48)
                
                // 구분선
                Rectangle()
                    .frame(width: 0.5, height: 36)
                    .foregroundColor(Color(hex: "2A3D6A"))
                    .opacity(subtitleOpacity)
                    .padding(.bottom, 48)
                
                // 태그라인
                VStack(spacing: 12) {
                    Text("당신의 별은 지금 이 순간")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color.Yunseul.textSecondary)
                        .tracking(2)
                    
                    Text("지구 어디를 비추고 있을까요?")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color.Yunseul.textSecondary)
                        .tracking(2)
                }
                .opacity(taglineOpacity)
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            store.send(.onAppear)
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 1.2)) {
            starOpacity = 1
        }
        withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
            titleOpacity = 1
        }
        withAnimation(.easeIn(duration: 1.0).delay(1.0)) {
            subtitleOpacity = 1
        }
        withAnimation(.easeIn(duration: 1.0).delay(1.4)) {
            taglineOpacity = 1
        }
    }
}

#Preview {
    SplashView(store: Store(initialState: SplashFeature.State()) {
        SplashFeature()
    })
}
