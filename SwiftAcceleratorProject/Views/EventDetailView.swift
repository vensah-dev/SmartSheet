//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @State var Event: Event
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
                    TextField("", text: $Event.details)
                }
                .listRowBackground(Color("lightOrange"))
            }
            .scrollContentBackground(.hidden)
            .opacity(0.8)
            .navigationTitle($Event.title)
            .toolbar{
                Button{
                    var i = 0
                    for x in Events{
                        if(x.title == Event.title){
                            break
                        }
                        i += 1
                    }
                    
                    
                    showEdit = true
                    
                }label: {
                    Text("Edit")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .sheet(isPresented: $showEdit, onDismiss:{
                dismiss()
            }, content: {
                EditEventView(event: $Events[index], title: Event.title, description: Event.title.description, EventStartDate: Event.startDate, EventEndDate: Event.endDate)
            })
        }
    }
}

