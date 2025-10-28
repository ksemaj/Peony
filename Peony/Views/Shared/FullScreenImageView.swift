//
//  FullScreenImageView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI

/// Full-screen image viewer with pinch-to-zoom
struct FullScreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var opacity: Double = 0
    @State private var cardScale: CGFloat = 0.9
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark dimmed background
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                    .opacity(opacity)
                    .onTapGesture {
                        dismiss()
                    }
                
                // Centered image card
                VStack {
                    Spacer()
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width * 0.9)
                        .frame(maxHeight: geometry.size.height * 0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        .scaleEffect(scale * cardScale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                                // Reset if zoomed out too much
                                if scale < 0.5 {
                                    withAnimation(.spring()) {
                                        scale = 1.0
                                        lastScale = 1.0
                                    }
                                }
                            }
                    )
                
                Spacer()
            }
            .opacity(opacity)
            
            // Close button - top right
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacity = 0
                            cardScale = 0.9
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            dismiss()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                    }
                    .padding(20)
                }
                Spacer()
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                opacity = 1.0
                cardScale = 1.0
            }
        }
        }
    }
}

#Preview {
    if let image = UIImage(systemName: "photo") {
        FullScreenImageView(image: image)
    }
}


