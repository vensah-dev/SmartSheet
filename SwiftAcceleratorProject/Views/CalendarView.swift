//
//  CalendarView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var dataManager: DataManager
    @State var DisplayEvents: [Event] = [Event(title: "", details: "")]
    @State var selectedDate: Date = Date()
    @State private var CreateNew = false
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    VStack() {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .padding(.horizontal)
                            .datePickerStyle(.graphical)
                    }
                    .navigationBarItems(trailing:
                                            Button{
                        CreateNew = true
                    }label:{
                        Image(systemName: "plus.circle")
                    })
                    .navigationTitle("Calendar")
                }
                
                Section(header: Text("Events").textCase(.uppercase)){

                    let filteredEvents = dataManager.Events.filter { x in
                        let cal = Calendar.current
                        let startStartDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: x.startDate) ?? x.startDate
                        let endEndDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: x.endDate) ?? x.endDate

                        let dateRange = startStartDate...endEndDate

                        return dateRange.contains(selectedDate)
                    }

                    let sortedEvents = filteredEvents.sorted { $0.startDate < $1.startDate }

                    let formattedDates: [String] = sortedEvents.map { item in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        return dateFormatter.string(from: item.startDate)
                    }

                    ForEach(0..<sortedEvents.count, id: \.self) { index in
                        let item = sortedEvents[index]
                        let formattedDate = formattedDates[index]

                        NavigationLink(destination:{
                            EventDetailView(dataManager: dataManager, event: item, Events: $dataManager.Events)
                        }, label:{
                            HStack{
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
                    .onDelete(perform: { indices in
                        var index: Int = 0
                        for i in indices{
                            index = i
                        }
                        delete(at: indices, index: index)
                    })
                }
            }
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $CreateNew){
                CreateNewEventView(dataManager: dataManager, Events: $dataManager.Events, Edit: false)
            }
        }
        .onDisappear{
            dataManager.saveEvents()
        }
    }
    func delete(at offsets: IndexSet, index: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [dataManager.Events[index].title])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [dataManager.Events[index].title])
        
        dataManager.Events.remove(atOffsets: offsets)
        dataManager.saveEvents()
    }
}
