//
//  ConstellationShapeView.swift
//  Yunseul
//
//  Created by wodnd on 4/10/26.
//

import SwiftUI

struct ConstellationShapeView: View {
    let constellation: Constellation
    @State private var imageOpacity: Double = 0

    var body: some View {
        Image(constellation.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 180)
            .opacity(imageOpacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    imageOpacity = 1
                }
            }
    }
}

#Preview {
    ZStack {
        Color(hex: "04060E").ignoresSafeArea()
        ScrollView {
            VStack(spacing: 32) {
                HStack(spacing: 24) {
                    VStack {
                        ConstellationShapeView(constellation: .aries)
                        Text("양자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .taurus)
                        Text("황소자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .gemini)
                        Text("쌍둥이자리").font(.caption).foregroundColor(.white)
                    }
                }
                HStack(spacing: 24) {
                    VStack {
                        ConstellationShapeView(constellation: .cancer)
                        Text("게자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .leo)
                        Text("사자자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .virgo)
                        Text("처녀자리").font(.caption).foregroundColor(.white)
                    }
                }
                HStack(spacing: 24) {
                    VStack {
                        ConstellationShapeView(constellation: .libra)
                        Text("천칭자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .scorpio)
                        Text("전갈자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .sagittarius)
                        Text("궁수자리").font(.caption).foregroundColor(.white)
                    }
                }
                HStack(spacing: 24) {
                    VStack {
                        ConstellationShapeView(constellation: .capricorn)
                        Text("염소자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .aquarius)
                        Text("물병자리").font(.caption).foregroundColor(.white)
                    }
                    VStack {
                        ConstellationShapeView(constellation: .pisces)
                        Text("물고기자리").font(.caption).foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
    }
}
