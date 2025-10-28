//
//  CustomTimePicker.swift
//  Peony
//
//  Custom time picker with improved contrast and readability
//

import SwiftUI

struct CustomTimePicker: UIViewRepresentable {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        
        // Set up the date
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        picker.date = Calendar.current.date(from: components) ?? Date()
        
        // Force dark text colors for better readability
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        
        // Set up the change handler
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        let newDate = Calendar.current.date(from: components) ?? Date()
        
        if abs(newDate.timeIntervalSince(uiView.date)) > 60 {
            uiView.date = newDate
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: CustomTimePicker
        
        init(_ parent: CustomTimePicker) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
            parent.selectedHour = components.hour ?? 9
            parent.selectedMinute = components.minute ?? 0
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var hour = 10
        @State private var minute = 0
        
        var body: some View {
            VStack {
                CustomTimePicker(selectedHour: $hour, selectedMinute: $minute)
                    .frame(height: 216)
                
                Text("Selected: \(hour):\(String(format: "%02d", minute))")
                    .padding()
            }
            .background(Color.cardLight)
        }
    }
    
    return PreviewWrapper()
}


