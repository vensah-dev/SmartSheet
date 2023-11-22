//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @State var event: Event
    @Binding var Events: [Event]
    @State var showEdit = false
    @State var index = 0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Date")){
                    DatePicker(
                        "Start Date",
                        selection: $event.startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                    
                    DatePicker(
                        "End Date",
                        selection: $event.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                }
                .listRowBackground(Color("lightOrange"))
                
                Section(header: Text("Description")){
                    TextField("", text: $event.details)
                }
                .listRowBackground(Color("lightOrange"))
            }
            .scrollContentBackground(.hidden)
            .opacity(0.8)
            .navigationTitle($event.title)
        }
        .onAppear{
            var i = 0
            
            for x in Events{
                if(x.title == event.title){
                    break
                }
                
                i += 1
            }
            
            index = i
        }
        .onDisappear{
            Events[index] = event
        }
    }
}


