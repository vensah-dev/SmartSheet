//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State public var suggestions: [ScannedImage] = []
    @State var DisplayEvents: [Event] = [Event(title: "", details: "")]
    @State var selectedDate: Date = Date()
    @State private var streak: Int
    @ObservedObject var dataManager = DataManager()
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
        _streak = State(initialValue: max(UserDefaults.standard.integer(forKey: "streak"), 1))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    VStack{
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
                                    Image(systemName: isDayInStreak(day: x) ? "flame.fill" : "flame")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 24)
                                        .foregroundColor(isDayInStreak(day: x) ? .orange : .gray)
                                    
                                    Text(x)
                                        .font(.system(size: 10, weight: .black))
                                }
                                .padding(11)
                            }
                        }
                    }
                }
                .frame(width: 400)
                .listRowBackground(Color.red.opacity(0.0))
                Section(header: Text("Suggestions").textCase(.uppercase)){
                    ForEach(suggestions, id: \.id){ scannedImage in
                        NavigationLink(destination: ImageDetail(
                            title: scannedImage.title,
                            image: scannedImage.image,
                            dataManager: dataManager
                        )) {
                            HStack{
                                Image(uiImage: scannedImage.image.first ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.accentColor, lineWidth: 2)
                                    )
                                
                                Text(scannedImage.title)
                                    .bold()
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                                
                                Text("More")
                            }
                        }
                    }
                }
                
                Section(header: Text("Events").textCase(.uppercase)){
                    
                    let formattedDates: [String] = dataManager.Events.map { item in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        return dateFormatter.string(from: item.startDate)
                    }
                    
                    ForEach(dataManager.Events.filter { x in
                        let cal = Calendar.current
                        let endEndDate = cal.date(bySettingHour: 23, minute: 59, second: 59, of: x.endDate) ?? x.endDate
                        
                        let DateRange = Date.now...Date().addingTimeInterval(TimeInterval(86400*3))
                        
                        if(DateRange.contains(endEndDate)){
                            return true
                        }
                        else{
                            return false
                        }
                        
                    }, id: \.id){ item in
                        let formattedDate = formattedDates[dataManager.Events.firstIndex(of: item)!]
                        NavigationLink(destination:{
                            EventDetailView( event: item, Events: $dataManager.Events)
                        }, label:{
                            HStack{
                                Text(item.title)
                                    .bold()
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                                
                                Text("\(formattedDate)")
                                    .foregroundStyle(.secondary)
                            }
                            .padding([.top, .bottom],  5)
                        })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home")
        }
        .navigationTitle("Home")
        .onAppear {
            refreshSuggestions()
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                updateImage()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    private func refreshSuggestions() {
        DispatchQueue.main.async {
            self.suggestions = self.dataManager.scannedImages.filter { $0.used < 5 }
        }
    }
    
    private func isDayInStreak(day: String) -> Bool {
        let currentDay = currentDay()
        let currentDayIndex = DaysOfTheWeek.firstIndex(of: currentDay) ?? 0
        let dayIndex = DaysOfTheWeek.firstIndex(of: day) ?? 0

        let daysSinceLastLogin = (currentDayIndex - dayIndex + 7) % 7

        return daysSinceLastLogin < min(streak, 7)  // Ensure streak is capped at 7
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
