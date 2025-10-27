//
//  PaywallView.swift
//  Peony
//
//  Premium Paywall - v4.0
//  Design: "Celebrate Every Bloom"
//

import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PricingPlan = .annual
    @State private var showFeatures = false

    enum PricingPlan {
        case monthly
        case annual
    }

    var body: some View {
        ZStack {
            // Pastel background gradient
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                    .padding(.horizontal)

                    // Header
                    VStack(spacing: 6) {
                        Text("🌸")
                            .font(.system(size: 44))

                        Text("Celebrate Every")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Bloom")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Premium makes your garden")
                            .font(.subheadline)
                            .foregroundColor(.softGray)

                        Text("even more special")
                            .font(.subheadline)
                            .foregroundColor(.softGray)
                    }
                    .padding(.top, 20)

                    // Feature cards (2x2 grid)
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            PremiumFeatureCard(
                                icon: "✨",
                                title: "Bloom\nCelebrations",
                                description: "Transform blooms into beautiful shareable moments"
                            )

                            PremiumFeatureCard(
                                icon: "🖼️",
                                title: "Bloom\nGallery",
                                description: "Keep every memory forever"
                            )
                        }

                        HStack(spacing: 12) {
                            PremiumFeatureCard(
                                icon: "🎨",
                                title: "Beautiful\nThemes",
                                description: "Cherry Blossom, Moonlight & more. Make it yours."
                            )

                            PremiumFeatureCard(
                                icon: "📤",
                                title: "Export &\nSafekeeping",
                                description: "Your journal, protected"
                            )
                        }
                    }
                    .padding(.horizontal)
                    .scaleEffect(showFeatures ? 1.0 : 0.9)
                    .opacity(showFeatures ? 1.0 : 0)

                    // Plus growth features
                    VStack(spacing: 12) {
                        Text("Plus Premium Growth:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        HStack(spacing: 20) {
                            Label("Water 3× daily", systemImage: "drop.fill")
                                .font(.subheadline)
                                .foregroundColor(.softGray)

                            Label("25% faster growth", systemImage: "flame.fill")
                                .font(.subheadline)
                                .foregroundColor(.softGray)
                        }
                    }
                    .padding(.vertical, 8)

                    // Pricing selector
                    VStack(spacing: 12) {
                        // Annual option
                        Button {
                            selectedPlan = .annual
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Annual")
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        Text("SAVE $20")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(
                                                Capsule()
                                                    .fill(Color(red: 0.72, green: 0.43, blue: 0.47))
                                            )
                                    }

                                    Text("$39.99/year")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)

                                    Text("Just $3.33 per month")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Image(systemName: selectedPlan == .annual ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(selectedPlan == .annual ? .warmGold : .gray.opacity(0.3))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardLight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedPlan == .annual ? Color.warmGold : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(.plain)

                        // Monthly option
                        Button {
                            selectedPlan = .monthly
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Monthly")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    Text("$4.99/month")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }

                                Spacer()

                                Image(systemName: selectedPlan == .monthly ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(selectedPlan == .monthly ? .warmGold : .gray.opacity(0.3))
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cardLight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedPlan == .monthly ? Color.warmGold : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)

                    // CTA Button
                    Button {
                        // TODO: Implement purchase flow
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    } label: {
                        VStack(spacing: 8) {
                            Text("Start Your Free Trial")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.warmGold, Color.amberGlow],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: .warmGold.opacity(0.4), radius: 5, x: 0, y: 2)

                            Text("Then cancel anytime, no strings")
                                .font(.caption)
                                .foregroundColor(.softGray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Trust signals
                    VStack(spacing: 8) {
                        Divider()
                            .padding(.horizontal)

                        VStack(spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.warmGold)
                                    .font(.caption)
                                Text("Your data stays private")
                                    .font(.caption)
                                    .foregroundColor(.softGray)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.warmGold)
                                    .font(.caption)
                                Text("No ads, ever")
                                    .font(.caption)
                                    .foregroundColor(.softGray)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.warmGold)
                                    .font(.caption)
                                Text("Cancel anytime")
                                    .font(.caption)
                                    .foregroundColor(.softGray)
                            }
                        }
                    }
                    .padding(.vertical)

                    // Restore purchases
                    Button {
                        // TODO: Implement restore purchases
                    } label: {
                        Text("Restore Purchases")
                            .font(.caption)
                            .foregroundColor(.softGray)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.2)) {
                showFeatures = true
            }
        }
    }
}

// MARK: - Premium Feature Card

struct PremiumFeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon)
                .font(.system(size: 28))

            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardLight)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Preview

#Preview {
    PaywallView()
}
