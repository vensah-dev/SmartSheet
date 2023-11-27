import SwiftUI

struct TimerView: View {
    @State private var timerName = "Timer 1"
    
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
        if durationMinutes != 0 {
            ZStack {
                Rectangle()
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(22)
                    .overlay (
                        HStack {
                            Text(timerName)
                                .foregroundColor(.white)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                            Text("\(formattedTime(remainingTime))")
                                .foregroundStyle(.white)
                                .padding(.trailing, 15)
                        }
                    )
            }
            .padding(.init(top: 0, leading: 25, bottom: 0, trailing: 25))
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
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
