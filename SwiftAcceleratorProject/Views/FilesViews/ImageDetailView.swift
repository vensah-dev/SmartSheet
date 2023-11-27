//
//  ImageView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 21/11/23.
//

import SwiftUI

struct ImageDetail: View {
    @State var index: Int = 0
    @State var title: String
    @State var image: [UIImage]
    @StateObject var dataManager: DataManager
    
    // Additional state variables for editing
    @State private var isEditing = false
    @State private var ShowImage = false
    
    @State var isViewLocked = Bool()
    
    @State var practicePaper = false
    
    @State private var selectedSubject = ""
    @State private var selectedTopic = ""
    @State private var isDurationPickerPresented = false
    @State private var durationHours = 0
    @State private var durationMinutes = 0
    @State private var lockAfterDuration = false
    @State private var isCompleted = false
    
    
    var body: some View {
        
        List {
            Section{
                VStack{
                    Button{
                        ShowImage.toggle()
                    }label:{
                        Image(uiImage: image[0])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 380, height: 300)
                            .cornerRadius(22)
                            .padding()
                    }
                    .fullScreenCover(isPresented: $ShowImage, content:{
                        ImageDetailView(images: image, currentIndex: index, dataManager: dataManager, isViewLocked: $isViewLocked)
                    })
                    
                    if(!dataManager.scannedImages[index].caption.isEmpty || isEditing){
                        TextField("Notes", text: $dataManager.scannedImages[index].caption)
                            .disabled(!isEditing)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 15)
                    }
                }
            }
            .listRowBackground(Color.red.opacity(0.0))
            
            
            Section(header: Text("Additional Details")) {
                if isEditing{
                    //subjects
                    NavigationLink(destination: SubjectView(dataManager: dataManager, selectedSubject: $selectedSubject, edit: true) { subject in
                        selectedSubject = subject
                        if isEditing {
                            // Save edited subject when in editing mode
                            dataManager.scannedImages[index].subject = selectedSubject
                        }
                    }) {
                        HStack {
                            Text("Subject")
                            Spacer()
                            Text(dataManager.scannedImages[index].subject)
                        }
                    }
                    
                    //topics
                    NavigationLink(destination: TopicView(dataManager: dataManager, selectedTopic: $selectedTopic, edit: true) { topic in
                        selectedTopic = topic
                        if isEditing {
                            // Save edited topic when in editing mode
                            dataManager.scannedImages[index].topic = selectedTopic
                        }
                    }) {
                        HStack {
                            Text("Topic")
                            Spacer()
                            Text(dataManager.scannedImages[index].topic)
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
                                    Text(String(format: "%02d:%02d:00", dataManager.scannedImages[index].durationHours ?? 0, dataManager.scannedImages[index].durationMinutes ?? 0))
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
                                dataManager.scannedImages[index].durationHours = durationHours
                                dataManager.saveScannedImages()
                            }
                            .onChange(of: durationMinutes) { _ in
                                dataManager.scannedImages[index].durationMinutes = durationMinutes
                                dataManager.saveScannedImages()
                            }
                        }
                        
                    }
    
                }
                else{
                    //subjects
                    HStack {
                        Text("Subject")
                        Spacer()
                        Text(dataManager.scannedImages[index].subject)
                    }
                    
                    //topics
                    HStack {
                        Text("Topic")
                        Spacer()
                        Text(dataManager.scannedImages[index].topic)
                    }
                    
                    Toggle("Practice Paper", isOn: $practicePaper)
                        .disabled(true)
                    if practicePaper{
                        HStack {
                            Text("Duration")
                            Spacer()
                            
                            Text(String(format: "%02d:%02d:00", dataManager.scannedImages[index].durationHours ?? 0, dataManager.scannedImages[index].durationMinutes ?? 0))
                        }

                    }
                }
            }
        }
        .navigationTitle($dataManager.scannedImages[index].title)
        .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
        .navigationBarItems(trailing: editButton)
        .onAppear{
            getIndex(title: title)
            
            if(dataManager.scannedImages[index].durationMinutes == 0 && dataManager.scannedImages[index].durationHours == 0){
                practicePaper = false
            }
            else{
                practicePaper = true
            }
            
            dataManager.scannedImages[index].used += 1
        }
        
        
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
    
    func getIndex(title: String){
        var i = 0
        
        for x in dataManager.scannedImages{
            if(x.title == title){
                index = i
            }
            
            i += 1
        }
    }
}

struct ImageDetailView: View {
    var images: [UIImage]
    var currentIndex: Int
    @StateObject var dataManager: DataManager
    @State private var loadedImages: [UIImage] = []
    
    @Environment(\.dismiss) var dismiss
    @Binding var isViewLocked: Bool
    @State var lockAfterDuration = Bool()
    
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 20) {
                        ForEach(loadedImages.indices, id: \.self) { index in
                            TimerView(isViewLocked: $isViewLocked, durationHours: dataManager.scannedImages[index].durationHours ?? 0, durationMinutes: dataManager.scannedImages[index].durationMinutes ?? 0, lockAfterDuration: lockAfterDuration)
                            Image(uiImage: loadedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label:{
                        Text("Done")
                            .foregroundStyle(Color.accentColor)
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


