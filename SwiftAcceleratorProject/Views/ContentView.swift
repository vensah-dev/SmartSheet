//
//  ContentView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI


struct ContentView: View {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @ObservedObject var dataManager = DataManager()
    var body: some View {
        TabView{
            HomeView(dataManager: dataManager)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            FilesView(dataManager: dataManager)
                .tabItem{
                    Label("Files", systemImage: "doc.fill")
                }
            
            CalendarView(dataManager: dataManager)
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }
        }
        .onAppear{
            appDelegate.requestAuthForLocalNotifications()
        }
    }
}

#Preview {
    ContentView()
}
