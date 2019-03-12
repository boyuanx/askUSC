//
//  OfficeHourQueue.swift
//  askUSC
//
//  Created by Boyuan Xu on 1/4/19.
//  Copyright © 2019 Boyuan Xu. All rights reserved.
//

import Foundation

enum OfficeHourPurpose: String, Codable {
    case debug = "Debug"
    case general = "General"
    case concept = "Concept"
    case syntax = "Syntax"
    case other = "Other"
}

struct OfficeHourQueue: Codable {
    private(set) var OH_ID: String!
    private(set) var instructorName: String!
    private(set) var className: String!
    private(set) var start: Date!
    private(set) var end: Date!
    var currentlyCalling: Int!
    var currentUserInQueue = OfficeHourPlaceInQueue()
    var queuedMembers = [OfficeHourPlaceInQueue]()   // For future use
    
    init(OH_ID: String, instructorName: String, className: String, start: String, end: String, currentUserInQueue: OfficeHourPlaceInQueue, currentlyCalling: Int) {
        self.OH_ID = OH_ID
        self.instructorName = instructorName
        self.className = className
        self.start = start.iso8601
        self.end = end.iso8601
        self.currentlyCalling = currentlyCalling
        self.currentUserInQueue = currentUserInQueue
    }
    
    init() {
        self.OH_ID = "EJ201"
        self.instructorName = "Emily Jin"
        self.className = "CSCI-201"
        self.start = Date()
        self.end = Date()
        self.currentlyCalling = 0
    }
    
    func getPlaceInQueue(for userID: String) -> Int {
        if (queuedMembers.count == 0) {
            return 0
        }
        let sorted = queuedMembers.sorted()
        var count = 0
        for user in sorted {
            if user.userID != userID {
                count = count + 1
            } else {
                break
            }
        }
        return count
    }
}

struct OfficeHourPlaceInQueue: Codable, Equatable, Comparable {
    
    static func < (lhs: OfficeHourPlaceInQueue, rhs: OfficeHourPlaceInQueue) -> Bool {
        return lhs.TIMESTAMP < rhs.TIMESTAMP
    }
    
    static func == (lhs: OfficeHourPlaceInQueue, rhs: OfficeHourPlaceInQueue) -> Bool {
        return (lhs.userID == rhs.userID) && (lhs.OH_ID == rhs.OH_ID)
    }
    
    private(set) var OH_ID: String!
    private(set) var userID: String!
    private(set) var TIMESTAMP: Date!
    var placeInQueue: Int!
    var purpose: OfficeHourPurpose!
    
    init(OH_ID: String, userID: String, TIMESTAMP: String, placeInQueue: Int, purpose: OfficeHourPurpose) {
        self.OH_ID = OH_ID
        self.userID = userID
        self.TIMESTAMP = TIMESTAMP.iso8601
        self.placeInQueue = placeInQueue
        self.purpose = purpose
    }
    
    init() {
        self.OH_ID = "Test OH_ID"
        self.userID = "Test userID"
        self.TIMESTAMP = Date()
        self.placeInQueue = 0
        self.purpose = OfficeHourPurpose.other
    }
}
