//
//  SettingsView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    
    @Bindable var store: Store<SettingsFeature.State, SettingsFeature.Action>
    @State private var isNicknameSheetPresented: Bool = false
    @State private var isBirthDateSheetPresented: Bool = false
    @State private var showBirthDateWarning: Bool = false
    
    @State private var didOpenSettings: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            Color.Yunseul.background.ignoresSafeArea()
            NebulaView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerSection
                    profileSection
                    notificationSection
                    appInfoSection
                    Spacer().frame(height: 100)
                }
                .padding(.top, 60)
            }
        }
        .sheet(isPresented: $isNicknameSheetPresented) {
            nicknameSheet
        }
        .sheet(isPresented: $isBirthDateSheetPresented) {
            BirthDateSheetView(
                store: store,
                showWarning: $showBirthDateWarning
            )
        }
        .onChange(of: store.isNicknameSheetPresented) { _, newValue in
            isNicknameSheetPresented = newValue
        }
        .onChange(of: store.isBirthDateSheetPresented) { _, newValue in
            isBirthDateSheetPresented = newValue
        }
        .onChange(of: isNicknameSheetPresented) { _, newValue in
            if !newValue { store.send(.nicknameSheetDismissed) }
        }
        .onChange(of: isBirthDateSheetPresented) { _, newValue in
            if !newValue { store.send(.birthDateSheetDismissed) }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && didOpenSettings {
                store.send(.onAppear)
                didOpenSettings = false
            }
        }
    }
    
    // MARK: - 헤더
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text(String(localized: "settings.title"))
                .font(.Yunseul.appTitle)
                .foregroundColor(Color.Yunseul.textPrimary)
                .tracking(6)
            
            Text(String(localized: "settings.subtitle"))
                .font(.Yunseul.captionLight)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(2)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - 프로필 섹션
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel(String(localized: "settings.section.profile"))
            
            VStack(spacing: 0) {
                settingRow(
                    icon: "person.fill",
                    title: String(localized: "settings.profile.nickname"),
                    value: store.nickname.isEmpty
                        ? String(localized: "settings.profile.nickname.empty")
                        : store.nickname
                ) { store.send(.nicknameEditTapped) }
                
                divider
                
                settingRow(
                    icon: "birthday.cake.fill",
                    title: String(localized: "settings.profile.birthday"),
                    value: birthDateString(from: store.birthDate)
                ) { store.send(.birthDateEditTapped) }
                
                divider
                
                // 수호성 (읽기 전용)
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.Yunseul.elevated)
                            .frame(width: 36, height: 36)
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundColor(Color.Yunseul.starBlue)
                    }
                    
                    Text(String(localized: "settings.profile.guardian"))
                        .font(.Yunseul.footnote)
                        .foregroundColor(Color.Yunseul.textTertiary)
                    
                    Spacer()
                    
                    Text(store.constellation.rawValue)
                        .font(.Yunseul.footnote)
                        .foregroundColor(Color.Yunseul.textPrimary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color.Yunseul.surface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 알림 섹션
    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel(String(localized: "settings.section.notification"))
            
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.Yunseul.elevated)
                            .frame(width: 36, height: 36)
                        Image(systemName: "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color.Yunseul.starBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(String(localized: "settings.notification.title"))
                            .font(.Yunseul.footnote)
                            .foregroundColor(Color.Yunseul.textPrimary)
                        Text(String(localized: "settings.notification.subtitle"))
                            .font(.Yunseul.captionLight)
                            .foregroundColor(Color.Yunseul.textTertiary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { store.isNotificationEnabled },
                        set: { newValue in
                            if newValue {
                                Task {
                                    let status = await NotificationService.shared.authorizationStatus()
                                    if status == .denied {
                                        didOpenSettings = true
                                    }
                                    store.send(.notificationToggled(newValue))
                                }
                            } else {
                                store.send(.notificationToggled(newValue))
                            }
                        }
                    ))
                    .tint(Color.Yunseul.starBlue)
                    .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color.Yunseul.surface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 앱 정보 섹션
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel(String(localized: "settings.section.appinfo"))
            
            VStack(spacing: 0) {
                HStack {
                    Text(String(localized: "settings.appinfo.version"))
                        .font(.Yunseul.footnote)
                        .foregroundColor(Color.Yunseul.textTertiary)
                    Spacer()
                    Text(appVersion)
                        .font(.Yunseul.footnote)
                        .foregroundColor(Color.Yunseul.textPrimary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                divider
                
                Button {
                    if let url = URL(string: "https://github.com/woolnd") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text(String(localized: "settings.appinfo.developer"))
                            .font(.Yunseul.footnote)
                            .foregroundColor(Color.Yunseul.textTertiary)
                        Spacer()
                        HStack(spacing: 6) {
                            Text("wodnd")
                                .font(.Yunseul.footnote)
                                .foregroundColor(Color.Yunseul.textPrimary)
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 10))
                                .foregroundColor(Color.Yunseul.textTertiary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
            .background(Color.Yunseul.surface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
            )
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 닉네임 시트
    private var nicknameSheet: some View {
        ZStack {
            Color.Yunseul.background.ignoresSafeArea()
            NebulaView()
            
            VStack(spacing: 24) {
                Text(String(localized: "settings.nickname.sheet.title"))
                    .font(.Yunseul.subheadline)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .tracking(2)
                    .padding(.top, 32)
                
                VStack(alignment: .leading, spacing: 8) {
                    TextField(String(localized: "settings.nickname.sheet.placeholder"), text: Binding(
                        get: { store.editingNickname },
                        set: { store.send(.editingNicknameChanged($0)) }
                    ))
                    .font(.Yunseul.subheadline)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .padding(16)
                    .background(Color.Yunseul.surface)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                    )
                }
                .padding(.horizontal, 24)
                
                Button {
                    store.send(.saveNickname)
                } label: {
                    Text(String(localized: "settings.nickname.sheet.save"))
                        .font(.Yunseul.callout)
                        .foregroundColor(Color.Yunseul.starBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    // MARK: - 생일 시트
    struct BirthDateSheetView: View {
        let store: Store<SettingsFeature.State, SettingsFeature.Action>
        @Binding var showWarning: Bool
        
        var body: some View {
            ZStack {
                Color.Yunseul.background.ignoresSafeArea()
                NebulaView()
                
                VStack(spacing: 24) {
                    Text(String(localized: "settings.birthdate.sheet.title"))
                        .font(.Yunseul.subheadline)
                        .foregroundColor(Color.Yunseul.textPrimary)
                        .tracking(2)
                        .padding(.top, 32)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color.Yunseul.starBlue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "settings.birthdate.warning.info.title"))
                                .font(.Yunseul.footnote)
                                .foregroundColor(Color.Yunseul.textPrimary)
                            Text(String(localized: "settings.birthdate.warning.info.body"))
                                .font(.Yunseul.captionLight)
                                .foregroundColor(Color.Yunseul.textTertiary)
                                .lineSpacing(3)
                        }
                    }
                    .padding(14)
                    .background(Color.Yunseul.starBlue.opacity(0.06))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.Yunseul.starBlue.opacity(0.2), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 24)
                    
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { store.state.editingBirthDate },
                            set: { store.send(.editingBirthDateChanged($0)) }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.locale, Locale.current)
                    .environment(\.colorScheme, .light)
                    
                    Button {
                        showWarning = true
                    } label: {
                        Text(String(localized: "settings.birthdate.sheet.save"))
                            .font(.Yunseul.callout)
                            .foregroundColor(Color.Yunseul.starBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .confirmationDialog(
                    String(localized: "settings.birthdate.warning.title"),
                    isPresented: $showWarning,
                    titleVisibility: .visible
                ) {
                    Button(String(localized: "settings.birthdate.warning.confirm")) {
                        store.send(.saveBirthDate)
                    }
                    Button(String(localized: "settings.birthdate.warning.cancel"), role: .cancel) {}
                } message: {
                    Text(String(localized: "settings.birthdate.warning.message"))
                }
            }
        }
    }
    
    // MARK: - 공통 컴포넌트
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.Yunseul.caption)
            .foregroundColor(Color.Yunseul.textTertiary)
            .tracking(2)
            .padding(.horizontal, 4)
    }
    
    private func settingRow(
        icon: String,
        title: String,
        value: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.Yunseul.elevated)
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(Color.Yunseul.starBlue)
                }
                
                Text(title)
                    .font(.Yunseul.footnote)
                    .foregroundColor(Color.Yunseul.textTertiary)
                
                Spacer()
                
                Text(value)
                    .font(.Yunseul.footnote)
                    .foregroundColor(Color.Yunseul.textPrimary)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(Color.Yunseul.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.Yunseul.border.opacity(0.2))
            .frame(height: 0.5)
            .padding(.horizontal, 16)
    }
    
    // MARK: - 헬퍼
    private func birthDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
    })
}
