import SwiftUI

struct FilesView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedSubjectIndex = 0
    @State private var isExpanded = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if dataManager.scannedImages.isEmpty {
                        Text("No resources yet")
                            .foregroundColor(.secondary)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(dataManager.scannedImages.indices, id: \.self) { index in
                            let images = dataManager.scannedImages[index].image
                            let subject = dataManager.scannedImages[index].subject
                            let topic = dataManager.scannedImages[index].topic
                            
                            if selectedSubjectIndex == -1 || subject == dataManager.scannedImages[selectedSubjectIndex].subject {
                                DisclosureGroup(topic, isExpanded: $isExpanded) {
                                    NavigationLink(
                                        destination: ImageDetail(
                                            image: images,
                                            title: $dataManager.scannedImages[index].title,
                                            caption: $dataManager.scannedImages[index].caption,
                                            durationHours: $dataManager.scannedImages[index].durationHours,
                                            durationMinutes: $dataManager.scannedImages[index].durationMinutes,
                                            lockAfterDuration: $dataManager.scannedImages[index].lockAfterDuration,
                                            subject: $dataManager.scannedImages[index].subject,
                                            topic: $dataManager.scannedImages[index].topic,
                                            dataManager: dataManager
                                        )
                                    ) {
                                        HStack {
                                            Image(uiImage: dataManager.scannedImages[index].image.first ?? UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(5)
                                            
                                            VStack(alignment: .leading) {
                                                Text(dataManager.scannedImages[index].title)
                                                    .font(.headline)
                                                
                                                if !dataManager.scannedImages[index].caption.isEmpty {
                                                    Text(dataManager.scannedImages[index].caption)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.accentColor)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Resources")
            .navigationBarItems(leading: EditButton(), trailing:
                                    HStack {
                                        Picker("Subject", selection: $selectedSubjectIndex) {
                                            Text("All").tag(-1)
                                            ForEach(0..<dataManager.scannedImages.count, id: \.self) { index in
                                                Text(dataManager.scannedImages[index].subject)
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
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}

