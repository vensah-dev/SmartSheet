//
//  AppDelegate.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 26/11/2023.
//


import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAuthForLocalNotifications()
        return true
    }
    
    func requestAuthForLocalNotifications(){
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notification")
            }
        }
    }
    
    func scheduleLocalNotification(date: Date, title: String, caption: String, repeatNotification: Bool = false){
      //checking the notification setting whether it's authorized or not to send a request.
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
              //1. create contents
                let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = caption
                    content.sound = UNNotificationSound.default
                //2. create trigger [calendar, timeinterval, location, pushnoti]
                let dateInfo = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: repeatNotification)
                //3. make a request
                let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                    if error != nil{
                        print("error in notification! ")
                    }
                }
           }
           else {
              print("user denied")
           }
       }
    }
}
