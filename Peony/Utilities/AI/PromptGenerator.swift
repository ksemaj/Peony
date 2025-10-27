//
//  PromptGenerator.swift
//  Peony
//
//  Created for version 2.5 - AI Features
//

import Foundation

/// Manages writing prompts and intelligent rotation
class PromptGenerator {
    
    static let shared = PromptGenerator()
    
    private var allPrompts: [WritingPrompt] = []
    
    private init() {
        loadPrompts()
    }
    
    // MARK: - Public Methods
    
    /// Get today's writing prompt
    func getTodaysPrompt() -> WritingPrompt? {
        // Check if we already selected a prompt today
        if let existingPrompt = getStoredTodaysPrompt() {
            return existingPrompt
        }
        
        // Select a new prompt for today
        let newPrompt = selectNewPrompt()
        storePrompt(newPrompt)
        return newPrompt
    }
    
    /// Mark that user responded to a prompt
    func markPromptResponded(_ promptID: String) {
        var responded = getRespondedPromptIDs()
        if !responded.contains(promptID) {
            responded.append(promptID)
            AppSettings.respondedPromptIDs = responded
        }
    }
    
    /// Get a random prompt (for skip functionality)
    func getNewPrompt() -> WritingPrompt? {
        let newPrompt = selectNewPrompt()
        storePrompt(newPrompt)
        return newPrompt
    }
    
    // MARK: - Private Methods
    
    private func loadPrompts() {
        // Load prompts from JSON bundle resource
        guard let url = Bundle.main.url(forResource: "Prompts", withExtension: "json") else {
            print("❌ ERROR: Prompts.json not found in bundle")
            print("❌ Make sure Prompts.json is added to 'Copy Bundle Resources' in Build Phases")
            allPrompts = []
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("❌ ERROR: Could not read Prompts.json")
            allPrompts = []
            return
        }
        
        guard let prompts = try? JSONDecoder().decode([WritingPrompt].self, from: data) else {
            print("❌ ERROR: Could not decode Prompts.json")
            print("❌ Check JSON format is valid")
            allPrompts = []
            return
        }
        
        allPrompts = prompts
        print("✅ Loaded \(allPrompts.count) writing prompts from Prompts.json")
    }
    
    private func getStoredTodaysPrompt() -> WritingPrompt? {
        // Check if we have a prompt from today
        guard let lastDate = AppSettings.lastPromptDate,
              Calendar.current.isDateInToday(lastDate),
              !AppSettings.lastPromptID.isEmpty,
              let prompt = allPrompts.first(where: { $0.id == AppSettings.lastPromptID }) else {
            return nil
        }
        
        return prompt
    }
    
    private func selectNewPrompt() -> WritingPrompt? {
        guard !allPrompts.isEmpty else { return nil }
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let recentIDs = getRecentPromptIDs()
        
        // Filter prompts:
        // 1. Appropriate for current time
        // 2. Not shown recently (within last 14 prompts)
        var candidates = allPrompts.filter { prompt in
            prompt.isAppropriateForTime(currentHour) &&
            !recentIDs.contains(prompt.id)
        }
        
        // If all time-appropriate prompts were recent, use any time-appropriate prompt
        if candidates.isEmpty {
            candidates = allPrompts.filter { $0.isAppropriateForTime(currentHour) }
        }
        
        // If still empty, use any prompt
        if candidates.isEmpty {
            candidates = allPrompts
        }
        
        // Randomly select from candidates
        return candidates.randomElement()
    }
    
    private func storePrompt(_ prompt: WritingPrompt?) {
        guard let prompt = prompt else { return }
        
        // Store current prompt and date
        AppSettings.lastPromptDate = Date()
        AppSettings.lastPromptID = prompt.id
        
        // Add to recent prompts (keep last 14)
        var recent = getRecentPromptIDs()
        recent.append(prompt.id)
        if recent.count > 14 {
            recent.removeFirst()
        }
        AppSettings.recentPromptIDs = recent
    }
    
    private func getRecentPromptIDs() -> [String] {
        return AppSettings.recentPromptIDs
    }
    
    private func getRespondedPromptIDs() -> [String] {
        return AppSettings.respondedPromptIDs
    }
}

