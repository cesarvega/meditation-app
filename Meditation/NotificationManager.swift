import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationIdentifierPrefix = "daily_meditation_"
    private init() { }
    
    func requestAuthorization() {
        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("🔔 Notification authorization error: \(error.localizedDescription)")
                } else {
                    print("🔔 Notification authorization granted: \(granted)")
                }
            }
        }
    }
    
    func scheduleDailyMeditationNotifications(language: AppLanguage, debugSecondsFromNow: TimeInterval? = nil) {
        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
                print("🔔 Notifications not authorized; skipping schedule")
                return
            }

            self.notificationCenter.getPendingNotificationRequests { requests in
                let identifiersToRemove = requests
                    .map { $0.identifier }
                    .filter { $0.hasPrefix(self.notificationIdentifierPrefix) }
                if !identifiersToRemove.isEmpty {
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
                }

                let meditations = Meditation.allMeditations
                guard !meditations.isEmpty else {
                    print("🔔 No meditations available to schedule notifications")
                    return
                }

                let calendar = Calendar.current
                let iterations = debugSecondsFromNow == nil ? 7 : 1
                for dayOffset in 0..<iterations {
                    guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }
                    var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
                    components.hour = 8
                    components.minute = 0

                    guard let meditation = meditations.randomElement() else { continue }
                    let content = UNMutableNotificationContent()
                    content.sound = .default

                    switch language {
                    case .english:
                        content.title = "Today's Meditation"
                        content.body = meditation.titleEN
                    case .spanish:
                        content.title = "Meditación del día"
                        content.body = meditation.titleES
                    }
                    content.userInfo = ["meditation_id": meditation.uniqueId]

                    let trigger: UNNotificationTrigger
                    if let debugSecondsFromNow {
                        trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(debugSecondsFromNow, 1), repeats: false)
                    } else {
                        trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    }
                    let identifier = debugSecondsFromNow == nil ? "\(self.notificationIdentifierPrefix)\(dayOffset)" : "\(self.notificationIdentifierPrefix)debug"
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { error in
                        if let error = error {
                            print("🔔 Failed to schedule notification: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
