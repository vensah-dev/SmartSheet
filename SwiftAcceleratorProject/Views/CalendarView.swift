//
//  CalendarView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct CalendarView: View {
    @State public var Events: [Event] = [
        Event(title: "Hello0", details: "bye"),
        Event(title: "Hello2", details: "bye"),
        Event(title: "Hello3", details: "bye"),
        Event(title: "Hello4", details: "bye"),
    ]
    
    @State private var CreateNew = false

    var body: some View {
        NavigationStack{
            List{
                ForEach(Events, id: \.id){ i in
                    NavigationLink(destination:{
                        EventDetailView(Event: i)
                    }, label:{
                        Text(i.title)
                    })
                    .listRowBackground(Color("lightOrange"))
                }
                .onDelete(perform: delete)
            }
            .scrollContentBackground(.hidden)
            .opacity(0.8)
            .navigationTitle("Create New Event")
            .toolbar{
                EditButton()
            }
            .navigationTitle("Calendar")
            .navigationBarItems(trailing:
                Button{
                    CreateNew = true
                }label:{
                    Image(systemName: "plus.circle")
                })
            .sheet(isPresented: $CreateNew){
                CreateNewEventView(Events: $Events)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        Events.remove(atOffsets: offsets)
    }
}

#Preview {
    CalendarView()
}
