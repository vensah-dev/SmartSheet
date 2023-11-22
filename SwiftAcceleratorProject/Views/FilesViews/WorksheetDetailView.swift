import SwiftUI

struct WorksheetDetailView: View {
    @State private var lockAfterDuration = false
    @State private var title = ""
    @State private var subtitle = ""
    @State private var practicePaper = false
    @Environment(\.dismiss) var dismiss
    @State private var showScannerSheet = false
    @Binding var scannedImages: [ScannedImage]
    @ObservedObject var dataManager: DataManager
    
    @State private var durationHours = 1
    @State private var durationMinutes = 0
    @State private var isDurationPickerPresented = false
    @State private var selectedDurationLabel = "01:00:00"
    
    @State private var scannedUIImage: [UIImage] = []
    
    var body: some View {
        List {
            Section(header: Text("Worksheet Details")) {
                TextField("Enter a title", text: $title)
                TextField("Enter a subtitle", text: $subtitle)
            }
            
            Section(header: Text("Additional Details")) {
                NavigationLink(destination: SubjectView()) {
                    HStack {
                        Text("Subject")
                        Spacer()
                        Text("Select")
                            .foregroundStyle(.gray)
                    }
                }
                
                NavigationLink(destination: TopicView()) {
                    HStack {
                        Text("Topic")
                        Spacer()
                        Text("Select")
                            .foregroundStyle(.gray)
                    }
                }
                
                Toggle("Practice Paper", isOn: $practicePaper)
                
                if practicePaper {
                    HStack {
                        Text("Duration")
                        Spacer()
                        Button(action: {
                            isDurationPickerPresented.toggle()
                        }) {
                            HStack {
                                Text(selectedDurationLabel)
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    
                    if isDurationPickerPresented {
                        HStack {
                            Spacer()
                            WheelPicker(selection: $durationHours, range: 0..<24, label: "Hours")
                                .frame(width: 100, height: 120)
                            
                            WheelPicker(selection: $durationMinutes, range: 0..<60, label: "Minutes")
                                .frame(width: 100, height: 120)
                            Spacer()
                        }
                        .onChange(of: durationHours) { _ in
                            updateSelectedDurationLabel()
                        }
                        .onChange(of: durationMinutes) { _ in
                            updateSelectedDurationLabel()
                        }
                    }
                    
                    Toggle("Lock after duration", isOn: $lockAfterDuration)
                }
            }
            
            Section {
                Button {
                    showScannerSheet = true
                } label: {
                    Text("Scan worksheet")
                }
                
                Button(role: .destructive) {
                    saveScannedImages()
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New Worksheet")
        .sheet(isPresented: $showScannerSheet) {
            ScannerView { scannedImage in
                if let images = scannedImage {
                    if !practicePaper {
                        durationHours = 0
                        durationMinutes = 0
                        scannedUIImage.append(contentsOf: images)
                        saveScannedImages()
                        dismiss()
                    } else {
                        scannedUIImage.append(contentsOf: images)
                        saveScannedImages()
                        dismiss()
                    }
                }
                self.showScannerSheet = false
            }
        }
        .onChange(of: scannedImages) { _ in
            dataManager.saveScannedImages()
        }
    }
    
    private func saveScannedImages() {
        if scannedUIImage.isEmpty {
            return
        }
        
        let newScannedImage = ScannedImage(
            title: self.title,
            caption: self.subtitle,
            image: scannedUIImage,
            durationHours: self.durationHours,
            durationMinutes: self.durationMinutes,
            lockAfterDuration: self.lockAfterDuration
        )
        
        scannedImages.append(newScannedImage)
        dataManager.saveScannedImages()
        scannedUIImage = []
    }
    
    private func updateSelectedDurationLabel() {
        selectedDurationLabel = String(format: "%02d:%02d:00", durationHours, durationMinutes)
    }
}

struct WheelPicker: View {
    @Binding var selection: Int
    let range: Range<Int>
    
    let label: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
            Picker("", selection: $selection) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
