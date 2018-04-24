//
//  MyTheme.swift
//  TodayNews
//
//

import Foundation
import SwiftTheme

enum MyTheme: Int {

    case day = 0

    case night = 1

    static var current = MyTheme.day
    static var before = MyTheme.day
    
    /// 选择主题
    static func switchTo(_ theme: MyTheme) {
        
        before = current
        current = theme
        
        switch theme {
            case .day: ThemeManager.setTheme(plistName: "default_theme", path: .mainBundle)
            case .night: ThemeManager.setTheme(plistName: "night_theme", path: .mainBundle)
        }
    }
    
    /// 选择了黑色主题
    static func switchNight(_ isToNight: Bool) {
        switchTo(isToNight ? .night : before)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
}
