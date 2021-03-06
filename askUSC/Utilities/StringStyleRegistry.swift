//
//  StringStyleRegistry.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/17/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import SwiftRichString

class StringStyleRegistry {
    
    static let shared = StringStyleRegistry()
    private init() {
        
    }
    
    var isRun = false
    var styleArray = [Style]()
    
    func register() {
        if (isRun) {
            print("StringStyleRegistry.register has already been called!")
            return
        }
        let styles = styleStruct()
        let mirror = Mirror(reflecting: styles)
        for style in mirror.children {
            Styles.register(style.label!, style: style.value as! StyleProtocol)
        }
        isRun = true
    }
    
}

fileprivate struct styleStruct {
    let guestLoginStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 15)
        $0.color = UIColor.init(rgb: 0xFFCC00)
    }
    let welcomeStyle = Style {
        $0.font = UIFont(name: "OpenSans-Light", size: 27)
        $0.color = UIColor(rgb: 0xFFCC00)
    }
    let nameStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 25)
        $0.color = UIColor.white
    }
    let menuItemStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = UIColor.black
    }
    let menuItemDisabledStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = UIColor.gray
    }
    let menuItemDestructiveStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = SharedInfo.USC_redColor
    }
    let logOutStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = SharedInfo.USC_redColor
    }
    let profileNameStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 27)
        $0.color = UIColor.black
    }
    let profileQuoteStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 20)
        $0.color = UIColor.black
        $0.lineBreakMode = .byTruncatingTail
        $0.alignment = .center
    }
    let profileAuthorStyle = Style {
        $0.font = UIFont(name: "OpenSans-Italic", size: 17)
        $0.color = UIColor.black
        $0.alignment = .right
    }
    let profileUpvoteStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 15)
        $0.color = SharedInfo.USC_redColor
    }
    let profileUpvoteButtonStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = UIColor.white
    }
    let profileClassNameStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = UIColor.black
        $0.alignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
    let registrationTextFieldStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = UIColor.gray
    }
    let enterClassNameStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 19)
        $0.color = UIColor.black
    }
    let enterClassDescriptionStyle = Style {
        $0.font = UIFont(name: "OpenSans-Italic", size: 15)
        $0.color = UIColor.gray
    }
    let enterClassInstructorStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 19)
        $0.color = UIColor.black
    }
    let classroomChatBodyStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 15)
        $0.color = UIColor.black
    }
    let classroomChatSenderStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 12)
        $0.color = UIColor.gray
    }
    let classroomChatVoteStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 17)
        $0.color = SharedInfo.USC_redColor
    }
    let classroomChatSectionHeaderStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 12)
        $0.color = UIColor.black
    }
    let attendanceHistoryHeaderStyle = Style {
        $0.font = UIFont(name: "OpenSans-Bold", size: 15)
        $0.color = SharedInfo.USC_redColor
    }
    let attendanceHistoryCellStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 15)
        $0.color = SharedInfo.USC_redColor
    }
    let OHIDLabelStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 10)
        $0.color = UIColor.gray
    }
    let OHInstructorNameStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 19)
    }
    let OHClassNameStyle = Style {
        $0.font = UIFont(name: "OpenSans-Italic", size: 15)
    }
    let OHTimeStyle = Style {
        $0.font = UIFont(name: "OpenSans", size: 12)
    }
}

enum StringStyles: String {
    case guestLogin = "guestLoginStyle"
    case welcome = "welcomeStyle"
    case name = "nameStyle"
    case menuItem = "menuItemStyle"
    case menuItemDisabled = "menuItemDisabledStyle"
    case menuItemDestructive = "menuItemDestructiveStyle"
    case logOut = "logOutStyle"
    case profileName = "profileNameStyle"
    case profileQuote = "profileQuoteStyle"
    case profileAuthor = "profileAuthorStyle"
    case profileUpvote = "profileUpvoteStyle"
    case profileUpvoteButton = "profileUpvoteButtonStyle"
    case profileClassName = "profileClassNameStyle"
    case registrationTextField = "registrationTextFieldStyle"
    case enterClassName = "enterClassNameStyle"
    case enterClassDescription = "enterClassDescriptionStyle"
    case enterClassInstructor = "enterClassInstructorStyle"
    case classroomChatBody = "classroomChatBodyStyle"
    case classroomChatSender = "classroomChatSenderStyle"
    case classroomChatVote = "classroomChatVoteStyle"
    case classroomChatSectionHeader = "classroomChatSectionHeaderStyle"
    case attendanceHistoryHeader = "attendanceHistoryHeaderStyle"
    case attendanceHistoryCell = "attendanceHistoryCellStyle"
    case OHIDLabel = "OHIDLabelStyle"
    case OHInstructorName = "OHInstructorNameStyle"
    case OHClassName = "OHClassNameStyle"
    case OHTime = "OHTimeStyle"
}
