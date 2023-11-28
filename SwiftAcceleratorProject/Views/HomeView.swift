//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State public var suggestions: [ScannedImage] = []
    @State var DisplayEvents: [Event] = [Event(title: "", details: "")]
    @State var selectedDate: Date = Date()
    @State private var streak: Int
    @ObservedObject var dataManager: DataManager
    @State var DaysOfTheWeek: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    init(dataManager: DataManager) {
        _streak = State(initialValue: max(UserDefaults.standard.integer(forKey: "streak"), 1))
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    StreaksView(streak: $streak)
                }
                .listRowBackground(Color.red.opacity(0.0))
                
                Section(header: Text("Suggestions").textCase(.uppercase)) {
                    ForEach(suggestions, id: \.id) { scannedImage in
                        NavigationLink(destination: ImageDetail(
                            title: scannedImage.title,
                            image: scannedImage.image,
                            dataManager: dataManager
                        )) {
                            HStack {
                                Image(uiImage: scannedImage.image.first ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.accentColor, lineWidth: 2)
                                    )
                                
                                Text(scannedImage.title)
                                    .bold()
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                                
                                Text("More")
                            }
                        }
                    }
                }
                
                Section(header: Text("Events").textCase(.uppercase)) {
                    let formattedDates: [String] = dataManager.Events.map { item in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        return dateFormatter.string(from: item.startDate)
                    }
                    
                    ForEach(dataManager.Events.filter { x in
                        let cal = Calendar.current
                        let endEndDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: x.endDate) ?? x.endDate
                        
                        let DateRange = Date.now...Date().addingTimeInterval(TimeInterval(86400*3))
                        
                        if DateRange.contains(endEndDate) {
                            return true
                        } else {
                            return false
                        }
                        
                    }, id: \.id) { item in
                        let formattedDate = formattedDates[dataManager.Events.firstIndex(of: item)!]
                        NavigationLink(destination:{
                            EventDetailView(dataManager: dataManager, event: item, Events: $dataManager.Events)
                        }, label:{
                            HStack{
                                Text(item.title)
                                    .bold()
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                                
                                Text("\(formattedDate)")
                                    .foregroundStyle(.secondary)
                            }
                            .padding([.top, .bottom],  5)
                        })
                    }
                }
            }
            .refreshable {
                refreshSuggestions()
            }
            .onAppear {
                loadInitialSuggestions()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
        }
    }
    private func loadInitialSuggestions() {
        self.suggestions = generateRandomSubset(dataManager.scannedImages, count: 5)
    }

    private func refreshSuggestions() {
        DispatchQueue.main.async {
            self.suggestions = generateRandomSubset(dataManager.scannedImages, count: 5)
        }
    }

    private func generateRandomSubset<T>(_ array: [T], count: Int) -> [T] {
        let shuffledArray = array.shuffled()
        return Array(shuffledArray.prefix(count))
    }
}
