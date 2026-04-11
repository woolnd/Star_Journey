//
//  StarStoryView.swift
//  Yunseul
//
//  Created by wodnd on 4/12/26.
//

import SwiftUI

struct StarStoryView: View {
    
    let constellation: Constellation
    @State private var currentPage: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    private let pages: [StoryPage]
    
    init(constellation: Constellation) {
        self.constellation = constellation
        self.pages = constellation.storyPages
    }
    
    var body: some View {
        ZStack {
            // 배경
            Color.Yunseul.background
                .ignoresSafeArea()
            
            // 성운 효과
            nebulaBackground
            
            VStack(spacing: 0) {
                // 헤더
                headerSection
                
                // 페이지 뷰
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        storyPageView(page: page, index: index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // 하단 네비게이션
                bottomNavigation
                    .padding(.bottom, 48)
            }
        }
    }
    
    // MARK: - 성운 배경
    private var nebulaBackground: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "1a2d60").opacity(0.12))
                .frame(width: 350, height: 350)
                .offset(x: -80, y: -300)
                .blur(radius: 80)
            
            Circle()
                .fill(Color(hex: "2a1d60").opacity(0.08))
                .frame(width: 280, height: 280)
                .offset(x: 100, y: 200)
                .blur(radius: 60)
        }
    }
    
    // MARK: - 헤더
    private var headerSection: some View {
        ZStack {
            // 중앙 타이틀
            VStack(spacing: 4) {
                Text(constellation.rawValue)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(Color.Yunseul.textTertiary)
                    .tracking(3)
                
                // 페이지 인디케이터
                HStack(spacing: 6) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage
                                  ? Color.Yunseul.starBlue
                                  : Color.Yunseul.border)
                            .frame(width: index == currentPage ? 20 : 6, height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // 좌측 닫기
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(Color.Yunseul.surface)
                        )
                }
                Spacer()
                
                // 페이지 번호
                Text("\(currentPage + 1) / \(pages.count)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color.Yunseul.textTertiary)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    // MARK: - 스토리 페이지
    private func storyPageView(page: StoryPage, index: Int) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // 별자리 이미지 (첫 페이지만)
                if index == 0 {
                    HStack {
                        Spacer()
                        Image(constellation.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .opacity(0.7)
                            .shadow(color: Color.Yunseul.starBlue.opacity(0.5), radius: 16)
                        Spacer()
                    }
                    .padding(.bottom, 32)
                }
                
                // 장 제목
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.Yunseul.starBlue.opacity(0.6))
                        .frame(width: 2, height: 16)
                    
                    Text(page.title)
                        .font(.custom("Georgia", size: 13))
                        .foregroundColor(Color.Yunseul.starBlue)
                        .tracking(2)
                }
                .padding(.bottom, 24)
                
                // 본문
                Text(page.content)
                    .font(.custom("Georgia-Italic", size: 17))
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                
                // 마지막 페이지 장식
                if index == pages.count - 1 {
                    HStack {
                        Spacer()
                        Text("✦")
                            .font(.system(size: 20))
                            .foregroundColor(Color.Yunseul.starBlue.opacity(0.5))
                            .padding(.top, 40)
                        Spacer()
                    }
                }
                
                Spacer().frame(height: 60)
            }
            .padding(.horizontal, 28)
        }
    }
    
    // MARK: - 하단 네비게이션
    private var bottomNavigation: some View {
        HStack(spacing: 16) {
            // 이전 버튼
            Button {
                withAnimation {
                    currentPage = max(0, currentPage - 1)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12))
                    Text("이전")
                        .font(.Yunseul.footnote)
                }
                .foregroundColor(currentPage == 0
                                 ? Color.Yunseul.textTertiary.opacity(0.3)
                                 : Color.Yunseul.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.Yunseul.border.opacity(currentPage == 0 ? 0.15 : 0.3),
                                lineWidth: 0.5)
                )
            }
            .disabled(currentPage == 0)
            
            // 다음 / 완료 버튼
            Button {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    dismiss()
                }
            } label: {
                HStack(spacing: 6) {
                    Text(currentPage < pages.count - 1 ? "다음" : "완료")
                        .font(.Yunseul.footnote)
                    if currentPage < pages.count - 1 {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(Color.Yunseul.starBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Yunseul.starBlue.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                        )
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

#Preview {
    StarStoryView(constellation: .aries)
}
