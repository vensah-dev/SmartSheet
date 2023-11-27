import SwiftUI

struct TimerView: View {
    @State private var disableTimer: Timer?
    @State private var disableTimerDuration: TimeInterval = 300
    @State private var timerName = "Timer"
    
    @Environment(\.presentationMode) var presentationMode
    @State private var remainingTime: TimeInterval = 0
    @Binding var isViewLocked: Bool
    @State private var timer: Timer?
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

            disableTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    disableTimer?.invalidate()
                    disableTimer = nil
                    showAlert = true
                    isViewLocked = false // Unlock the view when disableTimer is finished
                }
            }

            // Start a timer to stop disableTimer after 5 minutes
            Timer.scheduledTimer(withTimeInterval: disableTimerDuration, repeats: false) { _ in
                DispatchQueue.main.async {
                    disableTimer?.invalidate()
                    disableTimer = nil
                }
            }

            isViewLocked = true // Lock the view when disableTimer is started
        }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
