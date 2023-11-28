import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAuthForLocalNotifications()
        return true
    }

    func requestAuthForLocalNotifications() {
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notification")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification when app is in the foreground
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification response here
        // You can navigate to a specific screen or perform other actions
        completionHandler()
    }

    func scheduleLocalNotification(date: Date, title: String, caption: String, repeatNotification: Bool = false) {
        print("Scheduling notification: \(title)")

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = caption
                content.sound = UNNotificationSound.default

                let dateInfo = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: repeatNotification)

                let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)

                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully!")
                    }
                }
            } else {
                print("User denied notification permission")
            }
        }
    }
}

