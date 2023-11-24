import SwiftUI

struct FilesView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedSubjectIndex = 0
    @State private var isExpanded = true
    
    var body: some View {
        NavigationView {
            if dataManager.scannedImages.isEmpty {
                Text("No resources yet")
                    .foregroundColor(.secondary)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List{
                    ForEach(dataManager.topics, id: \.self){ x in
                        DisclosureGroup(x) {
                            ForEach(dataManager.scannedImages, id: \.id) { item in
                                NavigationLink{
                                    ImageDetail(
                                        title: item.title,
                                        image: item.image,
                                        dataManager: dataManager
                                    )
                                }label:{
                                    HStack {
                                        Image(uiImage: item.image.first ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(5)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.title)
                                                .font(.headline)
                                            
                                            if !item.caption.isEmpty {
                                                Text(item.caption)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
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
                })
                .navigationBarTitle("Resources")
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}

