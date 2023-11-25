//
//  TimerView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 25/11/2023.
//

import SwiftUI

struct TimerView: View {
    @State var TimerName = "Timer 1"
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: .infinity, height: 50)
                .background()
                .cornerRadius(22)
                .padding(.init(top: 0, leading: 25, bottom: 0, trailing: 25))
            
            HStack{
                Text(TimerName)
                    .foregroundStyle(.white)
                    .padding(30)
                
                Spacer()
                
                Text(TimerName)
                    .foregroundStyle(.white)
                    .padding(30)
            }
            .padding(.init(top: 0, leading: 25, bottom: 0, trailing: 25))
        }
    }
}

#Preview {
    TimerView()
}
