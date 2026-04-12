//
//  HomeView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI
import MapKit
import ComposableArchitecture
import RxSwift

final class HomeViewDisposeBag {
    let bag = DisposeBag()
}

final class DisposeBagHolder {
    let bag = DisposeBag()
}

struct HomeView: View {
    
    let store: Store<HomeFeature.State, HomeFeature.Action>
    @State private var holder = DisposeBagHolder()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                // 배경
                Color.Yunseul.background
                    .ignoresSafeArea()
                
                NebulaView()
                
                if viewStore.isLoading {
                    loadingView
                } else {
                    mainContent(viewStore: viewStore)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
                bindRxStreams(viewStore: viewStore)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .fullScreenCover(
                isPresented: Binding(
                    get: { viewStore.isCompassMode },
                    set: { if !$0 { viewStore.send(.compassModeClose) } }
                )
            ) {
                StarCompassView(viewStore: viewStore)
            }
        }
    }
    
    // MARK: - 로딩 뷰
    private var loadingView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 32))
                .foregroundColor(Color.Yunseul.starBlue)
            
            Text("별을 찾고 있어요...")
                .font(.Yunseul.footnoteItalic)
                .foregroundColor(Color.Yunseul.textSecondary)
        }
    }
    
    // MARK: - 메인 콘텐츠
    private func mainContent(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // 상단 브리핑
                briefingSection(viewStore: viewStore)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                // 지도 카드
                mapCard(viewStore: viewStore)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                // 천문 데이터 카드
                astronomyDataCard(viewStore: viewStore)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                
                // 버튼 영역
                buttonSection(viewStore: viewStore)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                
                starStorySection(viewStore: viewStore)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                
                StarRelationView(constellation: viewStore.constellation)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 48)
            }
        }
    }
    
    // MARK: - 브리핑 섹션
    private func briefingSection(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 여정")
                .font(.Yunseul.caption)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(2)
            
            Text(viewStore.briefingText)
                .font(.Yunseul.briefing)
                .foregroundColor(Color.Yunseul.textPrimary)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 지도 카드
    private func mapCard(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        VStack(spacing: 0) {
            // 지도 헤더
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("LIVE TRAJECTORY")
                        .font(.Yunseul.caption)
                        .foregroundColor(Color.Yunseul.textTertiary)
                        .tracking(2)
                    
                    Text("성하점 실시간 위치")
                        .font(.Yunseul.footnote)
                        .foregroundColor(Color.Yunseul.textSecondary)
                }
                
                Spacer()
                
                // 라이브 뱃지
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.Yunseul.liveGreen)
                        .frame(width: 6, height: 6)
                    
                    Text("LIVE")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundColor(Color.Yunseul.liveGreen)
                        .tracking(1.5)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.Yunseul.liveGreen.opacity(0.3), lineWidth: 0.5)
                )
            }
            .padding(14)
            
            // MapKit 지도
            StarMapView(
                starLatitude: viewStore.subStellarLatitude,
                starLongitude: viewStore.subStellarLongitude,
                userLatitude: viewStore.userLatitude,
                userLongitude: viewStore.userLongitude
            )
            .frame(height: 200)
            
            // 좌표 표시
            HStack {
                Text(String(format: "%.2f°%@ %.2f°%@",
                            abs(viewStore.subStellarLatitude),
                            viewStore.subStellarLatitude >= 0 ? "N" : "S",
                            abs(viewStore.subStellarLongitude),
                            viewStore.subStellarLongitude >= 0 ? "E" : "W"
                           ))
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(Color.Yunseul.textTertiary)
                
                Spacer()
            }
            .padding(14)
        }
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    // MARK: - 천문 데이터 카드
    private func astronomyDataCard(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        HStack(spacing: 8) {
            // 고도
            dataCell(
                label: "고도",
                value: String(format: "%.1f°", viewStore.starAltitude),
                subLabel: "altitude"
            )
            
            // 방위각
            dataCell(
                label: "방위각",
                value: String(format: "%.1f°", viewStore.starAzimuth),
                subLabel: "azimuth"
            )
            
            // 별자리
            dataCell(
                label: "수호성",
                value: viewStore.constellation.rawValue,
                subLabel: viewStore.constellation.latinName
            )
        }
    }
    
    private func dataCell(
        label: String,
        value: String,
        subLabel: String
    ) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.Yunseul.caption)
                .foregroundColor(Color.Yunseul.textTertiary)
                .tracking(1)
            
            Text(value)
                .font(.system(size: 16, design: .monospaced))
                .foregroundColor(Color.Yunseul.textPrimary)
            
            Text(subLabel)
                .font(.Yunseul.caption)
                .foregroundColor(Color.Yunseul.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.Yunseul.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    // MARK: - 버튼 섹션
    private func buttonSection(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        VStack(spacing: 10) {
            // 별 찾기 버튼
            Button {
                viewStore.send(.compassModeOpen)
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
    }
    
    // MARK: - 별 이야기 섹션
    private func starStorySection(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 섹션 헤더
            HStack {
                Text("나의 별 이야기")
                    .font(.Yunseul.caption)
                    .foregroundColor(Color.Yunseul.textTertiary)
                    .tracking(2)
                
                Spacer()
                
                // 별자리 이미지
                Image(viewStore.constellation.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .opacity(0.7)
            }
            
            // 스토리 페이지들
            TabView {
                ForEach(Array(viewStore.constellation.storyPages.enumerated()), id: \.offset) { index, page in
                    storyPageCard(page: page, index: index, total: viewStore.constellation.storyPages.count)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 500)
        }
    }
    
    // MARK: - 스토리 페이지 카드
    private func storyPageCard(page: StoryPage, index: Int, total: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 장 제목
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.Yunseul.starBlue.opacity(0.6))
                    .frame(width: 2, height: 14)
                
                Text(page.title)
                    .font(.Yunseul.storyTitle)
                    .foregroundColor(Color.Yunseul.starBlue)
                    .tracking(2)
                
                Spacer()
                
                Text("\(index + 1) / \(total)")
                    .font(.Yunseul.captionLight)
                    .foregroundColor(Color.Yunseul.textTertiary)
            }
            
            // 본문
            Text(page.content)
                .font(.Yunseul.story)
                .foregroundColor(Color.Yunseul.textPrimary)
                .lineSpacing(8)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Yunseul.surface)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Yunseul.border.opacity(0.3), lineWidth: 0.5)
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
    
    // MARK: - RxSwift → TCA 브릿지
    private func bindRxStreams(viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>) {
        LocationService.shared.coordinate
            .subscribe(onNext: { coord in
                viewStore.send(.locationUpdated(latitude: coord.latitude, longitude: coord.longitude))
            })
            .disposed(by: holder.bag)
        
        Observable.combineLatest(
            MotionService.shared.azimuth,
            MotionService.shared.altitude
        )
        .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
        .subscribe(onNext: { azimuth, altitude in
            viewStore.send(.sensorUpdated(azimuth: azimuth, altitude: altitude))
        })
        .disposed(by: holder.bag)
    }
}

// MARK: - MapKit 지도 뷰
struct StarMapView: UIViewRepresentable {
    
    let starLatitude: Double
    let starLongitude: Double
    let userLatitude: Double
    let userLongitude: Double
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }
    
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard starLatitude != 0 else { return }
        
        mapView.removeAnnotations(mapView.annotations)
        
        let starAnnotation = MKPointAnnotation()
        starAnnotation.coordinate = CLLocationCoordinate2D(
            latitude: starLatitude,
            longitude: starLongitude
        )
        starAnnotation.title = "✦ 당신의 별"
        mapView.addAnnotation(starAnnotation)
        
        let currentCenter = mapView.region.center
        let dist = abs(currentCenter.latitude - starLatitude) + abs(currentCenter.longitude - starLongitude)
        
        if dist > 1.0 {  // 1도 이상 차이날 때만 업데이트
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: starLatitude, longitude: starLongitude),
                latitudinalMeters: 3_000_000,
                longitudinalMeters: 3_000_000
            )
            mapView.setRegion(region, animated: false)
        }
    }
}

#Preview {
    HomeView(store: Store(
        initialState: HomeFeature.State()
    ) {
        HomeFeature()
    })
}
