import SwiftUI

struct TimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var remainingTime: TimeInterval = 0
    @State private var isViewLocked: Bool = false
    @State private var timer: Timer?
    @State private var disableTimer: Timer?
    @State private var showAlert = false
    
    @State var durationHours: Int
    @State var durationMinutes: Int
    @State var lockAfterDuration: Bool
    var stopAfterDuration: TimeInterval {
        TimeInterval(durationHours * 3600 + durationMinutes * 60)
    }
    
    var body: some View {
        if durationHours == 0 && durationMinutes == 0 {
            //show nothing
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accentColor)
                    .cornerRadius(22)
                
                Text("\(formattedTime(remainingTime))")
                    .padding(10)
                    .foregroundColor(.black)
            }
            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Timer Finished"),
                    message: Text("The timer has ended."),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    private func startTimer() {
        remainingTime = stopAfterDuration
        let timeInterval: TimeInterval = 1  // Set your desired update frequency here
        
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= timeInterval
            } else {
                showAlert = true
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
