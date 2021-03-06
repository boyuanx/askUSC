//
//  Class.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/28/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftLocation
import CoreLocation
import SCLAlertView

struct Class: Equatable, Comparable, Codable {
    
    static func < (lhs: Class, rhs: Class) -> Bool {
        if (lhs.start != rhs.start) {
            return lhs.start < rhs.start
        } else {
            return lhs.end < rhs.end
        }
    }
    
    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.classID == rhs.classID
    }
    
    private(set) var classID: String!
    private(set) var className: String!
    private(set) var classDescription: String!
    private(set) var classInstructor: String!
    private(set) var start: Date!
    private(set) var end: Date!
    private(set) var meetingDaysOfWeek: [String]!
    private(set) var meetingDaysOfWeekNumber: [String]!
    private(set) var lon: Double!
    private(set) var lat: Double!
    var studentsUID: [String]!
    
    init() {
        self.classID = "0000"
        self.className = "N/A"
        self.classDescription = "Please register for a class."
        self.classInstructor = "N/A"
        self.start = Date()
        self.end = Date()
        self.meetingDaysOfWeek = [String]()
        self.lat = 0
        self.lon = 0
        self.studentsUID = [String]()
    }
    
    init(classID: String, className: String, classDescription: String, classInstructor: String, start: Date, end: Date, meetingDaysOfWeek: String, lat: Double, lon: Double, studentsUID: [String]) {
        self.classID = classID
        self.className = className
        self.classDescription = classDescription
        self.classInstructor = classInstructor
        self.start = start
        self.end = end
        self.meetingDaysOfWeekNumber = stringToArray(string: meetingDaysOfWeek)
        //self.meetingDaysOfWeek = NetworkingUtility.shared.parseMeetingDaysOfWeek(data: meetingDaysOfWeek)
        //self.isInSessionToday = NetworkingUtility.shared.isClassInSessionToday(meetingTimes: self.meetingDaysOfWeek)
        self.lat = lat
        self.lon = lon
        self.studentsUID = studentsUID
        //changeDateToNextMeetingDay()
    }
    
    private mutating func changeDateToNextMeetingDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        print(Date())
        print(String(stringInterpolationSegment: calendar.dateComponents([.weekday], from: start).weekday!))
        print("Start day: \(start.day)")
        print("Current day: \(Date().day)")
        if ((start.day == Date().day && start.hour < Date().hour && end.hour < Date().hour ) || start.day == Date().day - 1) {
            start = start + 1.days
            end = end + 1.days
            print(String(stringInterpolationSegment: calendar.dateComponents([.weekday], from: start).weekday!))
        }
        print("Start day: \(start.day)")
        var startEndDayOfWeek = String(stringInterpolationSegment: calendar.dateComponents([.weekday], from: start).weekday!)
        print("\(String(describing: meetingDaysOfWeekNumber)) + \(startEndDayOfWeek)")
        while (!meetingDaysOfWeekNumber.contains(startEndDayOfWeek)) {
            start = start + 1.days
            end = end + 1.days
            print("Start day: \(start.day)")
            startEndDayOfWeek = String(stringInterpolationSegment: calendar.dateComponents([.weekday], from: start).weekday!)
        }
    }
    
    private func stringToArray(string: String) -> [String] {
        var result = [String]()
        for char in string {
            result.append(String(char))
        }
        return result
    }
    
    func isCurrentlyInSession() -> Bool {
        let currentTime = Date()
        if (currentTime > start && currentTime < end) {
            return true
        } else {
            return false
        }
    }
    
    func isWithinVicinity(completion: @escaping (Bool) -> Void) {
        let classCLLocation = CLLocation(latitude: lat, longitude: lon)
        print("Class location: \(classCLLocation)")
        let dg = DispatchGroup()
        dg.enter()
        var isWithinVicinity = false
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        Locator.currentPosition(accuracy: .any, timeout: Timeout.after(5), onSuccess: { (location) -> (Void) in
            print("My location: \(location)")
            if (location.distance(from: classCLLocation) < 50) {
                isWithinVicinity = true
            }
            dg.leave()
        }) { (error, location) -> (Void) in
            let alert = SCLAlertView()
            alert.showError("Location Error", subTitle: "Failed to get location data.")
            dg.leave()
        }
        dg.notify(queue: .main) {
            completion(isWithinVicinity)
        }
    }
}
