import SwiftUI

struct FilesView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedSubjectIndex = -1
    @State private var isExpanded: [Bool] = [true]
    
    var body: some View {
        NavigationView {
            VStack() {
                if dataManager.scannedImages.isEmpty {
                    Text("No resources yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(dataManager.topics, id: \.self){ x in
                            Section(isExpanded: $isExpanded[getIndex(title: x)],
                                content: {
                                    ForEach(dataManager.scannedImages, id: \.id){ item in
                                        if selectedSubjectIndex == -1 || dataManager.scannedImages[selectedSubjectIndex].subject  == item.subject{
                                            if x  == item.topic{
                                                NavigationLink(
                                                    destination: ImageDetail(
                                                        title: item.title,
                                                        image: item.image,
                                                        dataManager: dataManager
                                                    )
                                                ) {
                                                    HStack {
                                                        Image(uiImage: item.image.first ?? UIImage())
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 60, height: 60)
                                                            .cornerRadius(5)
                                                        
                                                        VStack(alignment: .leading) {
                                                            Text(item.title)
                                                                .font(.headline)
                                                                .foregroundStyle(Color("orangeText"))
                                                            
                                                            if !item.caption.isEmpty {
                                                                Text(item.caption)
                                                                    .font(.caption)
                                                                    .foregroundStyle(Color("orangeText").opacity(0.7))
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                }, header: {
                                    Text(x)
                                }
                            )
                            .listRowBackground(Color("lightOrange"))

                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarTitle("Resources")
            .navigationBarItems(leading: EditButton(), trailing:
                                    HStack {
                                        Picker("Subject", selection: $selectedSubjectIndex) {
                                            Text("All").tag(-1)
                                            ForEach(dataManager.subjects.indices, id: \.self) { index in
                                                Text(dataManager.subjects[index])
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
            .onReceive(dataManager.$scannedImages) { _ in
                for x in dataManager.scannedImages{
                    if(!dataManager.topics.contains(x.topic)){
                        dataManager.topics.append(x.topic)
                    }
                }
                
                for _ in dataManager.topics{
                    isExpanded.append(false)
                }
                
                dataManager.topics = dataManager.scannedImages.map(\.topic).removingDuplicates()
            }
        }
    }
    
    func getIndex(title: String) -> Int {
        var i: Int = 0
        
        for x in dataManager.topics{
            if(x == title){
                break
            }
            
            i += 1
        }
        
        return i
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}

