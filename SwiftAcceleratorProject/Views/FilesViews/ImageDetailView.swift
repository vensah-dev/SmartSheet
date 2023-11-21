//
//  ImageView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 21/11/23.
//

import SwiftUI

struct ImageDetail: View {
    @State var image: [UIImage]
    @Binding var title: String
    @Binding var caption: String
    @Binding var durationHours: Int?
    @Binding var durationMinutes: Int?
    @Binding var lockAfterDuration: Bool?
    
    var body: some View {
        VStack {
            TextField("Enter title", text: $title)
                .font(.title)
                .padding()
            
            ForEach(image, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .navigationBarTitle("", displayMode: .inline)
            }
            
            if let hours = durationHours, let minutes = durationMinutes, hours > 0 || minutes > 0 {
                Text("\(hours) hr \(minutes) min")
            }
        }
    }
}
