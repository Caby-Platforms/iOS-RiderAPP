//
//  GExtension+UIDate.swift
//  EdooodleIT
//
//  Created by Hyperlink on 18/07/18.
//  Copyright © 2018 Hyperlink. All rights reserved.
//

import UIKit

extension Date {
    
    public func timeAgoSince() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year)" + " years ago".localized
        }
        
        if let year = components.year, year >= 1 {
            return "\(year)" + " year ago".localized
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)" + " months ago".localized
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)" + " month ago".localized
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)" + " weeks ago".localized
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)" + " week ago".localized
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)" + " days ago".localized
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)" + " day ago".localized
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)" + " hours ago".localized
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)" + " hour ago".localized
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)" + " minutes ago".localized
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)" + " minute ago".localized
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)" + " seconds ago".localized
        }
        
        return "Just now".localized
        
    }
    
}
