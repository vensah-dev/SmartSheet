//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var streak: Int
    @State var DaysOfTheWeek: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    init() {
        _streak = State(initialValue: max(UserDefaults.standard.integer(forKey: "streak"), 0))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("\(streak)")
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing], 16)
                    .onAppear {
                        updateImage()
                    }
                
                HStack(spacing: 10) {
                    ForEach(DaysOfTheWeek, id: \.self) { x in
                        VStack {
                            Image(systemName: x == currentDay() ? "flame.fill" : "flame")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 24)
                                .foregroundColor(x == currentDay() ? .orange : .gray)
                            
                            Text(x)
                                .font(.system(size: 10, weight: .black))
                        }
                        .padding(11)
                    }
                }
                
            }
            .navigationTitle("Hey there!")
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .listStyle(GroupedListStyle())
            .scrollContentBackground(.hidden)
            .opacity(1)
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                updateImage()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    private func updateImage() {
        let lastOpenedDate = UserDefaults.standard.object(forKey: "lastOpenedDate") as? Date
        let currentDate = Date.now
        
        if let lastOpenedDate = lastOpenedDate, Calendar.current.isDate(currentDate, equalTo: lastOpenedDate, toGranularity: .day) {
            return
        }
        
        if let lastOpenedDate = lastOpenedDate, Calendar.current.isDate(currentDate.addingTimeInterval(-86400), equalTo: lastOpenedDate, toGranularity: .day) {
            streak += 1
        } else {
            streak = 1
        }
        
        if streak > 7 {
            streak = 1
        }
        
        UserDefaults.standard.set(streak, forKey: "streak")
        UserDefaults.standard.set(currentDate, forKey: "lastOpenedDate")
    }
    
    private func currentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: Date.now)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

