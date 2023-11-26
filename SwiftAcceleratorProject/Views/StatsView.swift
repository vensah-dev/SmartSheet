//
//  StatsView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct StatsView: View {      
    @State public var suggestions: [ScannedImage] = []
    @StateObject private var dataManager = DataManager()
    @State var DaysOfTheWeek: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    var body: some View {
        Text("hello")
    }
}

#Preview {
    StatsView()
}

