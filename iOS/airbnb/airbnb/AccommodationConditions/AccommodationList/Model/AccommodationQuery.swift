//
//  AccommodationQuery.swift
//  airbnb
//
//  Created by Song on 2021/06/04.
//

import Foundation

struct AccommodationQuery: Decodable {
    let checkinDate: String
    let checkoutDate: String
    let startPrice: Int
    let endPrice: Int
    let numberOfAdults: Int
    let numberOfChildren: Int
    let numberOfBabies: Int
    
    init(checkinDate: Date, checkoutDate: Date?, startPrice: Int, endPrice: Int) {
        self.checkinDate = DateFormatter.dateToString(format: DateFormat.yearMonthDay, date: checkinDate)
        if let checkoutDate = checkoutDate {
            self.checkoutDate = DateFormatter.dateToString(format: DateFormat.yearMonthDay, date: checkoutDate)
        } else {
            self.checkoutDate = self.checkinDate
        }
        self.startPrice = startPrice
        self.endPrice = endPrice
        self.numberOfAdults = 1
        self.numberOfChildren = 0
        self.numberOfBabies = 0
    }
    
    func asDictionary() -> [String: Any] {
        return  [QueryKeys.checkInDate: checkinDate,
                 QueryKeys.checkOutDate: checkoutDate,
                 QueryKeys.minimumPrice: startPrice,
                 QueryKeys.maximumPrice: endPrice,
                 QueryKeys.numberOfAdults: numberOfAdults,
                 QueryKeys.numberOfChildren: numberOfChildren,
                 QueryKeys.numberOfBabies: numberOfBabies]
    }
}

enum QueryKeys {
    static let checkInDate = "checkinDate"
    static let checkOutDate = "checkoutDate"
    static let minimumPrice = "startPrice"
    static let maximumPrice = "endPrice"
    static let numberOfAdults = "numberOfAdults"
    static let numberOfChildren = "numberOfChildren"
    static let numberOfBabies = "numberOfBabies"
}
