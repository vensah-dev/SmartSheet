//
//  CalendarView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct CalendarView: View {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
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
                    
                    let formattedDates: [String] = dataManager.Events.map { item in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        return dateFormatter.string(from: item.startDate)
                    }
                    
                    ForEach(dataManager.Events.filter { x in
                        let cal = Calendar.current
                        let startStartDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: x.startDate) ?? x.startDate
                        let endEndDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: x.endDate) ?? x.endDate
                        
                        let DateRange = startStartDate...endEndDate
                        
                        if(DateRange.contains(selectedDate)){
                            return true
                        }
                        else{
                            return false
                        }
                        
                    }, id: \.id){ item in
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
                    .onDelete(perform: { indices in
                        delete(at: indices)
                    })
                }
                
            }
            .listStyle(.sidebar)
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
            for x in dataManager.Events{
                if(!x.sentNotification){
                    appDelegate.scheduleLocalNotification(date: x.startDate, title: "Smart Sheet", caption: "\(x.title) is starting soon!")
                }
            }
        }
    }
    func delete(at offsets: IndexSet) {
        dataManager.Events.remove(atOffsets: offsets)
        dataManager.saveEvents()
    }
}
