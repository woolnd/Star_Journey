//
//  StarCompassView.swift
//  Yunseul
//
//  Created by wodnd on 4/12/26.
//

import SwiftUI
import AVFoundation
import Photos
import Combine
import ComposableArchitecture

// MARK: - 카메라 매니저
final class CameraManager: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    var onPhotoCaptured: ((UIImage?) -> Void)?
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ),
        let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        session.addInput(input)
        session.addOutput(photoOutput)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    // 실제 사진 촬영
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        onPhotoCaptured = completion
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            onPhotoCaptured?(nil)
            return
        }
        onPhotoCaptured?(image)
    }
}

// MARK: - 카메라 뷰
struct CameraView: UIViewRepresentable {
    
    let manager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: manager.session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - StarCompassView
struct StarCompassView: View {
    
    let viewStore: ViewStore<HomeFeature.State, HomeFeature.Action>
    
    @StateObject private var cameraManager = CameraManager()
    @State private var pulseScale: CGFloat = 1.0
    @State private var starOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var isSaving: Bool = false
    @State private var showSaveSuccess: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ① 카메라 배경
                CameraView(manager: cameraManager)
                    .ignoresSafeArea()
                
                // ② 감성 오버레이 (카메라 위에 표시)
                overlayContent
                
                // ③ UI (저장 시 제외)
                VStack {
                    headerSection
                    Spacer()
                    bottomSection
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) { starOpacity = 1 }
            withAnimation(.easeIn(duration: 1.2).delay(0.5)) { textOpacity = 1 }
            startPulseAnimation()
        }
    }
    
    // MARK: - 감성 오버레이 (카메라 위 + 저장에도 포함)
    var overlayContent: some View {
        VStack(spacing: 0) {
            Spacer()
        
            ZStack {
                Image(viewStore.constellation.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.Yunseul.starBlue.opacity(0.8), radius: 20)
            }
            .opacity(starOpacity)

            Spacer().frame(height: 24)

            VStack(spacing: 6) {
                Text(viewStore.constellation.rawValue)
                    .font(.custom("Georgia", size: 30))
                    .foregroundColor(.white)
                    .tracking(6)
                    .shadow(color: Color.Yunseul.starBlue.opacity(0.6), radius: 8)
                
                Text(viewStore.constellation.latinName)
                    .font(.custom("Georgia-Italic", size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(4)
            }
            .opacity(textOpacity)

            Spacer().frame(height: 20)

            Text(viewStore.briefingText)
                .font(.custom("Georgia-Italic", size: 16))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 40)
                .opacity(textOpacity)
            
            Spacer().frame(height: 16)
            
            Text(currentDateString)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))
                .tracking(2)
                .opacity(textOpacity)
            
            // 하단 버튼 영역만큼 여백
            Spacer().frame(height: 180)
        }
    }
    
    // MARK: - 헤더
    private var headerSection: some View {
        ZStack {
            Text("별과 함께 하늘 찍기")
                .font(.Yunseul.callout)
                .foregroundColor(.white)
                .tracking(2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button {
                    viewStore.send(.compassModeClose)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(8)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .padding(.top, 60)
        .padding(.bottom, 16)
    }
    
    // MARK: - 하단 버튼 (캡처에서 제외)
    private var bottomSection: some View {
        VStack(spacing: 12) {
            if showSaveSuccess {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.Yunseul.liveGreen)
                    Text("앨범에 저장됐어요")
                        .font(.Yunseul.footnote)
                        .foregroundColor(.white)
                }
                .transition(.opacity)
            }
            
            HStack(spacing: 16) {
                Button {
                    captureAndSave()
                } label: {
                    HStack(spacing: 8) {
                        if isSaving {
                            ProgressView().tint(.white).scaleEffect(0.8)
                        } else {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                        }
                        Text(isSaving ? "저장 중..." : "앨범 저장")
                            .font(.Yunseul.callout)
                            .tracking(1)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.Yunseul.starBlue.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.Yunseul.starBlue.opacity(0.6), lineWidth: 0.5)
                            )
                    )
                }
                .disabled(isSaving)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
    }
    
    // MARK: - 카메라 사진 + 오버레이 합성
    private func compositeImage(cameraPhoto: UIImage) -> UIImage {
        
        // 화면 사이즈 그대로 사용 (scale 곱하지 않음)
        let screenSize = UIScreen.main.bounds.size
        
        let renderer = UIGraphicsImageRenderer(size: screenSize)
        
        return renderer.image { ctx in
            // ① 카메라 사진을 화면 사이즈에 맞게 그리기
            let photoAspect = cameraPhoto.size.width / cameraPhoto.size.height
            let screenAspect = screenSize.width / screenSize.height
            
            var drawRect = CGRect.zero
            if photoAspect > screenAspect {
                let drawHeight = screenSize.height
                let drawWidth = drawHeight * photoAspect
                drawRect = CGRect(
                    x: -(drawWidth - screenSize.width) / 2,
                    y: 0,
                    width: drawWidth,
                    height: drawHeight
                )
            } else {
                let drawWidth = screenSize.width
                let drawHeight = drawWidth / photoAspect
                drawRect = CGRect(
                    x: 0,
                    y: -(drawHeight - screenSize.height) / 2,
                    width: drawWidth,
                    height: drawHeight
                )
            }
            cameraPhoto.draw(in: drawRect)
            
            // ② 오버레이 렌더링
            let overlayVC = UIHostingController(
                rootView: OverlaySnapshotView(
                    constellation: viewStore.constellation,
                    briefingText: viewStore.briefingText,
                    dateString: currentDateString
                )
            )
            overlayVC.view.frame = CGRect(origin: .zero, size: screenSize)
            overlayVC.view.backgroundColor = .clear
            
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first
            
            window?.addSubview(overlayVC.view)
            overlayVC.view.drawHierarchy(
                in: CGRect(origin: .zero, size: screenSize),
                afterScreenUpdates: true
            )
            overlayVC.view.removeFromSuperview()
        }
    }
    
    // MARK: - 캡처 후 저장
    private func captureAndSave() {
        isSaving = true
        cameraManager.capturePhoto { cameraImage in
            guard let cameraImage else {
                DispatchQueue.main.async { self.isSaving = false }
                return
            }
            
            let final = self.compositeImage(cameraPhoto: cameraImage)
            
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                guard status == .authorized || status == .limited else {
                    DispatchQueue.main.async { self.isSaving = false }
                    return
                }
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: final)
                } completionHandler: { success, _ in
                    DispatchQueue.main.async {
                        self.isSaving = false
                        if success {
                            withAnimation { self.showSaveSuccess = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { self.showSaveSuccess = false }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 날짜
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
    
    // MARK: - 펄스 애니메이션
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
        }
    }
}

// MARK: - 오버레이 전용 뷰 (카메라 위에 합성)
struct OverlaySnapshotView: View {
    let constellation: Constellation
    let briefingText: String
    let dateString: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                // 별자리 이미지
                ZStack {
                    Image(constellation.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 120)
                        .shadow(color: Color(hex: "8AAEFF").opacity(0.9), radius: 24)
                }
                
                Spacer().frame(height: 24)
                
                // 별자리 이름
                Text(constellation.rawValue)
                    .font(.custom("Georgia", size: 30))
                    .foregroundColor(.white)
                    .tracking(6)
                    .shadow(color: Color(hex: "8AAEFF").opacity(0.8), radius: 12)
                
                Text(constellation.latinName)
                    .font(.custom("Georgia-Italic", size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(4)
                    .padding(.top, 6)
                
                Spacer().frame(height: 20)
                
                // 구분선
                Rectangle()
                    .frame(width: 0.5, height: 30)
                    .foregroundColor(.white.opacity(0.3))
                
                Spacer().frame(height: 20)
                
                Text(briefingText)
                    .font(.custom("Georgia-Italic", size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 40)
                
                Spacer().frame(height: 20)
                
                VStack(spacing: 6) {
                    Text(dateString)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(2)
                    
                    Text("✦ YUNSEUL")
                        .font(.system(size: 10, design: .monospaced))  
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(4)
                }
                
                Spacer().frame(height: 100)
            }
        }
        .background(Color.clear)
    }
}
