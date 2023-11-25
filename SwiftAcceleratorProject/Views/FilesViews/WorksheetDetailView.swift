import SwiftUI

struct WorksheetDetailView: View {
    @State private var lockAfterDuration = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var title = ""
    @State private var subtitle = ""
    @State private var practicePaper = false
    @Environment(\.dismiss) var dismiss
    @State private var showScannerSheet = false
    @State private var canScan = false
    @Binding var scannedImages: [ScannedImage]
    @ObservedObject var dataManager: DataManager
    
    @State private var durationHours = 1
    @State private var selectedSubject: String = ""
    @State private var selectedTopic: String = ""
    @State private var durationMinutes = 0
    @State private var isDurationPickerPresented = false
    @State private var selectedDurationLabel = "01:00:00"
    
    @State private var scannedUIImage: [UIImage] = []
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Worksheet Details")) {
                    TextField("Enter a title", text: $title)
                    TextField("Enter a subtitle", text: $subtitle)
                }
                
                Section(header: Text("Additional Details")) {
                    NavigationLink(destination: SubjectView(dataManager: dataManager, selectedSubject: $selectedSubject) { subject in
                        selectedSubject = subject
                    }) {
                        HStack {
                            Text("Subject")
                            Spacer()
                            Text(selectedSubject.isEmpty ? "Select" : selectedSubject)
                                .foregroundColor(selectedSubject.isEmpty ? .gray : .primary)
                        }
                    }
                    
                    NavigationLink(destination: TopicView(dataManager: dataManager, selectedTopic: $selectedTopic) { topic in
                        selectedTopic = topic
                    }) {
                        HStack {
                            Text("Topic")
                            Spacer()
                            Text(selectedTopic.isEmpty ? "Select" : selectedTopic)
                                .foregroundColor(selectedSubject.isEmpty ? .gray : .primary)
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
            }
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        saveScannedImages()
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        validateFields()
                        if canScan {
                            showScannerSheet = true
                        } else {
                            // Set alert properties
                            alertTitle = "Incomplete Fields"
                            alertMessage = "Please fill in all required fields before scanning."
                            showAlert = true
                        }
                    } label: {
                        Text("Scan worksheet")
                            .bold()
                            .foregroundStyle(Color.accentColor)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
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
    }
    
    private func validateFields() {
        let isTestPaperValid = practicePaper && (durationHours > 0 || durationMinutes > 0)
        
        canScan = !title.isEmpty &&
        !selectedSubject.isEmpty &&
        !selectedTopic.isEmpty &&
        (!practicePaper || isTestPaperValid)
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
            lockAfterDuration: self.lockAfterDuration,
            subject: self.selectedSubject,
            topic: self.selectedTopic
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

