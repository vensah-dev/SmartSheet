//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State var Streak = 4
    @State var NextStreak = 10
    @State var BestStreak = 7
    @State var StreakCompletion = 40.0
    @State var OrangeText: Color = Color(UIColor(red: 255/255, green: 161/255, blue: 20/255, alpha: 0.8))
    
    @State var lightOrangeText: Color = Color(UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1))
    
    var body: some View {
        NavigationStack{
            List{
                //Streaks Widget
                Section{
                    ZStack {
                        Image("StreaksHome")
                            .scaledToFit()
                            .padding(10)
                            .opacity(0.8)
                        
                        VStack{
                            HStack{
                                Text("""
                                     Current
                                     Streak
                                     """)
                                .foregroundStyle(lightOrangeText)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                                
                                Text(String(Streak))
                                    .foregroundStyle(OrangeText)
                                    .font(.system(size: 64, weight: .semibold, design: .rounded))
                                    .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 0))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 170.4, alignment: .leading)
                            .padding(.init(top: 360, leading: 0, bottom: 0, trailing: 0))
                            
                            
                            VStack{
                                
                                ProgressView("", value: StreakCompletion, total: 100)
                                    .tint(lightOrangeText)
                                    .frame(width: 202)
                                
                                Text("\(NextStreak - Streak) days to go")
                                    .opacity(0.47)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .padding(.init(top: 0, leading: 120, bottom: 0, trailing: 0))
                                
                            }
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 133))
                        }
                        .padding(.init(top: 0, leading: 15, bottom: 360, trailing: 0))
                        
                        VStack{
                            Text("BestStreak")
                                .foregroundStyle(OrangeText)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 3))
                            
                            Text(String(BestStreak))
                                .foregroundStyle(OrangeText)
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                                .padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                            
                        }
                        .padding(.init(top: 0, leading: 224, bottom: 0, trailing: 0))
                        
                    }
                    .padding(.init(top: -300, leading: 0, bottom: -300, trailing: 0))
                }
                .listRowBackground(Color.red.opacity(0.0))
                
                Section(header: Text("Description")
                    .font(.system(size: 17 ,weight: .bold, design: .rounded))
                    .textCase(nil)){
                        
                    Text("ihwnd")
                }
                .listRowBackground(Color("lightOrange"))
            }
            .navigationBarTitle("Welcome, Back!")
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            
            
            
        }
        .navigationTitle("Welcome Back!")
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
        .listStyle(GroupedListStyle())
        .scrollContentBackground(.hidden)
        .opacity(1)
    }
    
}

#Preview {
    HomeView()
}
