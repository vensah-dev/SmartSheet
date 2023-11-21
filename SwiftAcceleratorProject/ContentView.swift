//
//  ContentView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            FilesView()
                .tabItem{
                    Label("Files", systemImage: "doc.fill")
                }
            
            CalendarView()
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }
            
            StatsView()
                .tabItem{
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
