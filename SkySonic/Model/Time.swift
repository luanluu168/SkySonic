//
//  Time.swift
//  SkySonic
//
//  Created by Luan Luu on 11/9/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

struct Time {
    var hours: Int     = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    mutating func updateTime(inputSeconds: Float64) {
        // if the inputSeconds is not a number, e.g. 0.0 * .infinity, do nothing
        guard !inputSeconds.isNaN else { return }
        
        // otherwise, calculate the hour, minute, second, and assign them to the member variables
        self.seconds = Int(inputSeconds) % 60
        self.minutes = self.seconds / 60
        self.hours = minutes / 60
    }
    
    func getHoursInStringFormat() -> String {
        return String.init(format: "%02d", self.hours)
    }
    
    func getMinutesInStringFormat() -> String {
        return String.init(format: "%02d", self.minutes)
    }
    
    func getSecondsInStringFormat() -> String {
        return String.init(format: "%02d", self.seconds)
    }
}
