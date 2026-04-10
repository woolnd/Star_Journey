# 🌠 별의 여행 (Star's Journey)

> *"모두 잠든 무지개 위를 가를 때, 고요한 바다에 비칠테니까"*
> — 윤하, 로켓 방정식

**당신의 별은 지금, 어디를 여행하고 있을까요?**

밤하늘을 올려다보지 않아도, 내가 태어난 날의 수호성이 지금 이 순간 지구 반대편 어딘가를 조용히 비추고 있습니다. 별의 여행은 그 여정을 실시간으로 추적하는 커스텀 천체 일기장입니다.
<img width="2040" height="1290" alt="컨셉" src="https://github.com/user-attachments/assets/73e9468f-bc45-4585-a85d-bf1e28353f99" />

---

## 📱 스크린샷

> _Coming Soon_

---

## ✨ 주요 기능

### 🗺️ 라이브 여정 맵 (Live Trajectory)
생일 기반 수호성의 **성하점(Sub-stellar Point)** 을 `MapKit`으로 세계 지도 위에 실시간 시각화합니다. 앱을 열지 않아도 위젯이 감성 브리핑을 전달합니다.

> *"지금 당신의 별은 아이슬란드의 북대서양을 여행하고 있습니다."*

### 🛂 우주 여권 (Journey Passport)
내 별이 특별한 장소를 지나가는 순간, 그 우주 좌표와 시간을 캡처하여 `Core Data` 기반의 여권에 스탬프처럼 기록합니다. 짧은 일기를 곁들여 나만의 천체 관측 기록장을 만들어 보세요.

### 🔔 도착 알림 (Star Notification)
관심 지역을 등록하면, 별이 그 위를 지나는 순간 푸시 알림을 받을 수 있습니다.

> *"재웅 님의 별이 방금 하와이 밤바다 위를 지나기 시작했어요."*

---

## 🛠️ 기술 스택

| 레이어 | 프레임워크 | 역할 |
|---|---|---|
| **UI** | SwiftUI / UIKit | 메인 여정 맵, 애니메이션, 서브 모듈 |
| **Architecture** | TCA + ReactorKit | 메인 비즈니스 로직 / 아카이브 독립 모듈 |
| **Data Stream** | RxSwift | 백그라운드 타이머 및 위치 센서 스트림 처리 |
| **Persistence** | Core Data | 관측 기록, 생일 데이터, 오프라인 캐시 |
| **Physics Engine** | SwiftAA | Jean Meeus 알고리즘 기반 정밀 천체 좌표 연산 |
| **Map** | MapKit | 성하점 세계 지도 시각화 |

---

## 🔄 데이터 흐름

```
생일 입력 & 현재 위치
        │
        ▼
[RxSwift] 백그라운드 타이머 + 위치 센서 → Observable 스트림
        │
        ▼
[TCA Reducer] Action 수신 → SwiftAA에 데이터 전달
        │
        ▼
[SwiftAA] 성하점 좌표 계산 (고도 / 방위각 / 적경 / 적위)
        │
        ├──→ [SwiftUI] State 업데이트 → MapKit 실시간 렌더링
        │
        └──→ [Core Data] '기록하기' 시 현재 데이터 영구 저장
                  │
                  ▼
        [ReactorKit + UIKit] 아카이브 리스트 화면에서 기록 조회
```

---

## 🗂️ Core Data 설계

| Entity | 주요 Attribute |
|---|---|
| `ObservationRecord` | `date`, `latitude`, `longitude`, `mood`, `altitude`, `azimuth` |
| `CapturedMoment` | `imageData`, `starName`, `recordedAt`, `physicsMetadata` |
| `BirthStar` | `constellation`, `birthDate`, `cachedEphemeris` |

---

## 🌍 글로벌 현지화 전략

| 국가 | 컨셉 | 톤앤매너 |
|---|---|---|
| 🇰🇷 한국 | 감성과 위로, 시적인 텍스트 | 미니멀, 다크 블루 |
| 🇯🇵 일본 | 수호성 기반 오늘의 운세 / 럭키 컬러 | 아기자기한 아이콘, 파스텔 톤 |
| 🇺🇸 미국 | 정밀 천문 데이터 시각화 | 테크니컬한 Sci-Fi 인터페이스 |

---

## 🏗️ 아키텍처 설계 원칙

멀티 스택 환경에서 스파게티 코드를 방지하고 명확한 경계를 설정합니다.

- **RxSwift** — 센서 스트림 전처리 레이어로 역할을 한정. TCA Effect 진입 전 Observable → AsyncStream 변환.
- **TCA** — 앱 전체 상태의 단일 진실 공급원(Single Source of Truth). `Scope` / `pullback` 으로 Child Feature 분리.
- **ReactorKit + UIKit** — 아카이브 모듈을 독립 구성하여 UDF 아키텍처 간 상호운용성(Interoperability) 구현.
- **Core Data** — 오프라인 환경에서도 이전 관측 데이터와 별자리 도감을 캐시로 제공.

---

## 💡 기획 배경

> 서버 없이 `SwiftAA` 엔진만으로 구현하는 **오프라인 천체 계산**.
> 고가의 천문 API에 의존하지 않아 유지보수 비용이 0원에 수렴하는 상용화 최적화 구조.

---

## 📄 라이선스

MIT License © 2026
