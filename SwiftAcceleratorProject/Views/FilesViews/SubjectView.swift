import SwiftUI

struct SubjectView: View {
    @ObservedObject var dataManager: DataManager
    @State private var isAddSubjectModalPresented = false
    @Binding var selectedSubject: String
    @State private var newSubject = ""
    @State var edit: Bool
    var onSubjectSelected: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        var subjects = dataManager.subjects // Consider using dataManager.scannedImages.map(\.subject).removingDuplicates() directly

        List {
            ForEach(subjects, id: \.self) { subject in
                Button(action: {
                    selectedSubject = subject
                    onSubjectSelected(selectedSubject)
                    dismiss()
                    
                }) {
                    Text(subject)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Subjects")
        .toolbar(){
            ToolbarItem(placement: .navigationBarTrailing) {
                if !edit{
                    Button{
                        isAddSubjectModalPresented = true
                    }label:{
                        Image(systemName: "plus.circle")
                    }
                    .alert("Add Subject", isPresented: $isAddSubjectModalPresented) {
                        TextField("New Subject", text: $newSubject)
                        Button("Add") {
                            if !newSubject.isEmpty {
                                if subjects.contains(newSubject) {
                                    isAddSubjectModalPresented = false
                                } else {
                                    // Add the new subject to dataManager.subjects
                                    dataManager.subjects.append(newSubject)
                                    onSubjectSelected(newSubject)
                                    newSubject = ""
                                    isAddSubjectModalPresented = false
                                    presentationMode.wrappedValue.dismiss()
                                }
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
                }
            }
            
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
        let subjectsToRemove = offsets.map { dataManager.subjects[$0] }

        // Remove corresponding scannedImages
        dataManager.scannedImages.removeAll { scannedImage in
            subjectsToRemove.contains(scannedImage.subject)
        }

        // Update the subjects
        dataManager.subjects.remove(atOffsets: offsets)

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
