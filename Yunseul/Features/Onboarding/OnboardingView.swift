//
//  OnboardingView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    
    let store: Store<OnboardingFeature.State, OnboardingFeature.Action>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                // 배경
                Color.Yunseul.background
                    .ignoresSafeArea()
                
                // 성운 블롭
                NebulaView()
                
                // Step 화면
                Group {
                    switch viewStore.currentStep {
                    case .nickname:
                        NicknameStepView(viewStore: viewStore)
                            .transition(.opacity)
                    case .birthDate:
                        BirthDateStepView(viewStore: viewStore)
                            .transition(.opacity)
                    case .result:
                        ConstellationResultView(viewStore: viewStore)
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.8), value: viewStore.currentStep)
            }
        }
    }
}

// MARK: - 성운 블롭
struct NebulaView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.Yunseul.nebula1.opacity(0.5))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
                .blur(radius: 60)
            
            Circle()
                .fill(Color.Yunseul.nebula2.opacity(0.4))
                .frame(width: 250, height: 250)
                .offset(x: 120, y: 200)
                .blur(radius: 50)
        }
    }
}

// MARK: - Step 1: 닉네임
struct NicknameStepView: View {
    
    let viewStore: ViewStore<OnboardingFeature.State, OnboardingFeature.Action>
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 32))
                .foregroundColor(Color.Yunseul.starBlue)
                .padding(.bottom, 32)
            
            VStack(spacing: 10) {
                Text("당신을 뭐라고")
                    .font(.Yunseul.constellationName)
                    .foregroundColor(Color.Yunseul.textPrimary)
                
                Text("불러드릴까요?")
                    .font(.Yunseul.constellationName)
                    .foregroundColor(Color.Yunseul.textPrimary)
            }
            .padding(.bottom, 12)
            
            Text("별이 당신을 기억할 이름이에요")
                .font(.Yunseul.briefingSmall)
                .foregroundColor(Color.Yunseul.textSecondary)
                .padding(.bottom, 52)
            
            VStack(spacing: 0) {
                TextField("", text: viewStore.binding(
                    get: \.nickname,
                    send: OnboardingFeature.Action.nicknameChanged
                ))
                .font(.Yunseul.subheadline)
                .foregroundColor(Color.Yunseul.textPrimary)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .placeholder(when: viewStore.nickname.isEmpty) {
                    Text("닉네임을 입력해주세요")
                        .font(.Yunseul.subheadline)
                        .foregroundColor(Color.Yunseul.textTertiary)
                }
                .padding(.bottom, 12)
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(isFocused ?
                                     Color.Yunseul.starBlue : Color.Yunseul.border)
                    .animation(.easeInOut(duration: 0.5), value: isFocused)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 52)
            
            Button {
                viewStore.send(.nicknameNextTapped)
                isFocused = false
            } label: {
                Text("다음")
                    .font(.Yunseul.callout)
                    .foregroundColor(viewStore.nickname.isEmpty
                                     ? Color.Yunseul.textTertiary
                                     : Color.Yunseul.starBlue)
                    .tracking(4)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                viewStore.nickname.isEmpty
                                ? Color.Yunseul.border.opacity(0.3)
                                : Color.Yunseul.starBlue.opacity(0.3),
                                lineWidth: 0.5
                            )
                    )
            }
            .disabled(viewStore.nickname.isEmpty)
            .padding(.horizontal, 48)
            
            Spacer()
            Spacer()
        }
        .onAppear { isFocused = true }
    }
}

// MARK: - Step 2: 생년월일
struct BirthDateStepView: View {
    
    let viewStore: ViewStore<OnboardingFeature.State, OnboardingFeature.Action>
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 32))
                .foregroundColor(Color.Yunseul.starBlue)
                .padding(.bottom, 32)
            
            VStack(spacing: 0) {
                Text("\(viewStore.nickname)님의")
                    .font(.Yunseul.constellationName)    
                    .foregroundColor(Color.Yunseul.textPrimary)
                
                Text("태어난 날은요?")
                    .font(.Yunseul.constellationName)
                    .foregroundColor(Color.Yunseul.textPrimary)
            }
            .padding(.bottom, 12)
            
            Text("별자리를 찾기 위해 필요해요")
                .font(.Yunseul.briefingSmall)
                .foregroundColor(Color.Yunseul.textSecondary)
                .padding(.bottom, 48)
            
            DatePicker(
                "",
                selection: viewStore.binding(
                    get: \.birthDate,
                    send: OnboardingFeature.Action.birthDateChanged
                ),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .colorScheme(.light)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
            
            Button {
                viewStore.send(.birthDateNextTapped)
            } label: {
                Text("내 별자리 찾기")
                    .font(.Yunseul.callout)
                    .foregroundColor(Color.Yunseul.starBlue)
                    .tracking(4)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color.Yunseul.starBlue.opacity(0.3),
                                lineWidth: 0.5
                            )
                    )
            }
            .padding(.horizontal, 48)
            
            Spacer()
            Spacer()
        }
    }
}

// MARK: - Step 3: 별자리 결과
struct ConstellationResultView: View {
    
    let viewStore: ViewStore<OnboardingFeature.State, OnboardingFeature.Action>
    @State private var starOpacity: Double = 0
    @State private var nameOpacity: Double = 0
    @State private var descOpacity: Double = 0
    @State private var btnOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ConstellationShapeView(constellation: viewStore.constellation)
                .opacity(starOpacity)
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                Text(viewStore.constellation.rawValue)
                    .font(.Yunseul.constellationName)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .tracking(4)
                
                Text(viewStore.constellation.latinName)
                    .font(.Yunseul.constellationSub)
                    .foregroundColor(Color.Yunseul.textSecondary)
                    .tracking(3)
            }
            .opacity(nameOpacity)
            .padding(.bottom, 40)
            
            Rectangle()
                .frame(width: 0.5, height: 32)
                .foregroundColor(Color.Yunseul.border)
                .opacity(descOpacity)
                .padding(.bottom, 40)
            
            Text(viewStore.constellationDescription)
                .font(.Yunseul.story)
                .foregroundColor(Color.Yunseul.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .opacity(descOpacity)
                .padding(.horizontal, 48)
                .padding(.bottom, 52)
            
            Button {
                viewStore.send(.beginTapped)
            } label: {
                Group {
                    if viewStore.isLoading {
                        ProgressView()
                            .tint(Color.Yunseul.starBlue)
                    } else {
                        Text("별빛을 따라가기")
                            .font(.Yunseul.callout)       
                            .foregroundColor(Color.Yunseul.starBlue)
                            .tracking(4)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color.Yunseul.starBlue.opacity(0.3),
                            lineWidth: 0.5
                        )
                )
            }
            .disabled(viewStore.isLoading)
            .opacity(btnOpacity)
            .padding(.horizontal, 48)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) { starOpacity = 1 }
            withAnimation(.easeIn(duration: 0.8).delay(0.4)) { nameOpacity = 1 }
            withAnimation(.easeIn(duration: 0.8).delay(0.8)) { descOpacity = 1 }
            withAnimation(.easeIn(duration: 0.8).delay(1.2)) { btnOpacity = 1 }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .center) {
            if shouldShow { placeholder() }
            self
        }
    }
}

#Preview {
    OnboardingView(store: Store(
        initialState: OnboardingFeature.State()
    ) {
        OnboardingFeature()
    })
}
