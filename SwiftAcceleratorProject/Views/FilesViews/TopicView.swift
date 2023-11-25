//
//  TopicView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 20/11/23.
//

import SwiftUI

struct TopicView: View {
    @ObservedObject var dataManager = DataManager()
    @State private var isAddTopicModalPresented = false
    @Binding var selectedTopic: String
    @State private var newTopic = ""
    var onTopicSelected: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss


    var body: some View {
        var topics = dataManager.topics
        
        List {
            ForEach(topics, id: \.self) { topic in
                Button(action: {
                    selectedTopic = topic
                    onTopicSelected(selectedTopic)
                    dismiss()
                }) {
                    Text(topic)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Topics")
        .navigationBarItems(trailing: Button(action: {
            isAddTopicModalPresented = true
        }) {
            Image(systemName: "plus.circle")
        })
        .alert("Add Topic", isPresented: $isAddTopicModalPresented) {
            TextField("New Topic", text: $newTopic)
            Button("Add") {
                if !newTopic.isEmpty {
                    if topics.contains(newTopic) {
                        isAddTopicModalPresented = false
                    } else {
                        dataManager.topics.append(newTopic)
                        onTopicSelected(newTopic)
                        newTopic = ""
                        isAddTopicModalPresented = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                isAddTopicModalPresented = false
            }
            Button("Cancel") {
                newTopic = ""
                isAddTopicModalPresented = false
            }
        } message: {
            Text("Please enter your topic.")
        }
        .onAppear {
            topics = dataManager.scannedImages.map(\.topic).removingDuplicates()
        }
        .onReceive(dataManager.$scannedImages) { _ in
            topics = dataManager.scannedImages.map(\.topic).removingDuplicates()
        }
    }

    private func delete(at offsets: IndexSet) {
        // Handle deletion of topics
        let topicsToRemove = offsets.map { dataManager.topics[$0] }

        // Remove corresponding scannedImages
        dataManager.scannedImages.removeAll { scannedImage in
            topicsToRemove.contains(scannedImage.topic)
        }

        // Update the topics
        dataManager.topics.remove(atOffsets: offsets)

        // Save the changes to dataManager
        dataManager.saveScannedImages()
    }
}
