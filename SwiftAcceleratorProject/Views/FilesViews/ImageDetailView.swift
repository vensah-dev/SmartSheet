//
//  ImageView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 21/11/23.
//

import SwiftUI

struct ImageDetail: View {
    @State var index: Int = 0
    @State var image: [UIImage]
    @StateObject var dataManager: DataManager
    
    // Additional state variables for editing
    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedCaption = ""
    @State private var selectedSubject = ""
    @State private var selectedTopic = ""
    @State private var practicePaper = false
    @State private var isDurationPickerPresented = false
    @State private var durationHours = 0
    @State private var durationMinutes = 0
    @State private var lockAfterDuration = false
    @State private var selectedDurationLabel = "Select"
    
    var body: some View {
        var scannedImage = dataManager.scannedImages[index]
        
        VStack {
            NavigationLink(destination: ImageDetailView(images: image, currentIndex: index, dataManager: dataManager)) {
                Image(uiImage: image.first ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .padding(10)
            }
            .navigationTitle(scannedImage.title)
            
            Spacer()
            
            List {
                Section(header: Text("Additional Details")) {
                    if isEditing {
                        // Display editable fields when in editing mode
                        TextField("Title", text: $editedTitle)
                        TextField("Caption", text: $editedCaption)
                    } else {
                        // Display non-editable fields
                        Text(scannedImage.title)
                        Text(scannedImage.caption)
                    }
                    
                    NavigationLink(destination: SubjectView(dataManager: dataManager, selectedSubject: $selectedSubject) { subject in
                        selectedSubject = subject
                        if isEditing {
                            // Save edited subject when in editing mode
                            scannedImage.subject = selectedSubject
                        }
                    }) {
                        HStack {
                            Text("Subject")
                            Spacer()
                            Text(selectedSubject.isEmpty ? "Select" : selectedSubject)
                                .foregroundColor(selectedSubject.isEmpty ? .gray : .primary)
                        }
                    }
                    .disabled(!isEditing)
                    
                    NavigationLink(destination: TopicView(dataManager: dataManager, selectedTopic: $selectedTopic) { topic in
                        selectedTopic = topic
                        if isEditing {
                            // Save edited topic when in editing mode
                            scannedImage.topic = selectedTopic
                        }
                    }) {
                        HStack {
                            Text("Topic")
                            Spacer()
                            Text(selectedTopic.isEmpty ? "Select" : selectedTopic)
                                .foregroundColor(selectedSubject.isEmpty ? .gray : .primary)
                        }
                    }
                    .disabled(!isEditing)
                    
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
        }
        .navigationBarItems(trailing: editButton)
    }
    
    private var editButton: some View {
        Button(action: {
            withAnimation {
                if isEditing {
                    dataManager.scannedImages[index].title = editedTitle
                    dataManager.scannedImages[index].caption = editedCaption
                } else {
                    editedTitle = dataManager.scannedImages[index].title
                    editedCaption = dataManager.scannedImages[index].caption
                }
                isEditing.toggle()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private func updateSelectedDurationLabel() {
        selectedDurationLabel = String(format: "%02d:%02d:00", durationHours, durationMinutes)
    }
}

struct ImageDetailView: View {
    var images: [UIImage]
    var currentIndex: Int
    @StateObject var dataManager: DataManager
    @State private var loadedImages: [UIImage] = []
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(loadedImages.indices, id: \.self) { index in
                    Image(uiImage: loadedImages[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.global().async {
                loadedImages = images
            }
        }
        .onDisappear {
            dataManager.saveScannedImages()
        }
    }
}
