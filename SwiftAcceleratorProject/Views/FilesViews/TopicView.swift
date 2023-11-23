//
//  TopicView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 20/11/23.
//

import SwiftUI

struct TopicView: View {
    @ObservedObject var dataManager = DataManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddTopicModalPresented = false
    @Binding var selectedTopic: String
    @State private var newTopic = ""
    var onTopicSelected: (String) -> Void

    @State private var topics: [String] = []

    var body: some View {
        List {
            ForEach(topics, id: \.self) { topic in
                Button(action: {
                    selectedTopic = topic
                    onTopicSelected(selectedTopic)
                    presentationMode.wrappedValue.dismiss()
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
                    topics.append(newTopic)
                    onTopicSelected(newTopic)
                    newTopic = ""
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
        let topicsToRemove = offsets.map { topics[$0] }

        // Remove corresponding scannedImages
        dataManager.scannedImages.removeAll { scannedImage in
            topicsToRemove.contains(scannedImage.topic)
        }

        // Update the topics
        topics.remove(atOffsets: offsets)

        // Save the changes to dataManager
        dataManager.saveScannedImages()
    }
}
