//
//  SubjectView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 20/11/23.
//

import SwiftUI

struct SubjectView: View {
    @ObservedObject var dataManager = DataManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddSubjectModalPresented = false
    @Binding var selectedSubject: String
    @State private var newSubject = ""
    var onSubjectSelected: (String) -> Void

    @State private var subjects: [String] = []

    var body: some View {
        List {
            ForEach(subjects, id: \.self) { subject in
                Button(action: {
                    selectedSubject = subject
                    onSubjectSelected(selectedSubject)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(subject)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Subjects")
        .navigationBarItems(trailing: Button(action: {
            isAddSubjectModalPresented = true
        }) {
            Image(systemName: "plus.circle")
        })
        .alert("Add Subject", isPresented: $isAddSubjectModalPresented) {
            TextField("New Subject", text: $newSubject)
            Button("Add") {
                if !newSubject.isEmpty {
                    subjects.append(newSubject)
                    onSubjectSelected(newSubject)
                    newSubject = ""
                }
                isAddSubjectModalPresented = false
            }
            Button("Cancel") {
                newSubject = ""
                isAddSubjectModalPresented = false
            }
        } message: {
            Text("Please enter your subject.")
        }
        .onAppear {
            subjects = dataManager.scannedImages.map(\.subject).removingDuplicates()
        }
        .onReceive(dataManager.$scannedImages) { _ in
            subjects = dataManager.scannedImages.map(\.subject).removingDuplicates()
        }
    }

    private func delete(at offsets: IndexSet) {
        // Handle deletion of subjects
        let subjectsToRemove = offsets.map { subjects[$0] }

        // Remove corresponding scannedImages
        dataManager.scannedImages.removeAll { scannedImage in
            subjectsToRemove.contains(scannedImage.subject)
        }

        // Update the subjects
        subjects.remove(atOffsets: offsets)

        // Save the changes to dataManager
        dataManager.saveScannedImages()
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var encountered = Set<Element>()
        return filter { encountered.insert($0).inserted }
    }
}
