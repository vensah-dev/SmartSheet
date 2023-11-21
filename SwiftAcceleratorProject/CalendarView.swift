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
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(Events, id: \.id){ i in
                    NavigationLink(destination:{
                        Text(i.title)
                        Text(i.details)
                    }, label:{
                        Text(i.title)
                    })
                }
                .onDelete(perform: delete)
            }
            .toolbar{
                EditButton()
            }
            .navigationTitle("Calendar")
            .navigationBarItems(trailing: NavigationLink(
                destination: CreateNewEventView(Events: $Events),
                label: {
                    Image(systemName: "plus.circle")
                }
            ))
        }
    }
    func delete(at offsets: IndexSet) {
        Events.remove(atOffsets: offsets)
    }
}

#Preview {
    CalendarView()
}
