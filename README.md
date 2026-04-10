# 🌠 윤슬 (Yunseul)

> *별은 언제나 우리를 본다. 우리가 볼 수 없을 뿐.*

당신의 생일별(Birth Star)이 지금 이 순간 지구 어디를 비추고 있을까요?  
**윤슬**은 그 여정을 실시간으로 추적하고, 감정을 담아 기록하는 천체 여행 다이어리입니다.
<img width="2040" height="1260" alt="컨셉" src="https://github.com/user-attachments/assets/414ec4e8-b9d5-46e5-9200-3ea1c8181801" />
---

## 📱 Core Features

### 🗺️ Live Star Tracker
- **MapKit** 기반 실시간 성하점(Sub-stellar Point) 시각화
- 생일 기반 수호성의 고도·방위각 계산
- Widget으로 오늘의 별 위치 한눈에 확인
- 오프라인 지원: 인터넷 없이도 천체 계산 가능

### 🛂 Journey Passport
- 별이 지나간 특별한 장소들을 **Core Data** 기반으로 기록
- 순간의 좌표, 시간, 무드를 스탬프처럼 수집
- 나만의 천체 관측 아카이브 구성
- 사진 + 짧은 일기로 추억 보관

### 🔔 Smart Notifications
- 관심 지역(POI) 등록 시 별이 통과하는 순간 알림
- 백그라운드 타이머와 위치 센서로 정확한 감지
- 시간대 자동 변환(UTC ↔ Local Time)

---

## 🛠️ Tech Stack

| Layer | Framework | Why? |
|-------|-----------|------|
| **UI Framework** | SwiftUI + UIKit | 메인은 SwiftUI, 아카이브 모듈은 UIKit (ReactorKit 지원) |
| **State Management** | TCA (The Composable Architecture) | Single Source of Truth 패턴 |
| **Reactive** | RxSwift | 센서 스트림 & 백그라운드 타이머 전처리 |
| **Data Persistence** | Core Data | 오프라인 캐싱 + 관측 기록 저장 |
| **Physics Engine** | SwiftAA | Jean Meeus 알고리즘 기반 정밀 천체 좌표 계산 |
| **Mapping** | MapKit | 성하점 세계 지도 렌더링 |
| **Architecture (Sub)** | ReactorKit | 아카이브 모듈 독립 구성 |

---

## 🔄 Data Flow Architecture

```
┌─────────────────────────────────┐
│  User Input (Birthday + Location) │
└────────────┬────────────────────┘
             │
             ▼
    ┌────────────────────┐
    │ RxSwift Stream     │
    │ Timer + Location   │
    │ Sensor Processing  │
    └────────┬───────────┘
             │
             ▼
    ┌────────────────────┐
    │ TCA Reducer        │
    │ Action Handler     │
    └────────┬───────────┘
             │
             ▼
    ┌────────────────────┐
    │ SwiftAA Engine     │
    │ (Jean Meeus Algo)  │
    │ ↓ ↓ ↓             │
    │ RA, Dec, Alt, Az   │
    └────────┬───────────┘
             │
     ┌───────┴──────────┐
     │                  │
     ▼                  ▼
┌──────────────┐  ┌──────────────┐
│ SwiftUI View │  │ Core Data    │
│ MapKit       │  │ Persistence  │
│ Render       │  │ (Manual Save)│
└──────────────┘  └──────────────┘
```

---

## 💾 Core Data Schema

```swift
// 생일별 정보
@Model
final class BirthStar {
    var birthDate: Date
    var constellation: String?
    var cachedEphemeris: [String: Double]?  // 계산 결과 캐시
    var observations: [ObservationRecord] = []
}

// 관측 기록 (스탬프)
@Model
final class ObservationRecord {
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var azimuth: Double
    var mood: String?
    var diary: String?
    var imageData: Data?
    
    // 역참조
    var birthStar: BirthStar?
}

// 특별한 순간 (사진 + 메타데이터)
@Model
final class CapturedMoment {
    var recordedAt: Date
    var imageData: Data
    var location: String?
    var physicsMetadata: String?  // JSON: {ra, dec, mag, etc}
}
```

---

## 🏗️ Architecture Patterns

### TCA (Main Flow)
```
┌─────────────────────────────────────┐
│ AppReducer                          │
│ ├─ MapFeature                       │
│ │  ├─ Action: updateStarPosition    │
│ │  └─ State: currentCoordinate      │
│ ├─ PassportFeature                  │
│ │  ├─ Action: addObservation        │
│ │  └─ State: observations[]         │
│ └─ SettingsFeature                  │
│    ├─ Action: updateBirthDate       │
│    └─ State: userPreferences        │
└─────────────────────────────────────┘
```

### RxSwift (Sensor Layer)
```swift
let locationStream = locationManager.asObservable()
    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    .map { location in CLLocationCoordinate2D(...) }

let timerStream = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
    .flatMap { _ in calculateStarPosition() }
```

### ReactorKit (Archive Module)
```
┌────────────────────────────────┐
│ ArchiveViewController          │
│ (UIKit + ReactorKit)           │
├─ Reactor: ArchiveReactor       │
│  ├─ State: records[], filter   │
│  ├─ Action: loadRecords, sort  │
│  └─ Mutation: updateRecords    │
└────────────────────────────────┘
```

---

## 🌍 Localization Strategy

| Market | Concept | Tone |
|--------|---------|------|
| 🇰🇷 **Korea** | "위로와 감성" — 별이 건네는 작은 위로 | 미니멀, 다크 블루, 시적 텍스트 |
| 🇯🇵 **Japan** | "오늘의 별운세" — 별의 위치로 럭키 컬러 제시 | 귀여운 아이콘, 파스텔, 점성술 톤 |
| 🇺🇸 **USA** | "Precision Star Tracking" — 천문학 데이터 강조 | Sci-Fi UI, 테크니컬 메트릭 |

---

## 🔐 Privacy & Performance

- **Location**: 항상 사용(Always) 권한으로 백그라운드 추적 (필요시)
- **Data**: 모든 관측 기록은 디바이스 로컬 저장 (클라우드 미동기)
- **Offline**: SwiftAA 엔진으로 인터넷 없이도 정밀 계산 가능
- **Battery**: 5초 인터벌 위치 업데이트, Widget은 15분 리프레시

---

## 💡 Why This Architecture?

| 문제 | 해결 방법 |
|------|---------|
| 센서 데이터 노이즈 | RxSwift throttle + debounce |
| 상태 복잡도 증가 | TCA의 Scope로 Feature 분리 |
| 두 가지 아키텍처(TCA + RK) 혼용 | 명확한 모듈 경계: Map/Settings는 TCA, Archive는 RK |
| 고비용 천문 API | SwiftAA 오프라인 계산 (유지비 0원) |
| 백그라운드 업데이트 | RxSwift Observable + BGTask 조합 |

---

## 🚀 Getting Started

### Requirements
- iOS 16.0+
- Swift 5.9+
- CocoaPods / SPM

### Installation
```bash
pod install
# or
swift package manager
```

### Quick Setup
```swift
// BirthStarManager.swift
let manager = BirthStarManager()
manager.setBirthDate(Date(...))
manager.startTracking()  // RxSwift 스트림 시작

// MapView에서 관찰
manager.starPositionStream
    .sink { coordinate in
        self.mapView.setCenter(coordinate)
    }
    .store(in: &cancellables)
```

---

## 📦 Project Structure

```
Yunseul/
├── App/
│   ├── YunseulApp.swift
│   └── AppDelegate.swift
├── Features/
│   ├── Map/
│   │   ├── MapReducer.swift
│   │   ├── MapView.swift
│   │   └── MapViewModel.swift
│   ├── Passport/
│   │   ├── PassportReducer.swift
│   │   └── PassportListView.swift
│   ├── Archive/
│   │   ├── ArchiveViewController.swift
│   │   ├── ArchiveReactor.swift
│   │   └── ArchiveCell.swift
│   └── Settings/
│       ├── SettingsReducer.swift
│       └── SettingsView.swift
├── Services/
│   ├── BirthStarManager.swift
│   ├── LocationService.swift
│   └── NotificationService.swift
├── Models/
│   ├── BirthStar.swift
│   ├── ObservationRecord.swift
│   └── CapturedMoment.swift
├── Utilities/
│   ├── SwiftAAWrapper.swift
│   └── CoordinateConverter.swift
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

---

## 🎨 UI Preview

- **Map Screen**: 세계 지도 위 반짝이는 별 (실시간 애니메이션)
- **Passport List**: 기록한 순간들을 카드 형식으로 시간순 정렬
- **Notification**: 별이 특별한 장소를 지날 때 따뜻한 메시지
- **Settings**: 생일 설정, 알림 지역 등록, 다크모드 토글

---

## 🤝 Contributing

Pull Request는 언제나 환영합니다.  
이슈 제기 시 다음을 포함해주세요:
- 버그 재현 방법
- 예상 vs 실제 동작
- 디바이스 & iOS 버전

---

## 📄 License

MIT License © 2026 Yunseul Project

---

## 🌟 마지막으로

> 별은 언제나 우리 곁에 있다.  
> 우리가 올려다보지 않아도,  
> 누군가의 탄생일을 조용히 비추고 있다.

**당신의 별, 지금 어디를 향해 가고 있나요?**
