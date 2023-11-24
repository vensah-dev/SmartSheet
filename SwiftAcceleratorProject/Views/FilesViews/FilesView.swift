import SwiftUI

struct FilesView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedSubjectIndex = 0
    @State private var uniqueTopics: [String] = []
    @State private var sectionStates: [Bool] = []
    
    var uniqueSubjects: [String] {
        Array(Set(dataManager.scannedImages.map { $0.subject }))
    }
    
    var body: some View {
        NavigationView {
            List {
                if dataManager.scannedImages.isEmpty {
                    Text("No resources yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(uniqueTopics.indices, id: \.self) { index in
                        let topic = uniqueTopics[index]
                        Section(isExpanded: $sectionStates[index],
                                content: {
                            if sectionStates[index] {
                                ForEach(dataManager.scannedImages.indices, id: \.self) { imageIndex in
                                    let images = dataManager.scannedImages[imageIndex].image
                                    let subject = dataManager.scannedImages[imageIndex].subject
                                    let currentTopic = dataManager.scannedImages[imageIndex].topic
                                    if selectedSubjectIndex == -1 || subject == dataManager.scannedImages[selectedSubjectIndex].subject, currentTopic == topic {
                                        NavigationLink(
                                            destination: ImageDetail(
                                                image: images,
                                                title: $dataManager.scannedImages[imageIndex].title,
                                                caption: $dataManager.scannedImages[imageIndex].caption,
                                                durationHours: $dataManager.scannedImages[imageIndex].durationHours,
                                                durationMinutes: $dataManager.scannedImages[imageIndex].durationMinutes,
                                                lockAfterDuration: $dataManager.scannedImages[imageIndex].lockAfterDuration,
                                                subject: $dataManager.scannedImages[imageIndex].subject,
                                                topic: $dataManager.scannedImages[imageIndex].topic,
                                                dataManager: dataManager
                                            )
                                        ) {
                                            HStack {
                                                Image(uiImage: dataManager.scannedImages[imageIndex].image.first ?? UIImage())
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(5)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(dataManager.scannedImages[imageIndex].title)
                                                        .font(.headline)
                                                    
                                                    if !dataManager.scannedImages[imageIndex].caption.isEmpty {
                                                        Text(dataManager.scannedImages[imageIndex].caption)
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: { indices in
                                    delete(at: indices)
                                })
                            }
                        }, 
                                header:{ Text(topic)}
                        )
                        .textCase(nil)
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationBarTitle("Resources")
            .navigationBarItems(leading: EditButton(), trailing:
                                    HStack {
                Picker("Subject", selection: $selectedSubjectIndex) {
                    Text("All").tag(-1)
                    ForEach(uniqueSubjects.indices, id: \.self) { index in
                        Text(uniqueSubjects[index])
                            .tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                
                NavigationLink(
                    destination: WorksheetDetailView(scannedImages: $dataManager.scannedImages, dataManager: dataManager),
                    label: {
                        Image(systemName: "plus.circle")
                    }
                )
            }
            )
            .onAppear {
                uniqueTopics = Array(Set(dataManager.scannedImages.map { $0.topic }))
                sectionStates = Array(repeating: true, count: uniqueTopics.count)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}
