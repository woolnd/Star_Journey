//
//  StarTrailGlobeView.swift
//  Yunseul
//
//  Created by wodnd on 4/13/26.
//

import SwiftUI
import MapKit

struct StarTrailGlobeView: UIViewRepresentable {
    
    let trailEntries: [StarTrailEntry]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybridFlyover
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = false
        
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        camera.altitude = 20_000_000
        camera.pitch = 0
        mapView.setCamera(camera, animated: false)
        
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 10_000_000,
            maxCenterCoordinateDistance: 30_000_000
        )
        
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKHybridMapConfiguration()
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        guard !trailEntries.isEmpty else { return }
        
        for entry in trailEntries {
            let annotation = TrailAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: entry.latitude,
                    longitude: entry.longitude
                ),
                date: entry.date ?? Date()
            )
            mapView.addAnnotation(annotation)
        }
        
        let coordinates = trailEntries.map {
            CLLocationCoordinate2D(
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
        let polyline = MKPolyline(
            coordinates: coordinates,
            count: coordinates.count
        )
        mapView.addOverlay(polyline)
        
        // 전체 궤적 보이도록 지도 조정
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is TrailAnnotation else { return nil }
            
            let view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: "trail"
            )
            view.markerTintColor = UIColor(Color.Yunseul.starBlue)
            view.glyphImage = UIImage(systemName: "star.fill")
            view.displayPriority = .defaultLow
            return view
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor(Color.Yunseul.starBlue).withAlphaComponent(0.6)
                renderer.lineWidth = 2
                renderer.lineDashPattern = [4, 4]
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

// MARK: - 커스텀 어노테이션
class TrailAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let date: Date
    
    var title: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return "✦ \(formatter.string(from: date))"
    }
    
    init(coordinate: CLLocationCoordinate2D, date: Date) {
        self.coordinate = coordinate
        self.date = date
    }
}
