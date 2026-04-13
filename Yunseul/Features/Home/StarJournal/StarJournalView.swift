//
//  StarJournalView.swift
//  Yunseul
//
//  Created by wodnd on 4/13/26.
//

import Foundation
import SwiftUI
internal import CoreData

struct StarJournalView: View {
    
    @State private var entries: [StarJournalEntry] = []
    @State private var selectedEntry: StarJournalEntry? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("별빛 일기")
                    .font(.Yunseul.caption)
                    .foregroundColor(Color.Yunseul.textTertiary)
                    .tracking(2)
                
                Spacer()
                
                Text("\(entries.count)개의 기록")
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
            }
            
            if entries.isEmpty {
                emptyView
            } else {
                journalList
            }
        }
        .onAppear {
            loadEntries()
        }
        .sheet(item: $selectedEntry, onDismiss: {
            loadEntries()
        }) { entry in
            StarJournalDetailView(entry: entry)
        }
    }
    
    private func loadEntries() {
        entries = CoreDataService.shared.fetchAllJournalEntries()
    }
    
    // MARK: - 빈 상태
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "camera.fill")
                .font(.system(size: 28))
                .foregroundColor(Color.Yunseul.textTertiary.opacity(0.5))
            
            Text("별과 함께 하늘을 찍으면\n여기에 기록돼요")
                .font(.Yunseul.briefingSmall)
                .foregroundColor(Color.Yunseul.textTertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    // MARK: - 일기 목록
    private var journalList: some View {
        VStack(spacing: 10) {
            ForEach(entries, id: \.objectID) { entry in
                Button {
                    selectedEntry = entry
                } label: {
                    journalCard(entry: entry)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - 일기 카드
    private func journalCard(entry: StarJournalEntry) -> some View {
        HStack(spacing: 14) {
            
            // 날짜
            VStack(spacing: 4) {
                Text(dayString(from: entry.date ?? Date()))
                    .font(.Yunseul.title3)
                    .foregroundColor(Color.Yunseul.starBlue)
                
                Text(monthString(from: entry.date ?? Date()))
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
            }
            .frame(width: 40)
            
            Rectangle()
                .fill(Color.Yunseul.border.opacity(0.5))
                .frame(width: 0.5, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.constellation ?? "")
                    .font(.Yunseul.footnote)
                    .foregroundColor(Color.Yunseul.textPrimary)
                
                Text(entry.starRegionName ?? "")
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textSecondary)
                
                HStack(spacing: 8) {
                    Label(
                        entry.starDirection ?? "",
                        systemImage: "location.north.fill"
                    )
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
                    
                    Label(
                        String(format: "%.0f km", entry.distanceKm),
                        systemImage: "arrow.left.and.right"
                    )
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
                }
            }
            
            Spacer()
            
            // 사진 썸네일
            if let photoPath = entry.photoPath,
               !photoPath.isEmpty,
               let image = loadImageFromDocuments(fileName: photoPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 11))
                .foregroundColor(Color.Yunseul.textTertiary)
        }
        .padding(14)
        .background(Color.Yunseul.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    // MARK: - Documents에서 사진 불러오기
    private func loadImageFromDocuments(fileName: String) -> UIImage? {
        let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - 날짜 포맷
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    private func monthString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

// MARK: - 상세 뷰
struct StarJournalDetailView: View {
    
    let entry: StarJournalEntry
    @Environment(\.dismiss) private var dismiss
    @State private var memo: String = ""
    @State private var showDeleteConfirm: Bool = false
    
    var body: some View {
        ZStack {
            Color.Yunseul.background.ignoresSafeArea()
            NebulaView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    headerSection
                    
                    starSection
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                    
                    dataSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    
                    memoSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 48)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            }
        }
        .onAppear {
            memo = entry.memo ?? ""
        }
        .confirmationDialog(
            "이 일기를 삭제할까요?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("삭제", role: .destructive) {
                deleteEntry()
            }

            Button("취소") {
                showDeleteConfirm = false
            }
        } message: {
            Text("삭제한 일기는 복구할 수 없어요")
        }
    }
    
    // MARK: - 헤더
    private var headerSection: some View {
        ZStack {
            Text(dateString(from: entry.date ?? Date()))
                .font(.Yunseul.caption)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .padding(10)
                        .background(Circle().fill(Color.Yunseul.surface))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    // MARK: - 별자리 섹션
    private var starSection: some View {
        VStack(spacing: 16) {
            let constellationName = entry.constellation ?? "양자리"
            let c = Constellation(rawValue: constellationName) ?? .aries
            
            if let photoPath = entry.photoPath,
               !photoPath.isEmpty,
               let image = loadImageFromDocuments(fileName: photoPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 24)
            } else {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.Yunseul.starBlue.opacity(0.2), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 180, height: 180)
                    
                    Image(c.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .opacity(0.9)
                        .shadow(color: Color.Yunseul.starBlue.opacity(0.4), radius: 20, x: 0, y: 8)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                
                Text(constellationName)
                    .font(.Yunseul.constellationName)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .tracking(4)
                
                Text(c.latinName)
                    .font(.Yunseul.constellationSub)
                    .foregroundColor(Color.Yunseul.textSecondary)
                    .tracking(3)
            }
        }
    }
    
    // MARK: - 데이터 섹션
    private var dataSection: some View {
        VStack(spacing: 10) {
            dataCard(
                icon: "sparkles",
                title: "별이 비추던 곳",
                value: entry.starRegionName ?? ""
            )
            
            dataCard(
                icon: "location.fill",
                title: "내가 있던 곳",
                value: entry.userRegionName ?? ""
            )
            
            dataCard(
                icon: "location.north.fill",
                title: "별의 방향",
                value: "\(entry.starDirection ?? "") / 고도 \(String(format: "%.1f", entry.starAltitude))°"
            )
            
            dataCard(
                icon: "arrow.left.and.right",
                title: "별까지의 거리",
                value: String(format: "%.0f km", entry.distanceKm)
            )
        }
    }
    
    private func dataCard(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.Yunseul.elevated)
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color.Yunseul.starBlue)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
                
                Text(value)
                    .font(.Yunseul.subheadline)
                    .foregroundColor(Color.Yunseul.textPrimary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(Color.Yunseul.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    // MARK: - 메모 섹션
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("한 줄 감상")
                .font(.Yunseul.caption)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(2)
            
            ZStack(alignment: .topLeading) {
                if memo.isEmpty {
                    Text("오늘의 별빛은 어땠나요?")
                        .font(.Yunseul.story)
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .padding(16)
                }
                
                TextEditor(text: $memo)
                    .font(.Yunseul.story)
                    .foregroundColor(Color.Yunseul.textPrimary)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(12)
                    .frame(minHeight: 100)
            }
            .background(Color.Yunseul.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
            )
            
            // 저장 버튼
            Button {
                saveMemo()
                dismiss()
            } label: {
                Text("저장")
                    .font(.Yunseul.callout)
                    .foregroundColor(Color.Yunseul.starBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.Yunseul.starBlue.opacity(0.3), lineWidth: 0.5)
                    )
            }
            
            Button {
                showDeleteConfirm = true
            } label: {
                Text("일기 삭제")
                    .font(.Yunseul.callout)
                    .foregroundColor(.red.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.2), lineWidth: 0.5)
                    )
            }
        }
    }
    
    // MARK: - 메모 저장
    private func saveMemo() {
        entry.setValue(memo, forKey: "memo")
        try? CoreDataService.shared.context.save()
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    // MARK: - 일기 삭제
    private func deleteEntry() {
        if let photoPath = entry.photoPath, !photoPath.isEmpty {
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0].appendingPathComponent(photoPath)
            try? FileManager.default.removeItem(at: url)
        }
        
        CoreDataService.shared.context.delete(entry)
        try? CoreDataService.shared.context.save()
        dismiss()
    }
    
    // MARK: - Documents에서 사진 불러오기
    private func loadImageFromDocuments(fileName: String) -> UIImage? {
        if fileName.hasPrefix("/") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: fileName)) else { return nil }
            return UIImage(data: data)
        }
        
        // 파일명만 있는 경우
        let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(fileName)
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - 날짜 포맷
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

#Preview {
    StarJournalView()
}
