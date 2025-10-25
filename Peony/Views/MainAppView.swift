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
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Custom animated container for smooth transitions
            Group {
                if selectedTab == 0 {
                    ContentView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .zIndex(selectedTab == 0 ? 1 : 0)
                } else {
                    NotesView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                        .zIndex(selectedTab == 1 ? 1 : 0)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.82), value: selectedTab)
            
            // Custom Tab Bar
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    // Garden Tab Button
                    TabButton(
                        icon: "leaf.fill",
                        title: "Garden",
                        isSelected: selectedTab == 0,
                        namespace: animation
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            selectedTab = 0
                        }
                    }
                    
                    // Notes Tab Button
                    TabButton(
                        icon: "note.text",
                        title: "Notes",
                        isSelected: selectedTab == 1,
                        namespace: animation
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            selectedTab = 1
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 0)
                )
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.gray.opacity(0.3)),
                    alignment: .top
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Custom Tab Button

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(isSelected ? .green : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .green : .gray)
                
                // Selection indicator
                if isSelected {
                    Circle()
                        .fill(.green)
                        .frame(width: 4, height: 4)
                        .matchedGeometryEffect(id: "tab_indicator", in: namespace)
                } else {
                    Circle()
                        .fill(.clear)
                        .frame(width: 4, height: 4)
                }
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

