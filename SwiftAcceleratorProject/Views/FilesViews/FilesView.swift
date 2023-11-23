import SwiftUI
import VisionKit

struct FilesView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedSubjectIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if !dataManager.scannedImages.isEmpty {
                    List {
                        ForEach(dataManager.scannedImages.indices, id: \.self) { index in
                            // Filter the images based on the selected subject
                            let images = dataManager.scannedImages[index].image
                            let subject = dataManager.scannedImages[index].subject
                            if selectedSubjectIndex == -1 || subject == dataManager.scannedImages[selectedSubjectIndex].subject {
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
                                            if !dataManager.scannedImages[index].caption.isEmpty {
                                                Text(dataManager.scannedImages[index].caption)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Picker("Subject", selection: $selectedSubjectIndex) {
                                if dataManager.scannedImages.isEmpty {
                                    // If no subjects, don't display any options
                                } else {
                                    Text("All").tag(-1)
                                    ForEach(0..<dataManager.scannedImages.count, id: \.self) { index in
                                        Text(dataManager.scannedImages[index].subject)
                                            .tag(index)
                                    }
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            NavigationLink(
                                destination: WorksheetDetailView(scannedImages: $dataManager.scannedImages, dataManager: dataManager),
                                label: {
                                    Image(systemName: "plus.circle")
                                }
                            )
                        }
                    }
                } else {
                    Text("No resources yet")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .navigationTitle("Resources")
        }
    }
    
    var selectedSubjectLabel: String {
        if selectedSubjectIndex == -1 {
            return "All"
        } else {
            return dataManager.scannedImages[selectedSubjectIndex].subject
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}

