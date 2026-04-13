//
//  PassportView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import ComposableArchitecture
internal import CoreData

struct TracesView: View {
    
    @Bindable var store: Store<TracesFeature.State, TracesFeature.Action>
    let homeStore: Store<HomeFeature.State, HomeFeature.Action>
    
    var body: some View {
        ZStack {
            Color.Yunseul.background.ignoresSafeArea()
            NebulaView()
            
            VStack(spacing: 0) {
                headerSection
                
                tabSelector
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                if store.selectedTab == 0 {
                    globeSection
                } else {
                    journalCalendarSection
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(
            isPresented: Binding(
                get: { store.selectedJournalEntry != nil },
                set: { if !$0 { store.send(.journalDetailDismissed) } }
            )
        ) {
            if let entry = store.selectedJournalEntry {
                StarJournalDetailView(entry: entry)
            } else {
                Color.clear
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { store.isCompassMode },
            set: { if !$0 { store.send(.compassModeClosed) } }
        )) {
            let homeViewStore = ViewStore(homeStore, observe: { $0 })
            StarCompassView(
                viewStore: homeViewStore,
                onClose: {
                    store.send(.compassModeClosed)
                }
            )
        }
    }
    
    // MARK: - 헤더
    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("별자취")
                .font(.Yunseul.appTitle)
                .foregroundColor(Color.Yunseul.textPrimary)
                .tracking(6)
            
            Text("별이 지나온 길")
                .font(.Yunseul.captionLight)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(2)
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    // MARK: - 탭 선택
    private var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton(title: "별의 궤적", index: 0)
            tabButton(title: "별빛 일기", index: 1)
        }
        .background(Color.Yunseul.elevated)
        .cornerRadius(12)
    }
    
    private func tabButton(title: String, index: Int) -> some View {
        Button {
            store.send(.tabSelected(index))
        } label: {
            Text(title)
                .font(.Yunseul.footnote)
                .foregroundColor(
                    store.selectedTab == index
                    ? Color.Yunseul.starBlue
                    : Color.Yunseul.textTertiary
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(store.selectedTab == index
                              ? Color.Yunseul.surface
                              : Color.clear)
                        .padding(3)
                )
        }
    }
    
    // MARK: - 지구본 섹션
    private var globeSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                StarTrailGlobeView(trailEntries: store.trailEntries)
                    .frame(height: 360)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color.Yunseul.starBlue)
                        Text("매일 밤 9시 기준으로 기록돼요")
                            .font(.Yunseul.captionLight)
                            .foregroundColor(Color.Yunseul.textSecondary)
                    }
                    if !isPast9PM() {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 11))
                                .foregroundColor(Color.Yunseul.textTertiary)
                            Text("오늘 기록은 밤 9시에 추가돼요")
                                .font(.Yunseul.captionLight)
                                .foregroundColor(Color.Yunseul.textTertiary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("✦ \(store.trailEntries.count)일의 궤적")
                        .font(.Yunseul.caption)
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .tracking(2)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                trailTimeline(entries: store.trailEntries)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 48)
            }
        }
    }
    
    // MARK: - 별빛 일기 캘린더 섹션
    private var journalCalendarSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                calendarView
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                if let date = store.selectedDate {
                    if let entry = journalEntry(for: date, entries: store.journalEntries) {
                        journalSummaryCard(entry: entry)
                            .padding(.horizontal, 20)
                            .id(entry.objectID)
                    } else if Calendar.current.isDateInToday(date) {
                        noJournalTodayCard
                            .padding(.horizontal, 20)
                    }
                }
                
                Spacer().frame(height: 100)
            }
        }
    }
    
    // MARK: - 오늘 일기 없음 카드
    private var noJournalTodayCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 28))
                .foregroundColor(Color.Yunseul.textTertiary.opacity(0.5))
            
            Text("오늘의 별빛을 아직 담지 않았어요")
                .font(.Yunseul.briefingSmall)
                .foregroundColor(Color.Yunseul.textTertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Button {
                store.send(.compassModeTapped)
            } label: {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14))
                    Text("별과 함께 하늘 찍기")
                        .font(.Yunseul.callout)
                        .tracking(2)
                }
                .foregroundColor(Color.Yunseul.starBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                )
            }
        }
        .padding(20)
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3) as Color, lineWidth: 0.5)
        )
    }
    
    // MARK: - 캘린더 뷰
    private var calendarView: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    store.send(.previousMonthTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.Yunseul.textSecondary)
                        .padding(8)
                }
                
                Spacer()
                
                Text(monthYearString(from: store.currentMonth))
                    .font(.Yunseul.subheadline)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .tracking(2)
                
                Spacer()
                
                Button {
                    store.send(.nextMonthTapped)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(
                            isCurrentMonth(store.currentMonth)
                            ? Color.Yunseul.textTertiary.opacity(0.3)
                            : Color.Yunseul.textSecondary
                        )
                        .padding(8)
                }
                .disabled(isCurrentMonth(store.currentMonth))
            }
            
            HStack(spacing: 0) {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .font(.Yunseul.captionLight)
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let days = generateDays(for: store.currentMonth)
            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days.indices, id: \.self) { index in
                    let day = days[index]
                    
                    if let date = day {
                        let hasJournal = hasJournalEntry(for: date, entries: store.journalEntries)
                        let isPast = isPastOrToday(date)
                        let isSelected = store.selectedDate.map {
                            Calendar.current.isDate($0, inSameDayAs: date)
                        } ?? false
                        
                        Button {
                            store.send(.dateTapped(date))
                        } label: {
                            VStack(spacing: 4) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.Yunseul.footnote)
                                    .foregroundColor(
                                        isPast
                                        ? (isToday(date)
                                           ? Color.Yunseul.starBlue
                                           : Color.Yunseul.starBlue.opacity(0.7))
                                        : Color(Color.Yunseul.textTertiary).opacity(0.4)
                                    )
                                    .fontWeight(isToday(date) ? .bold : .regular)
                                
                                if hasJournal {
                                    Text("✦")
                                        .font(.system(size: 9))
                                        .foregroundColor(Color.Yunseul.starBlue)
                                } else {
                                    Text(" ")
                                        .font(.system(size: 9))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        isSelected
                                        ? Color.Yunseul.starBlue.opacity(0.15)
                                        : isToday(date)
                                        ? Color.Yunseul.starBlue.opacity(0.08)
                                        : Color.clear
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        isSelected
                                        ? Color.Yunseul.starBlue.opacity(0.4)
                                        : hasJournal
                                        ? Color.Yunseul.starBlue.opacity(0.2)
                                        : Color.clear,
                                        lineWidth: 0.5
                                    )
                            )
                        }
                        .disabled(!hasJournal && !isPast)
                    } else {
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                }
            }
            
            HStack(spacing: 6) {
                Text("✦")
                    .font(.system(size: 9))
                    .foregroundColor(Color.Yunseul.starBlue)
                Text("일기를 기록한 날이에요")
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3) as Color, lineWidth: 0.5)
        )
    }
    
    // MARK: - 일기 요약 카드
    private func journalSummaryCard(entry: StarJournalEntry) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(dateFullString(from: entry.date ?? Date()))
                    .font(.Yunseul.caption)
                    .foregroundColor(Color.Yunseul.textTertiary)
                    .tracking(2)
                Spacer()
            }
            
            VStack(spacing: 8) {
                summaryRow(icon: "sparkles", title: "별이 비추던 곳", value: entry.starRegionName ?? "")
                summaryRow(icon: "location.fill", title: "내가 있던 곳", value: entry.userRegionName ?? "")
                summaryRow(
                    icon: "location.north.fill",
                    title: "별의 방향",
                    value: "\(entry.starDirection ?? "") / 고도 \(String(format: "%.1f", entry.starAltitude))°"
                )
                summaryRow(
                    icon: "arrow.left.and.right",
                    title: "별까지의 거리",
                    value: String(format: "%.0f km", entry.distanceKm)
                )
            }
            
            if let memo = entry.memo, !memo.isEmpty {
                Text("\"\(memo)\"")
                    .font(.Yunseul.story)
                    .foregroundColor(Color.Yunseul.textSecondary)
                    .lineSpacing(4)
                    .padding(.top, 4)
            }
            
            Button {
                store.send(.journalEntryTapped(entry))
            } label: {
                HStack {
                    Text("전체 보기")
                        .font(.Yunseul.callout)
                        .foregroundColor(Color.Yunseul.starBlue)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11))
                        .foregroundColor(Color.Yunseul.starBlue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                )
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3) as Color, lineWidth: 0.5)
        )
    }
    
    private func summaryRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color.Yunseul.starBlue)
                .frame(width: 20)
            
            Text(title)
                .font(.Yunseul.captionLight)
                .foregroundColor(Color.Yunseul.textTertiary)
                .frame(width: 90, alignment: .leading)
            
            Text(value)
                .font(.Yunseul.footnote)
                .foregroundColor(Color.Yunseul.textPrimary)
            
            Spacer()
        }
    }
    
    // MARK: - 월별 타임라인
    private func trailTimeline(entries: [StarTrailEntry]) -> some View {
        let grouped = groupByMonth(entries: entries)
        
        return VStack(alignment: .leading, spacing: 24) {
            ForEach(grouped.keys.sorted(by: >), id: \.self) { month in
                VStack(alignment: .leading, spacing: 12) {
                    Text(month)
                        .font(.Yunseul.caption)
                        .foregroundColor(Color.Yunseul.starBlue)
                        .tracking(2)
                    
                    VStack(spacing: 0) {
                        ForEach(grouped[month] ?? [], id: \.objectID) { entry in
                            timelineRow(entry: entry)
                        }
                    }
                    .background(Color.Yunseul.surface)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.Yunseul.border.opacity(0.3) as Color, lineWidth: 0.5)
                    )
                }
            }
        }
    }
    
    private func timelineRow(entry: StarTrailEntry) -> some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(dayString(from: entry.date ?? Date()))
                    .font(.Yunseul.title3)
                    .foregroundColor(Color.Yunseul.starBlue)
                Text(weekdayString(from: entry.date ?? Date()))
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
            }
            .frame(width: 36)
            
            Circle()
                .fill(Color.Yunseul.starBlue.opacity(0.6))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.regionName ?? "")
                    .font(.Yunseul.footnote)
                    .foregroundColor(Color.Yunseul.textPrimary)
                
                Text(String(format: "%.1f°%@  %.1f°%@",
                            abs(entry.latitude),
                            entry.latitude >= 0 ? "N" : "S",
                            abs(entry.longitude),
                            entry.longitude >= 0 ? "E" : "W"))
                .font(.Yunseul.captionLight)
                .foregroundColor(Color.Yunseul.textTertiary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(
            Rectangle()
                .fill(Color.Yunseul.border.opacity(0.2))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
    
    // MARK: - 날짜 생성
    private func generateDays(for month: Date) -> [Date?] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: month)
        )!
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 { days.append(nil) }
        
        return days
    }
    
    // MARK: - 헬퍼
    private func hasJournalEntry(for date: Date, entries: [StarJournalEntry]) -> Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day) == false
        ? entries.contains { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
        : entries.contains { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
    }
    
    private func journalEntry(for date: Date, entries: [StarJournalEntry]) -> StarJournalEntry? {
        entries.first { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
    }
    
    private func isPast9PM() -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.component(.hour, from: Date()) >= 21
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    private func isPastOrToday(_ date: Date) -> Bool {
        Calendar.current.startOfDay(for: date) <= Calendar.current.startOfDay(for: Date())
    }
    
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    // MARK: - 월별 그룹화
    private func groupByMonth(entries: [StarTrailEntry]) -> [String: [StarTrailEntry]] {
        var grouped: [String: [StarTrailEntry]] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        
        for entry in entries {
            let key = formatter.string(from: entry.date ?? Date())
            if grouped[key] == nil { grouped[key] = [] }
            grouped[key]?.append(entry)
        }
        
        for key in grouped.keys {
            grouped[key]?.sort { ($0.date ?? Date()) > ($1.date ?? Date()) }
        }
        
        return grouped
    }
    
    // MARK: - 날짜 포맷
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func dateFullString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    private func weekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

#Preview {
    TracesView(
        store: Store(initialState: TracesFeature.State()) {
            TracesFeature()
        },
        homeStore: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}
