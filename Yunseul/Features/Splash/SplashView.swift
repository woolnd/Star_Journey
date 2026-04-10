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
            
            // 별 파티클
            StarParticleView()
                .opacity(starOpacity)
            
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

// 별 파티클
struct StarParticleView: View {
    
    let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, duration: Double)] = (0..<40).map { _ in
        (
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 1...2.5),
            duration: Double.random(in: 2...5)
        )
    }
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<stars.count, id: \.self) { i in
                Circle()
                    .fill(Color(hex: "C2D3F5"))
                    .frame(width: stars[i].size, height: stars[i].size)
                    .position(
                        x: stars[i].x * geo.size.width,
                        y: stars[i].y * geo.size.height
                    )
                    .opacity(Double.random(in: 0.2...0.8))
                    .animation(
                        .easeInOut(duration: stars[i].duration)
                        .repeatForever(autoreverses: true),
                        value: stars[i].duration
                    )
            }
        }
    }
}

#Preview {
    SplashView(store: Store(initialState: SplashFeature.State()) {
        SplashFeature()
    })
}
