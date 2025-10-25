//
//  MainAppView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Content area with slide animation
                TabView(selection: $selectedTab) {
                    ContentView()
                        .tag(0)
                    
                    NotesView()
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(edges: .bottom)
                
                // Custom tab bar overlay
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "leaf.fill",
                        title: "Garden",
                        isSelected: selectedTab == 0
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = 0
                        }
                    }
                    
                    TabBarButton(
                        icon: "note.text",
                        title: "Notes",
                        isSelected: selectedTab == 1
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = 1
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 4 : 8)
                .background(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 0.33)
                        .foregroundStyle(.separator),
                    alignment: .top
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Tab Bar Button

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? Color.green : Color.gray)
                    .symbolEffect(.bounce, value: isSelected)
                
                Text(title)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainAppView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}

