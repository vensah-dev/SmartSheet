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
                    let suggestion = suggestions.isEmpty || suggestions.count < 5 ? suggestions[0...] : suggestions[0..<5]
                    ForEach(suggestion, id: \.id) { scannedImage in
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
                                            .stroke(Color.accentColor.opacity(0.5), lineWidth: 0.5)
                                    )
                                
                                Text(scannedImage.title)
                                    .bold()
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                            }
                        }
                    }
                }
                
                Section(header: Text("Events").textCase(.uppercase)) {
                    let filteredEvents = dataManager.Events.filter { x in
                        let cal = Calendar.current
                        let startStartDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: x.startDate) ?? x.startDate
                        let endEndDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: x.endDate) ?? x.endDate

                        let dateRange = startStartDate...endEndDate

                        return dateRange.contains(selectedDate)
                    }

                    let groupedEvents = Dictionary(grouping: filteredEvents) { event in
                        Calendar.current.startOfDay(for: event.endDate)
                    }

                    let sortedGroups = groupedEvents.sorted { $0.key < $1.key }

                    ForEach(sortedGroups, id: \.key) { date, eventsInSameDay in
                        let sortedEvents = eventsInSameDay.sorted { $0.startDate < $1.startDate }

                        let formattedDates: [String] = sortedEvents.map { item in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            return dateFormatter.string(from: item.startDate)
                        }

                        ForEach(0..<sortedEvents.count, id: \.self) { index in
                            let item = sortedEvents[index]
                            let formattedDate = formattedDates[index]
                            
                            NavigationLink(destination: {
                                EventDetailView(dataManager: dataManager, event: item, Events: $dataManager.Events)
                            }, label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .bold()
                                            .foregroundStyle(Color.accentColor)

                                        Text("Due: \(item.endDate, format: .dateTime.month().day())")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }

                                    Spacer()

                                    Text("\(formattedDate)")
                                        .foregroundStyle(.secondary)
                                }
                                .padding([.top, .bottom],  5)
                            })
                        }
                    }
                }
            }
            .onAppear {
                loadInitialSuggestions()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
        }
    }
    private func loadInitialSuggestions() {
        self.suggestions = dataManager.scannedImages.sorted{$0.used < $1.used}
    }
}
