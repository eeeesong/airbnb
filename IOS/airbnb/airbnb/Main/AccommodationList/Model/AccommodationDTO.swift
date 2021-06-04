//
//  AccommodationDTO.swift
//  airbnb
//
//  Created by Song on 2021/06/03.
//

import Foundation

struct AccommodationDTO: Decodable {
    let id: Int
    let name: String
    let accommodationOption: AccommodationOption
    let totalPrice: Int?
    let pricePerNight: Int
    let reviewRating: Double
    let reviewCounts: Int
    let mainImage: String?
}

struct AccommodationOption: Decodable {
    let capacity: Int
    let accommodationType: String
    let bedroomCount: Int
    let restroomCount: Int
    let restroomType: String
    let hasKitchen: Bool
    let hasInternet: Bool
    let hasAirconditioner: Bool
    let hasHairdrier: Bool
}

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
        return  ["checkinDate": checkinDate,
                 "checkoutDate": checkoutDate,
                 "startPrice": startPrice,
                 "endPrice": endPrice,
                 "numberOfAdults": numberOfAdults,
                 "numberOfChildren": numberOfChildren,
                 "numberOfBabies": numberOfBabies]
    }
}
