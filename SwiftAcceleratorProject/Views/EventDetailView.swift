//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @State var Event:Event
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Date")){
                    DatePicker(
                        "Start Date",
                        selection: $Event.startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                    
                    DatePicker(
                        "End Date",
                        selection: $Event.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                }
                .listRowBackground(Color("lightOrange"))
                
                Section(header: Text("Description")){
                    Text(Event.details)
                }
            }
            .scrollContentBackground(.hidden)
            .opacity(0.8)
            .navigationTitle(Event.title)
        }
    }
}

