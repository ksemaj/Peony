import SwiftUI
import SwiftData
import PhotosUI

// MARK: - Main View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalSeed.plantedDate, order: .reverse) private var allSeeds: [JournalSeed]
    @State private var showingPlantSheet = false
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background - Pastel Green & Ivory
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if allSeeds.isEmpty {
                    ScrollView {
                        VStack(spacing: 30) {
                            // Top decorative area with flora
                            ZStack {
                                HStack {
                                    CustomTreeView(size: 60, delay: 0.0)
                                        .offset(x: -20)
                                    Spacer()
                                    CustomTreeView(size: 70, delay: 0.3)
                                        .offset(x: 20)
                                }
                                .padding(.horizontal, 40)
                                
                                HStack(spacing: 0) {
                                    CustomBushView(size: 35, variant: 0)
                                        .offset(x: 30, y: 25)
                                    Spacer()
                                    CustomWildflowerView(size: 28, color: Color(red: 0.95, green: 0.75, blue: 0.85))
                                        .offset(x: -40, y: 30)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 60)
                            }
                            .padding(.top, 40)
                            
                            // Side flora
                            HStack {
                                VStack(spacing: 15) {
                                    CustomTreeView(size: 55, delay: 0.2)
                                    CustomMushroomView(size: 30)
                                        .offset(x: 15)
                                }
                                .offset(x: -30)
                                Spacer()
                                VStack(spacing: 15) {
                                    CustomRockView(size: 32, variant: 1)
                                    CustomWildflowerView(size: 25, color: Color.flowerPink)
                                }
                                .offset(x: -20)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 0)
                            
                            // Empty garden bed
                    VStack(spacing: 20) {
                                // Empty bed with message
                                VStack(spacing: 16) {
                                    CustomSeedView(size: 60)
                                        .padding(.top, 20)
                                    
                                    Text("Your garden awaits")
                            .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Text("Plant your first seed\nto begin your journey")
                            .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 20)
                                }
                                .frame(width: 340, height: 260)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.35, green: 0.55, blue: 0.35),
                                                    Color(red: 0.30, green: 0.50, blue: 0.30)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.3), lineWidth: 3)
                                        )
                                )
                                .overlay(
                                    // Grass texture
                                    ForEach(0..<15, id: \.self) { i in
                                        CustomGrassBlade(
                                            size: CGFloat.random(in: 15...25),
                                            rotation: Double.random(in: -35...35)
                                        )
                                        .offset(
                                            x: CGFloat.random(in: -150...150),
                                            y: CGFloat.random(in: -110...110)
                                        )
                                    }
                                )
                            }
                            
                            // More side flora
                            HStack {
                                VStack(spacing: 15) {
                                    CustomWildflowerView(size: 26, color: Color(red: 0.85, green: 0.70, blue: 0.95))
                                    CustomRockView(size: 28, variant: 2)
                                }
                                .offset(x: 20)
                                Spacer()
                                VStack(spacing: 15) {
                                    CustomTreeView(size: 65, delay: 0.5)
                                    CustomBushView(size: 38, variant: 1)
                                        .offset(x: -15)
                                }
                                .offset(x: 30)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 0)
                            
                            // Bottom decorative area with flora
                            ZStack {
                                HStack {
                                    CustomTreeView(size: 65, delay: 0.6)
                                        .offset(x: -15)
                                    Spacer()
                                    CustomTreeView(size: 58, delay: 0.9)
                                        .offset(x: 15)
                                }
                                .padding(.horizontal, 40)
                                
                                HStack(spacing: 0) {
                                    VStack(spacing: 10) {
                                        CustomBushView(size: 36, variant: 2)
                                        CustomMushroomView(size: 26)
                                    }
                                    .offset(x: 45, y: 15)
                                    Spacer()
                                    VStack(spacing: 10) {
                                        CustomWildflowerView(size: 30, color: Color.budPink)
                                        CustomRockView(size: 24, variant: 3)
                                    }
                                    .offset(x: -50, y: 20)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 70)
                            }
                            .padding(.bottom, 40)
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    GardenWithBedsView(seeds: allSeeds)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingOnboarding = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.green)
                    }
                }
                
                // TESTING: Title hidden
//                ToolbarItem(placement: .principal) {
//                    Text("Your Garden")
//                        .font(.custom("Didot", size: 30))
//                        .italic()
//                        .foregroundColor(Color(red: 0.3, green: 0.5, blue: 0.3))
//                        .offset(y: 8)
//                }
                
                ToolbarItem(placement: .primaryAction) {
                    HStack(spacing: 12) {
                        // Test notification button (for development)
                        Button {
                            NotificationManager.shared.sendTestNotification(type: .watering)
                        } label: {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.orange)
                        }
                        
                        // Plant seed button
                        Button {
                            showingPlantSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingPlantSheet) {
                PlantSeedView()
            }
            .fullScreenCover(isPresented: $showingOnboarding) {
                OnboardingTutorialView(isPresented: $showingOnboarding)
            }
        }
    }
}

// MARK: - Custom Tree View (3D Minimalist Style)
struct CustomTreeView: View {
    let size: CGFloat
    let delay: Double
    @State private var swayOffset: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Tree trunk
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(
                    LinearGradient(
                        colors: [Color.treeTrunkLight, Color.treeTrunkDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.25, height: size * 0.45)
                .offset(y: size * 0.25)
                .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: size * 0.03, y: size * 0.03)
            
            // Foliage - back layer (darkest)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafMid, Color.treeLeafDark],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.40
                    )
                )
                .frame(width: size * 0.75, height: size * 0.75)
                .offset(x: -size * 0.08, y: -size * 0.05)
            
            // Foliage - middle layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafLight, Color.treeLeafMid],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.70, height: size * 0.70)
                .offset(x: size * 0.08, y: -size * 0.08)
            
            // Foliage - front layer (lightest)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafLight, Color.treeLeafMid.opacity(0.9)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.30
                    )
                )
                .frame(width: size * 0.60, height: size * 0.60)
                .offset(y: -size * 0.12)
                .shadow(color: .black.opacity(0.1), radius: size * 0.08, x: 0, y: size * 0.05)
        }
        .frame(width: size, height: size)
        .rotationEffect(.degrees(swayOffset))
        .scaleEffect(scale)
        .drawingGroup() // Performance: Render as single layer
        .onAppear {
            // Gentle sway animation (simplified for performance)
            withAnimation(
                .easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                swayOffset = 1.5
            }
        }
    }
}

// MARK: - Custom Grass Blade
struct CustomGrassBlade: View {
    let size: CGFloat
    let rotation: Double
    
    var body: some View {
        Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                        Color(red: 0.40, green: 0.60, blue: 0.40).opacity(0.3),
                        Color(red: 0.35, green: 0.55, blue: 0.35).opacity(0.2)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: size * 0.15, height: size)
            .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Custom Dirt Mound
struct CustomDirtMound: View {
    let size: CGFloat
    
    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [Color.dirtLight.opacity(0.6), Color.dirtDark.opacity(0.5)],
                    center: .top,
                    startRadius: 0,
                    endRadius: size * 0.5
                )
            )
            .frame(width: size, height: size * 0.6)
            .blur(radius: 2)
            .overlay(
                Ellipse()
                    .fill(Color.dirtDark.opacity(0.2))
                    .frame(width: size * 0.7, height: size * 0.4)
                    .offset(y: size * 0.1)
            )
    }
}

// MARK: - Custom Plant Growth Stages
struct CustomSeedView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Seed shell
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.seedBrown.opacity(0.9), Color.seedBrown],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.4, height: size * 0.6)
                .rotationEffect(.degrees(-15))
                .shadow(color: .black.opacity(0.2), radius: size * 0.05, x: size * 0.02, y: size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

struct CustomSproutView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.sproutGreen, Color.sproutGreen.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.12, height: size * 0.5)
                .offset(y: size * 0.1)
            
            // Left leaf
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.sproutGreen, Color.sproutGreen.opacity(0.7)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.35, height: size * 0.25)
                .rotationEffect(.degrees(-45))
                .offset(x: -size * 0.15, y: -size * 0.05)
            
            // Right leaf
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.sproutGreen.opacity(0.95), Color.sproutGreen.opacity(0.75)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.35, height: size * 0.25)
                .rotationEffect(.degrees(45))
                .offset(x: size * 0.15, y: -size * 0.1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

struct CustomStemView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Main stem
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(
                    LinearGradient(
                        colors: [Color.stemGreen.opacity(0.9), Color.stemGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.15, height: size * 0.7)
                .offset(y: size * 0.05)
            
            // Top leaves (3 layers)
            ForEach(0..<3, id: \.self) { index in
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.stemGreen.opacity(0.9 - Double(index) * 0.1),
                                Color.stemGreen.opacity(0.7 - Double(index) * 0.1)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.4, height: size * 0.3)
                    .rotationEffect(.degrees(Double(index) * 120 - 60))
                    .offset(y: -size * 0.25)
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

struct CustomBudView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Stem
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(
                    LinearGradient(
                        colors: [Color.stemGreen.opacity(0.9), Color.stemGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.12, height: size * 0.5)
                .offset(y: size * 0.15)
            
            // Bud petals (closed)
            ForEach(0..<5, id: \.self) { index in
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color.budPink.opacity(0.95), Color.budPink.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.25, height: size * 0.4)
                    .rotationEffect(.degrees(Double(index) * 72))
                    .offset(y: -size * 0.15)
            }
            
            // Highlight
            Circle()
                .fill(Color.budPink.opacity(0.4))
                .frame(width: size * 0.2, height: size * 0.2)
                .offset(x: -size * 0.05, y: -size * 0.2)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

struct CustomFlowerView: View {
    let size: CGFloat
    @State private var petalRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Stem
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(
                    LinearGradient(
                        colors: [Color.stemGreen.opacity(0.9), Color.stemGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.12, height: size * 0.4)
                .offset(y: size * 0.2)
            
            // Petals (open)
            ForEach(0..<6, id: \.self) { index in
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color.flowerPink, Color.flowerPink.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.35, height: size * 0.35)
                    .offset(y: -size * 0.18)
                    .rotationEffect(.degrees(Double(index) * 60 + petalRotation))
            }
            
            // Center
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.flowerCenter, Color.flowerCenter.opacity(0.9)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.12
                    )
                )
                .frame(width: size * 0.25, height: size * 0.25)
                .overlay(
                    Circle()
                        .fill(Color.flowerCenter.opacity(0.5))
                        .frame(width: size * 0.12, height: size * 0.12)
                        .offset(x: -size * 0.04, y: -size * 0.04)
                )
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.2), radius: size * 0.1, x: 0, y: size * 0.05)
        .drawingGroup() // Performance: Render as single layer
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                petalRotation = 360
            }
        }
    }
}

// MARK: - Custom Plant View (Combines all growth stages)
struct CustomPlantView: View {
    let growthStage: GrowthStage
    let size: CGFloat
    
    var body: some View {
        switch growthStage {
        case .seed:
            CustomSeedView(size: size)
        case .sprout:
            CustomSproutView(size: size)
        case .stem:
            CustomStemView(size: size)
        case .bud:
            CustomBudView(size: size)
        case .flower:
            CustomFlowerView(size: size)
        }
    }
}

// MARK: - Custom Flora Elements (Decorative)

// Custom Bush
struct CustomBushView: View {
    let size: CGFloat
    let variant: Int
    
    var bushColor: Color {
        variant % 2 == 0 ? Color(red: 0.40, green: 0.60, blue: 0.45) : Color(red: 0.45, green: 0.65, blue: 0.50)
    }
    
    var body: some View {
        ZStack {
            // Base layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [bushColor.opacity(0.9), bushColor.opacity(0.7)],
                        center: .top,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
                .frame(width: size * 0.9, height: size * 0.7)
                .offset(y: size * 0.05)
            
            // Top highlights
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(bushColor.opacity(0.5))
                    .frame(width: size * 0.3, height: size * 0.25)
                    .offset(
                        x: CGFloat([-0.25, 0, 0.25][i]) * size,
                        y: -size * 0.15
                    )
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

// Custom Wildflower Cluster
struct CustomWildflowerView: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(Color.stemGreen.opacity(0.7))
                .frame(width: size * 0.08, height: size * 0.6)
                .offset(y: size * 0.2)
            
            // Flower head (small)
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color, color.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.1
                        )
                    )
                    .frame(width: size * 0.2, height: size * 0.2)
                    .offset(x: cos(Double(i) * .pi * 2 / 5) * size * 0.12,
                           y: sin(Double(i) * .pi * 2 / 5) * size * 0.12 - size * 0.15)
            }
            
            // Center
            Circle()
                .fill(Color.flowerCenter.opacity(0.9))
                .frame(width: size * 0.15, height: size * 0.15)
                .offset(y: -size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

// Custom Mushroom
struct CustomMushroomView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.93, blue: 0.88),
                            Color(red: 0.90, green: 0.88, blue: 0.83)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.25, height: size * 0.5)
                .offset(y: size * 0.15)
            
            // Cap
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.85, green: 0.45, blue: 0.45),
                            Color(red: 0.75, green: 0.35, blue: 0.35)
                        ],
                        center: .top,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.7, height: size * 0.45)
                .offset(y: -size * 0.12)
            
            // Spots on cap
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: size * 0.12, height: size * 0.12)
                    .offset(
                        x: CGFloat([-0.15, 0.1, -0.05][i]) * size,
                        y: CGFloat([-0.15, -0.08, -0.20][i]) * size
                    )
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

// Custom Rock
struct CustomRockView: View {
    let size: CGFloat
    let variant: Int
    
    var body: some View {
        ZStack {
            // Main rock shape
            RoundedRectangle(cornerRadius: size * 0.3)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.60, green: 0.58, blue: 0.55),
                            Color(red: 0.50, green: 0.48, blue: 0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.8, height: size * 0.6)
                .rotationEffect(.degrees(Double(variant) * 15))
            
            // Highlight
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: size * 0.25, height: size * 0.2)
                .offset(x: -size * 0.15, y: -size * 0.1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.2), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

// MARK: - Garden Path View
struct GardenPathView: View {
    @State private var scaleX: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Base path
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.85, green: 0.82, blue: 0.75))
                .frame(height: 40)
                .padding(.horizontal, 40)
            
            // Stone texture overlay
            HStack(spacing: 8) {
                ForEach(0..<12, id: \.self) { i in
                    Circle()
                        .fill(Color(red: 0.8, green: 0.77, blue: 0.7).opacity(0.4))
                        .frame(width: CGFloat.random(in: 8...14), height: CGFloat.random(in: 8...14))
                        .offset(y: CGFloat.random(in: -8...8))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(x: scaleX, y: 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.4)) {
                scaleX = 1.0
            }
        }
    }
}

// MARK: - Garden Bed View (Organic Layout)
struct GardenBedView: View {
    let seeds: [JournalSeed]
    let bedIndex: Int
    @State private var opacity: Double = 0
    @State private var yOffset: CGFloat = 30
    
    // Natural, organic positions for seeds (up to 9 per bed)
    let organicPositions: [CGPoint] = [
        CGPoint(x: -80, y: -60),   // Top left
        CGPoint(x: 20, y: -70),    // Top center
        CGPoint(x: 100, y: -50),   // Top right
        CGPoint(x: -90, y: 10),    // Middle left
        CGPoint(x: 0, y: 20),      // Center
        CGPoint(x: 95, y: 15),     // Middle right
        CGPoint(x: -70, y: 80),    // Bottom left
        CGPoint(x: 25, y: 90),     // Bottom center
        CGPoint(x: 85, y: 75)      // Bottom right
    ]
    
    var body: some View {
        ZStack {
            // Garden bed background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.55, blue: 0.35),
                            Color(red: 0.30, green: 0.50, blue: 0.30)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.3), lineWidth: 3)
                )
                .frame(width: 340, height: 260)
            
            // Grass texture overlay
            ForEach(0..<15, id: \.self) { i in
                CustomGrassBlade(
                    size: CGFloat.random(in: 12...22),
                    rotation: Double.random(in: -35...35)
                )
                    .offset(
                        x: CGFloat.random(in: -150...150),
                    y: CGFloat.random(in: -110...110)
                )
            }
            
            // Seeds placed organically
            ForEach(Array(seeds.enumerated()), id: \.element.id) { index, seed in
                if index < organicPositions.count {
                    NavigationLink(destination: SeedDetailView(seed: seed)) {
                        PlantedSeedView(seed: seed)
                    }
                    .buttonStyle(.plain)
                    .position(
                        x: 170 + organicPositions[index].x,
                        y: 130 + organicPositions[index].y
                    )
                }
            }
        }
        .frame(width: 340, height: 260)
        .opacity(opacity)
        .offset(y: yOffset)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(Double(bedIndex) * 0.15)) {
                opacity = 1.0
                yOffset = 0
            }
        }
    }
}

// MARK: - Garden View with Beds
struct GardenWithBedsView: View {
    let seeds: [JournalSeed]
    
    var numberOfBeds: Int {
        max(1, Int(ceil(Double(seeds.count) / 9.0)))
    }
    
    func seedsForBed(_ bedIndex: Int) -> [JournalSeed] {
        let startIndex = bedIndex * 9
        let endIndex = min(startIndex + 9, seeds.count)
        guard startIndex < seeds.count else { return [] }
        return Array(seeds[startIndex..<endIndex])
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Top decorative area - trees and flora
                ZStack {
                    HStack {
                        CustomTreeView(size: 60, delay: 0.0)
                            .offset(x: -20)
                        Spacer()
                        CustomTreeView(size: 70, delay: 0.3)
                            .offset(x: 20)
                    }
                    .padding(.horizontal, 40)
                    
                    // Add bushes and flowers in top area
                    HStack(spacing: 0) {
                        CustomBushView(size: 35, variant: 0)
                            .offset(x: 30, y: 25)
                        Spacer()
                        CustomWildflowerView(size: 28, color: Color(red: 0.95, green: 0.75, blue: 0.85))
                            .offset(x: -40, y: 30)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 60)
                }
                .padding(.top, 20)
                
                ForEach(0..<numberOfBeds, id: \.self) { bedIndex in
                    ZStack {
                        // Trees on sides
                        HStack {
                            if bedIndex % 2 == 0 {
                                VStack(spacing: 20) {
                                    CustomTreeView(size: 55, delay: Double(bedIndex) * 0.2)
                                    CustomMushroomView(size: 30)
                                        .offset(x: 15)
                                }
                                .offset(x: -30)
                                Spacer()
                            } else {
                                Spacer()
                                VStack(spacing: 20) {
                                    CustomTreeView(size: 65, delay: Double(bedIndex) * 0.2)
                                    CustomBushView(size: 40, variant: bedIndex)
                                        .offset(x: -20)
                                }
                                .offset(x: 30)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 0)
                        .zIndex(1)
                        
                        // Add flora near the bed
                        HStack {
                            if bedIndex % 2 == 0 {
                                Spacer()
                                VStack(spacing: 15) {
                                    CustomWildflowerView(size: 25, color: Color(red: 0.85, green: 0.70, blue: 0.95))
                                    CustomRockView(size: 28, variant: bedIndex)
                                }
                                .offset(x: -15)
                            } else {
                                VStack(spacing: 15) {
                                    CustomRockView(size: 32, variant: bedIndex + 1)
                                    CustomWildflowerView(size: 26, color: Color.flowerPink)
                                }
                                .offset(x: 15)
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .zIndex(0)
                    }
                    
                    GardenBedView(seeds: seedsForBed(bedIndex), bedIndex: bedIndex)
                    
                    if bedIndex < numberOfBeds - 1 {
                        ZStack {
                            GardenPathView()
                            
                            // Scatter small flora along the path
                            HStack(spacing: 100) {
                                CustomMushroomView(size: 24)
                                    .offset(y: -5)
                                CustomWildflowerView(size: 22, color: Color(red: 1.0, green: 0.90, blue: 0.70))
                                    .offset(y: 5)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                // Bottom decorative area - trees and flora
                ZStack {
                    HStack {
                        CustomTreeView(size: 65, delay: 0.6)
                            .offset(x: -15)
                        Spacer()
                        CustomTreeView(size: 58, delay: 0.9)
                            .offset(x: 15)
                    }
                    .padding(.horizontal, 40)
                    
                    // Add bottom flora
                    HStack(spacing: 0) {
                        VStack(spacing: 10) {
                            CustomBushView(size: 38, variant: 2)
                            CustomRockView(size: 26, variant: 3)
                        }
                        .offset(x: 45, y: 15)
                        Spacer()
                        VStack(spacing: 10) {
                            CustomWildflowerView(size: 30, color: Color.budPink)
                            CustomMushroomView(size: 28)
                        }
                        .offset(x: -50, y: 20)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 70)
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Planted Seed View (for garden patch)
struct PlantedSeedView: View {
    let seed: JournalSeed
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Dirt mound
                CustomDirtMound(size: 50)
                
                // Plant growing from soil
                if let image = seed.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(radius: 5)
                } else {
                    CustomPlantView(growthStage: seed.growthStage, size: 50)
                }
            }
            
            // Seed name tag
            Text(seed.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.8))
                        .shadow(radius: 2)
                )
                .lineLimit(1)
        }
        .frame(width: 100)
    }
}

// MARK: - Seed Card View
struct SeedCardView: View {
    let seed: JournalSeed
    
    var body: some View {
        VStack(spacing: 12) {
            // Image preview or custom plant
            if let image = seed.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green.opacity(0.3), lineWidth: 2))
                }
            } else {
                CustomPlantView(growthStage: seed.growthStage, size: 60)
            }
            
            Text(seed.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 4) {
                ProgressView(value: seed.growthPercentage, total: 100)
                    .tint(.green)
                
                Text("\(Int(seed.growthPercentage))% grown")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            
            Text(seed.plantedDate, style: .date)
                .font(.caption2)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Plant Seed View
struct PlantSeedView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var showingSuccess = false
    @State private var plantedSeed: JournalSeed?
    @FocusState private var focusedField: Field?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: UIImage?
    
    enum Field {
        case title, content
    }
    
    var gardenBackground: some View {
        LinearGradient(
            colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    var titleInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Give your seed a name")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            
            TextField("e.g., My New Beginning", text: $title, prompt: Text("e.g., My New Beginning").foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6)))
                .textFieldStyle(.plain)
                .focused($focusedField, equals: .title)
                .font(.body)
                .foregroundColor(.black)
                .tint(.green)
                .autocorrectionDisabled(false)
                .textInputAutocapitalization(.sentences)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .title ? Color.green : Color.clear, lineWidth: 2)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    var imagePickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add an image (optional)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            
            imagePickerContent
        }
        .padding(.horizontal, 20)
    }
    
    var imagePickerContent: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            if selectedImage != nil {
                selectedImageView
            } else {
                imagePlaceholder
            }
        }
        .buttonStyle(.plain)
    }
    
    var selectedImageView: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: selectedImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Button {
                selectedPhoto = nil
                selectedImage = nil
                selectedImageData = nil
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .padding(8)
        }
    }
    
    var imagePlaceholder: some View {
        HStack {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.title2)
                .foregroundColor(.green)
            Text("Tap to add a photo")
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
    
    var contentInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's on your mind?")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            
            contentEditorView
        }
        .padding(.horizontal, 20)
    }
    
    var contentEditorView: some View {
        ZStack(alignment: .topLeading) {
            if content.isEmpty {
                Text("Share your thoughts, feelings, or reflections...")
                    .font(.body)
                    .foregroundColor(.secondary.opacity(0.5))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 12)
                    .allowsHitTesting(false)
            }
            
            TextEditor(text: $content)
                .focused($focusedField, equals: .content)
                .font(.body)
                .foregroundColor(.black)
                .tint(.green)
                .autocorrectionDisabled(false)
                .textInputAutocapitalization(.sentences)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 200)
                .padding(4)
                .background(Color.clear)
        }
        .padding(8)
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .content ? Color.green : Color.clear, lineWidth: 2)
        )
    }
    
    var formContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                CustomSeedView(size: 60)
                    .padding(.top, 20)
                
                titleInputSection
                imagePickerSection
                contentInputSection
                
                Spacer(minLength: 20)
            }
        }
    }
    
    var body: some View {
        ZStack {
            if !showingSuccess {
                plantingFormView
            } else if let seed = plantedSeed {
                PlantingSuccessView(seed: seed) {
                    dismiss()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showingSuccess)
    }
    
    var plantingFormView: some View {
        NavigationStack {
            ZStack {
                gardenBackground
                formContent
            }
            .navigationTitle("Plant a Seed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Plant") {
                        plantSeed()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(title.isEmpty || content.isEmpty ? .secondary : .green)
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    private func plantSeed() {
        let newSeed = JournalSeed(content: content, title: title, imageData: selectedImageData)
        modelContext.insert(newSeed)
        plantedSeed = newSeed
        showingSuccess = true
        
        // Request notification permission and schedule notifications
        Task {
            let notificationManager = NotificationManager.shared
            if !notificationManager.isAuthorized {
                let granted = await notificationManager.requestAuthorization()
                if granted {
                    // Schedule bloom notification
                    notificationManager.scheduleBloomNotification(for: newSeed)
                    
                    // Schedule watering reminder if enabled
                    let wateringEnabled = UserDefaults.standard.bool(forKey: "wateringRemindersEnabled")
                    notificationManager.scheduleDailyWateringReminder(enabled: wateringEnabled)
                    
                    // Schedule weekly check-in if enabled
                    let weeklyEnabled = UserDefaults.standard.bool(forKey: "weeklyCheckinEnabled")
                    notificationManager.scheduleWeeklyCheckin(enabled: weeklyEnabled)
                }
            } else {
                // Already authorized, just schedule
                notificationManager.scheduleBloomNotification(for: newSeed)
            }
        }
    }
}

// MARK: - Planting Success View
struct PlantingSuccessView: View {
    let seed: JournalSeed
    let onDismiss: () -> Void
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var seedScale: CGFloat = 0.5
    @State private var seedRotation: Double = -180
    @State private var showSparkles = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // Garden background with blur
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .blur(radius: cardOpacity > 0 ? 20 : 0)
            .opacity(cardOpacity)
            
            // Success card
            VStack(spacing: 24) {
                // Animated seed emoji with sparkles
                ZStack {
                    // Sparkles effect
                    if showSparkles {
                        ForEach(0..<8) { index in
                            Text("✨")
                                .font(.title2)
                                .offset(
                                    x: cos(Double(index) * .pi / 4) * 45,
                                    y: sin(Double(index) * .pi / 4) * 45
                                )
                                .opacity(showSparkles ? 1 : 0)
                                .scaleEffect(showSparkles ? 1 : 0.1)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(Double(index) * 0.05), value: showSparkles)
                        }
                    }
                    
                    // Main seed
                    CustomSeedView(size: 70)
                        .scaleEffect(seedScale)
                        .rotationEffect(.degrees(seedRotation))
                }
                .padding(.top, 8)
                
                // Success message
                VStack(spacing: 12) {
                    Text("Seed Planted!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(seed.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Text("Planted \(seed.plantedDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    .padding(.top, 4)
                }
                .opacity(showText ? 1 : 0)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .frame(maxWidth: 320)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            // Card slides in with ease
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
            
            // Seed animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    seedScale = 1.0
                    seedRotation = 0
                }
            }
            
            // Sparkles burst
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    showSparkles = true
                }
            }
            
            // Text appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showText = true
                }
            }
            
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    cardScale = 0.8
                    cardOpacity = 0
                }
                
                // Call dismiss after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onDismiss()
                }
            }
        }
    }
}

// MARK: - Watering Success View
struct WateringSuccessView: View {
    let seed: JournalSeed
    let streakCount: Int
    let multiplier: Double
    let milestone: Int?
    let onDismiss: () -> Void
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var dropletsVisible = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .opacity(cardOpacity)
            
            // Water droplet animations
            if dropletsVisible {
                ForEach(0..<15) { index in
                    Text("💧")
                        .font(.title)
                        .offset(
                            x: CGFloat.random(in: -150...150),
                            y: -UIScreen.main.bounds.height / 2 + CGFloat(index) * 60
                        )
                        .animation(
                            .linear(duration: 2.0).delay(Double(index) * 0.1),
                            value: dropletsVisible
                        )
                }
            }
            
            // Success card
            VStack(spacing: 20) {
                // Water droplet icon
                Text("💧")
                    .font(.system(size: 60))
                
                // Success message
                VStack(spacing: 8) {
                    Text("Watered!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("+\(String(format: "%.1f", multiplier))% growth")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    // Streak display
                    if streakCount > 0 {
                        HStack(spacing: 4) {
                            Text("🔥")
                            Text("\(streakCount) day streak!")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 4)
                    }
                    
                    // Milestone celebration
                    if let milestone = milestone {
                        Text("🎉 \(milestone)-Day Milestone! 🎉")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .padding(.top, 8)
                    }
                }
                .opacity(showText ? 1 : 0)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .frame(maxWidth: 320)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            // Card animation
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
            
            // Droplets
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    dropletsVisible = true
                }
            }
            
            // Text appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showText = true
                }
            }
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Auto-dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    cardScale = 0.8
                    cardOpacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            }
        }
    }
}

// MARK: - Watering Button
struct WateringButton: View {
    let seed: JournalSeed
    let canWater: Bool
    @Binding var showAnimation: Bool
    let onWater: () -> Void
    
    var waterIconWithSparkles: some View {
        ZStack {
            Image(systemName: "drop.fill")
                .font(.title2)
            
            if showAnimation {
                sparklesView
            }
        }
    }
    
    var sparklesView: some View {
        ForEach(0..<6) { index in
            sparkleItem(at: index)
        }
    }
    
    func sparkleItem(at index: Int) -> some View {
        Image(systemName: "sparkle")
            .font(.caption)
            .foregroundColor(.blue.opacity(0.8))
            .offset(
                x: cos(Double(index) * .pi / 3) * 30,
                y: sin(Double(index) * .pi / 3) * 30
            )
            .opacity(showAnimation ? 1 : 0)
            .scaleEffect(showAnimation ? 1 : 0.1)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(Double(index) * 0.05), value: showAnimation)
    }
    
    var buttonLabel: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(canWater ? "Water Your Seed" : "Already Watered Today")
                    .font(.headline)
                    .foregroundColor(.black)
                
                // Show streak if active
                if seed.currentStreakCount > 0 {
                    HStack(spacing: 2) {
                        Text("🔥")
                            .font(.caption)
                        Text("\(seed.currentStreakCount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            if canWater {
                let multiplier = seed.wateringStreak?.streakMultiplier ?? 1.0
                Text("Tap to give +\(String(format: "%.1f", multiplier))% growth")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            } else {
                Text("Come back tomorrow!")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
        }
    }
    
    var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(canWater ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(canWater ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 2)
            )
    }
    
    var buttonContent: some View {
        HStack(spacing: 12) {
            waterIconWithSparkles
            buttonLabel
            Spacer()
            
            if canWater {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            }
        }
        .padding()
        .background(buttonBackground)
    }
    
    var body: some View {
        Button {
            if canWater {
                onWater()
            }
        } label: {
            buttonContent
        }
        .buttonStyle(.plain)
        .disabled(!canWater)
        .padding(.horizontal)
    }
}

// MARK: - Edit Seed View
struct EditSeedView: View {
    let seed: JournalSeed
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var content: String
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: UIImage?
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, content
    }
    
    init(seed: JournalSeed) {
        self.seed = seed
        _title = State(initialValue: seed.title)
        _content = State(initialValue: seed.content)
        _selectedImageData = State(initialValue: seed.imageData)
        if let imageData = seed.imageData {
            _selectedImage = State(initialValue: UIImage(data: imageData))
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        CustomPlantView(growthStage: seed.growthStage, size: 60)
                            .padding(.top, 20)
                        
                        // Title input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Title")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            
                            TextField("Entry title", text: $title, prompt: Text("Entry title").foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6)))
                                .textFieldStyle(.plain)
                                .focused($focusedField, equals: .title)
                                .font(.body)
                                .foregroundColor(.black)
                                .tint(.green)
                                .autocorrectionDisabled(false)
                                .textInputAutocapitalization(.sentences)
                                .padding()
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(focusedField == .title ? Color.green : Color.clear, lineWidth: 2)
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Image picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Image")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                if let image = selectedImage {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        
                                        Button {
                                            selectedPhoto = nil
                                            selectedImage = nil
                                            selectedImageData = nil
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.6)))
                                        }
                                        .padding(8)
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.title2)
                                            .foregroundColor(.green)
                                        Text("Tap to change photo")
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(12)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        
                        // Content input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Content")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Your thoughts...")
                                        .font(.body)
                                        .foregroundColor(.secondary.opacity(0.5))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 12)
                                        .allowsHitTesting(false)
                                }
                                
                                TextEditor(text: $content)
                                    .focused($focusedField, equals: .content)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .tint(.green)
                                    .autocorrectionDisabled(false)
                                    .textInputAutocapitalization(.sentences)
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 200)
                                    .padding(4)
                                    .background(Color.clear)
                            }
                            .padding(8)
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .content ? Color.green : Color.clear, lineWidth: 2)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        seed.title = title
        seed.content = content
        seed.imageData = selectedImageData
        dismiss()
    }
}

// MARK: - Seed Detail View
struct SeedDetailView: View {
    let seed: JournalSeed
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullScreenImage = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showWateringAnimation = false
    @State private var showWateringSuccess = false
    @State private var wateringScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 24) {
                // Plant display
                VStack(spacing: 16) {
                    CustomPlantView(growthStage: seed.growthStage, size: 100)
                    
                    Text("\(Int(seed.growthPercentage))% Grown")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    ProgressView(value: seed.growthPercentage, total: 100)
                        .tint(.green)
                        .frame(maxWidth: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(16)
                
                // Stats
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Planted:")
                            .foregroundColor(.black)
                        Spacer()
                        Text(seed.plantedDate, style: .date)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Days growing:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(Calendar.current.dateComponents([.day], from: seed.plantedDate, to: Date()).day ?? 0)")
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Growth stage:")
                            .foregroundColor(.black)
                        Spacer()
                        HStack(spacing: 6) {
                            CustomPlantView(growthStage: seed.growthStage, size: 20)
                            Text(seed.growthStage.displayName)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        Text("Times watered:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(seed.timesWatered)")
                            .foregroundColor(.black)
                    }
                    
                    // Streak information
                    if seed.currentStreakCount > 0 {
                        Divider()
                        
                        HStack {
                            HStack(spacing: 4) {
                                Text("🔥")
                                Text("Current streak:")
                            }
                            .foregroundColor(.black)
                            Spacer()
                            Text("\(seed.currentStreakCount) days")
                                .foregroundColor(.orange)
                                .fontWeight(.semibold)
                        }
                        
                        HStack {
                            Text("Streak bonus:")
                                .foregroundColor(.black)
                            Spacer()
                            let multiplier = seed.wateringStreak?.streakMultiplier ?? 1.0
                            Text("+\(String(format: "%.1f", multiplier))% per watering")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if seed.longestStreakCount > 0 {
                        HStack {
                            Text("Longest streak:")
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(seed.longestStreakCount) days")
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(16)
                
                // Watering mechanic
                if seed.growthPercentage < 100 {
                    WateringButton(
                        seed: seed,
                        canWater: seed.canWaterToday,
                        showAnimation: $showWateringAnimation,
                        onWater: {
                            let milestone = seed.checkStreakMilestone()
                            
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                seed.water()
                                showWateringAnimation = true
                            }
                            
                            // Show success view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showWateringSuccess = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showWateringAnimation = false
                                }
                            }
                        }
                    )
                }
                
                // Attached image (if exists)
                if let image = seed.image {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Memory")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Button {
                            showingFullScreenImage = true
                        } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                }
                
                // Journal entry (only show full content when flower blooms)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Entry")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    if seed.growthPercentage >= 100 {
                        Text(seed.content)
                            .font(.body)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("Your full entry will be revealed when this seed blooms into a flower. Keep nurturing your growth!")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .italic()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.8))
                .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .overlay {
            if showWateringSuccess {
                WateringSuccessView(
                    seed: seed,
                    streakCount: seed.currentStreakCount,
                    multiplier: seed.wateringStreak?.streakMultiplier ?? 1.0,
                    milestone: seed.checkStreakMilestone()
                ) {
                    showWateringSuccess = false
                }
            }
        }
        .navigationTitle(seed.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit Entry", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.green)
                }
            }
        }
        .fullScreenCover(isPresented: $showingFullScreenImage) {
            if let image = seed.image {
                FullScreenImageView(image: image)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditSeedView(seed: seed)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Cancel notifications for this seed
                NotificationManager.shared.cancelNotifications(for: seed)
                
                modelContext.delete(seed)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this journal entry? This action cannot be undone.")
        }
    }
}

// MARK: - Full Screen Image View
struct FullScreenImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var opacity: Double = 0
    @State private var cardScale: CGFloat = 0.9
    
    var body: some View {
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
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
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

#Preview {
    ContentView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}

