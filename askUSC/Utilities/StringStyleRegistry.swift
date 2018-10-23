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
        print("Style init")
    }
    
}

fileprivate struct styleStruct {
    let welcomeStyle = Style {
        $0.font = SystemFonts.HelveticaNeue_Thin.font(size: 27)
        $0.color = UIColor(rgb: 0xFFCC00)
    }
    let nameStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 27)
        $0.color = UIColor.white
    }
    let logOutStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 17)
        $0.color = SharedInfo.USC_redColor
    }
    let profileNameStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 27)
        $0.color = UIColor.black
    }
    let profileQuoteStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 20)
        $0.color = UIColor.black
        $0.lineBreakMode = .byTruncatingTail
        $0.alignment = .center
    }
    let profileAuthorStyle = Style {
        $0.font = SystemFonts.HelveticaNeue_Italic.font(size: 17)
        $0.color = UIColor.black
        $0.alignment = .right
    }
    let profileUpvoteStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 15)
        $0.color = SharedInfo.USC_redColor
    }
    let profileUpvoteButtonStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 17)
        $0.color = UIColor.white
    }
    let profileClassNameStyle = Style {
        $0.font = SystemFonts.HelveticaNeue.font(size: 17)
        $0.color = UIColor.black
        $0.alignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
}

enum StringStyles: String {
    case welcome = "welcomeStyle"
    case name = "nameStyle"
    case logOut = "logOutStyle"
    case profileName = "profileNameStyle"
    case profileQuote = "profileQuoteStyle"
    case profileAuthor = "profileAuthorStyle"
    case profileUpvote = "profileUpvoteStyle"
    case profileUpvoteButton = "profileUpvoteButtonStyle"
    case profileClassName = "profileClassNameStyle"
}