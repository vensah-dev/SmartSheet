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
    @State private var ShowImage = false
    
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
        
        List {
            Section{
                Button{
                    ShowImage.toggle()
                }label:{
                    Image(uiImage: image.first ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .cornerRadius(20)
                        .padding(10)
                }
                .fullScreenCover(isPresented: $ShowImage, content:{
                    ImageDetailView(images: image, currentIndex: index, dataManager: dataManager)
                })
            }
            .listRowBackground(Color.red.opacity(0.0))
            
            
            Section(header: Text("Additional Details")) {
                if isEditing{
                    //subjects
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
                            Text(scannedImage.subject)
                        }
                    }
                    
                    //topics
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
                            Text(scannedImage.topic)
                        }
                    }
                }
                else{
                    //subjects
                    HStack {
                        Text("Subject")
                        Spacer()
                        Text(scannedImage.subject)
                    }
                    
                    //topics
                    HStack {
                        Text("Topic")
                        Spacer()
                        Text(selectedTopic.isEmpty ? "Select" : selectedTopic)
                            .foregroundColor(selectedSubject.isEmpty ? .gray : .primary)
                    }
                }
                
                TextField("Notes", text: $dataManager.scannedImages[index].caption)
                    .disabled(!isEditing)
            }
        }
        .navigationTitle($dataManager.scannedImages[index].title)
        .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
        .navigationBarItems(trailing: editButton)


    }
    
    private var editButton: some View {
        Button(action: {
            withAnimation {
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
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        NavigationStack{
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
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label:{
                        
                    }
                }
            }
            .onAppear {
                DispatchQueue.global().async {
                    loadedImages = images
                }
            }
            .onDisappear {
                dataManager.saveEvents()
                dataManager.saveScannedImages()
            }
        }
    }
}
