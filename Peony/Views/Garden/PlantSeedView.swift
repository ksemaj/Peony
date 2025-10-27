//
//  PlantSeedView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI
import SwiftData
import PhotosUI

/// View for planting a new seed with journal content
struct PlantSeedView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.notificationService) private var notificationService
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
                .font(.serifSubheadline)
                .foregroundColor(.black)

            TextField("e.g., My New Beginning", text: $title, prompt: Text("e.g., My New Beginning").foregroundColor(.softGray))
                .textFieldStyle(.plain)
                .focused($focusedField, equals: .title)
                .font(.body)
                .foregroundColor(.black)
                .tint(.warmGold)
                .autocorrectionDisabled(false)
                .textInputAutocapitalization(.sentences)
                .padding()
                .background(Color.cardLight)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .title ? Color.warmGold : Color.clear, lineWidth: 2)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    var imagePickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add an image (optional)")
                .font(.serifSubheadline)
                .foregroundColor(.black)
            
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
                .foregroundColor(.warmGold)
            Text("Tap to add a photo")
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.softGray)
        }
        .padding()
        .background(Color.cardLight)
        .cornerRadius(12)
    }
    
    var contentInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's on your mind?")
                .font(.serifSubheadline)
                .foregroundColor(.black)
            
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
                .tint(.warmGold)
                .autocorrectionDisabled(false)
                .textInputAutocapitalization(.sentences)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 200)
                .padding(4)
                .background(Color.clear)
        }
        .padding(8)
        .background(Color.cardLight)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == .content ? Color.warmGold : Color.clear, lineWidth: 2)
        )
    }
    
    var formContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                SeedView(size: 60)
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
            if !notificationService.isAuthorized {
                let granted = await notificationService.requestAuthorization()
                if granted {
                    // Schedule bloom notification
                    notificationService.scheduleBloomNotification(for: newSeed)
                    
                    // Schedule watering reminder if enabled
                    notificationService.scheduleDailyWateringReminder(enabled: AppSettings.wateringRemindersEnabled)
                    
                    // Schedule weekly check-in if enabled
                    notificationService.scheduleWeeklyCheckin(enabled: AppSettings.weeklyCheckinEnabled)
                }
            } else {
                // Already authorized, just schedule
                notificationService.scheduleBloomNotification(for: newSeed)
            }
        }
    }
}

#Preview {
    PlantSeedView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}


