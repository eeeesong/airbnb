//
//  Period.swift
//  airbnb
//
//  Created by Song on 2021/05/27.
//

import Foundation

class Period {
    
    private let sameYearDateFormat = DateFormat.monthDay
    private let diffYearDateFormat = DateFormat.monthDayYear
    
    var checkIn: Date?
    var checkOut: Date?

    func resetAll() {
        checkIn = nil
        checkOut = nil
    }
    
    private func checkInString() -> String? {
        guard let checkIn = checkIn else { return nil }
        let dateFormat = isSameYear(date: checkIn) ? sameYearDateFormat : diffYearDateFormat
        return DateFormatter.dateToString(format: dateFormat, date: checkIn)
    }
    
    private func checkOutString() -> String? {
        guard let checkOut = checkOut else { return nil }
        let dateFormat = isSameYear(date: checkOut) ? sameYearDateFormat : diffYearDateFormat
        return DateFormatter.dateToString(format: dateFormat, date: checkOut)
    }
    
    private func isSameYear(date: Date) -> Bool {
        let today = Date()
        return Calendar.current.isDate(date, equalTo: today, toGranularity: .year)
    }

}

extension Period: CustomStringConvertible {
    var description: String {
        if let checkIn = checkInString(), let checkOut = checkOutString() {
            return checkIn + " ~ " + checkOut
        } else {
            return checkInString() ?? ""
        }
    }
}
