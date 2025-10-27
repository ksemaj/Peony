//
//  EditSeedView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI
import SwiftData
import PhotosUI

/// View for editing an existing seed's content
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
                // Pastel garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        PlantView(growthStage: seed.growthStage, size: 60)
                            .padding(.top, 20)
                        
                        // Title input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Title")
                                .font(.serifSubheadline)
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
                                .font(.serifSubheadline)
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
                                .font(.serifSubheadline)
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

#Preview {
    EditSeedView(seed: JournalSeed(content: "Test content", title: "My Seed"))
        .modelContainer(for: JournalSeed.self, inMemory: true)
}


