//
//  AlarmController.swift
//  Alarm
//
//  Created by Trevor Bursach on 9/14/20.
//  Copyright © 2020 Trevor Bursach. All rights reserved.
//

import UIKit

protocol AlarmSchedulerDelegate: AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmSchedulerDelegate {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Get Ready!"
        content.subtitle = "Get Going!"
        content.body = alarm.name
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let notificationIdentifier = alarm.uuid
        let calendar = Calendar.current
        var dateCompontents = DateComponents()
        dateCompontents.hour = calendar.component(.hour, from: alarm.fireDate)
        dateCompontents.minute = calendar.component(.minute, from: alarm.fireDate)
        dateCompontents.second = 0
//        let dateComponents = calendar.dateComponents(in: .current, from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompontents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
             print(error ?? "There was an error")
                       print(error?.localizedDescription ?? "There was an error")
                       print("There was an error creating the scheduled notification.")
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        let identifier = alarm.uuid
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}

class AlarmController: AlarmSchedulerDelegate {
    
    static var shared: AlarmController = AlarmController()
    
    var alarms: [Alarm] = []
    
    // Mock alarm test
    init() {
        self.alarms = mockAlarm
    }
    
    weak var delegate: AlarmSchedulerDelegate?
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) -> Alarm {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        save()
        if enabled {
            scheduleUserNotifications(for: newAlarm)
        }
        return newAlarm
    }
        
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        save()
        if enabled {
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        }
    }
        
    func delete(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: index)
        save()
    }
    
    var mockAlarm: [Alarm] {
        let alarm1 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 5000), name: "School", enabled: true)
        let alarm2 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 500), name: "Workout", enabled: true)
        let alarm3 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 2000), name: "Class", enabled: true)
        let alarm4 = Alarm(fireDate: Date.init(timeIntervalSinceNow: 9000), name: "Sleep", enabled: true)
        
        return [alarm1, alarm2, alarm3, alarm4]
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            AlarmController.shared.scheduleUserNotifications(for: alarm)
        } else {
            AlarmController.shared.cancelUserNotifications(for: alarm)
        }
        save()
        
    }
    
    
    
    
    //MARK: - Persistence
    
    func createFileForPersistence() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls[0].appendingPathComponent("alarmApp.json")
        return fileUrl
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsondAlarms = try jsonEncoder.encode(alarms)
            try jsondAlarms.write(to: createFileForPersistence())
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func load() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: createFileForPersistence())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: jsonData)
            alarms = decodedAlarms
        }catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    
} // END OF CLASS

