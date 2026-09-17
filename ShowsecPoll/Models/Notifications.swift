//
//  Notifications.swift
//  ShowsecPoll
//
//  Created by Kobby Awadzi on 17/09/2026.
//


//
//  Notifications.swift
//  Storm
//
//  Created by Kobby Awadzi on 31/05/2025.
//

import SwiftUI
import CoreLocation

public func requestNotificationPermission() async -> Bool {
    var result: Bool = false

    let center = UNUserNotificationCenter.current()
    
    do {
        try await result = center.requestAuthorization(options: [.alert, .badge, .sound])
        return result
        
    } catch {
        print("Failed to request notification permission: \(error)")
        return false
    }
}


public func scheduleNotification(title: String, body: String, identifier: String, delay: Double = 0, date: Date? = nil) async -> Bool {
    
    var notificationScheduled: Bool = true
    var dateComponents: DateComponents!
    let calendar = Calendar(identifier: .gregorian)
    dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
    
    let permissionGranted = await requestNotificationPermission()
    guard permissionGranted else {
        print("Notification permission not granted.")
        return false
    }
    
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    
    let trigger =  date != nil ? UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) : UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
    
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
    
    do {
        try await center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    } catch {
        notificationScheduled = false
    }
    
    return notificationScheduled
}



public func scheduleLocationNotification(title: String, body: String, identifier: String, delay: Double = 0, location: CLLocationCoordinate2D) async -> Bool {
    
    var notificationScheduled: Bool = true
    
    let permissionGranted = await requestNotificationPermission()
    guard permissionGranted else {
        print("Notification permission not granted.")
        return false
    }
    

    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound(named:  UNNotificationSoundName(rawValue: "NotificationReflection.m4a"))
    
    let region = CLCircularRegion(center: location, radius: 150, identifier: identifier)
    region.notifyOnEntry = true
    region.notifyOnExit = true
     
    let trigger =   UNLocationNotificationTrigger(region: region, repeats: false)
    
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
    
    do {
        try await center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    } catch {
        notificationScheduled = false
    }
    
    return notificationScheduled
}





public func deleteNotifications(identifiers: [String])  {
    let center = UNUserNotificationCenter.current()

        for identifier in identifiers {
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
            center.removeDeliveredNotifications(withIdentifiers: [identifier])
            print("deleted notification for \(identifier)")
    }
    
}
