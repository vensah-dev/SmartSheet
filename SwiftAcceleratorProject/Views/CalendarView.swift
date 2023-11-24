//
//  CalendarView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct CalendarView: View {
    @State public var Events: [Event] = [
        Event(title: "Hello0", details: "Get Things done"),
        Event(title: "Hello2", details: "Finish calendar view"),
        Event(title: "Hello3", details: "Finsih The StatsView"),
        Event(title: "Hello4", details: "bye"),
    ]
    @State var DisplayEvents: [Event] = [Event(title: "", details: "")]
    @State var selectedDate: Date = Date()
    @State private var CreateNew = false

    var body: some View {
        NavigationStack{
            VStack() {
                Divider()
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                Divider()
            }
            .navigationBarItems(trailing:
                Button{
                    CreateNew = true
                }label:{
                    Image(systemName: "plus.circle")
                })
            .navigationTitle("Calendar")
            .onChange(of: selectedDate){
                DisplayEvents = Events.filter { Calendar.current.dateComponents([.day, .month, .year], from: $0.endDate) == Calendar.current.dateComponents([.day, .month, .year], from: selectedDate) }
            }
            
            List{
                Section(header: Text("Events").textCase(nil)){
                    
                    ForEach(DisplayEvents, id: \.id){ itm in
                        NavigationLink(destination:{
                            EventDetailView( event: itm, Events: $Events)
                        }, label:{
                            HStack{
                                VStack(alignment: .leading){
                                    Text(itm.title)
                                
                                    Text(itm.details)
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Text("Due: \(itm.endDate, style: .time)")
                            }
                        })
                        .listRowBackground(Color("lightOrange"))
                    }
                    .onDelete{Events.remove(atOffsets: $0)}
                }

            }
            .scrollContentBackground(.hidden)
            .toolbar(){
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $CreateNew){
                CreateNewEventView(Events: $Events, Edit: false)
            }
        }
        .onAppear{
            DisplayEvents = Events.filter { Calendar.current.dateComponents([.day, .month, .year], from: $0.endDate) == Calendar.current.dateComponents([.day, .month, .year], from: selectedDate) }
        }
    }
}

#Preview {
    CalendarView()
}
