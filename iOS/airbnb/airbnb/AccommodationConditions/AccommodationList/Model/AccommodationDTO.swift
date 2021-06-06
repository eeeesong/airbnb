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
