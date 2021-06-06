//
//  EndPoint.swift
//  airbnb
//
//  Created by Song on 2021/06/04.
//

import Foundation

struct MockAPI {
    static let baseUrl = "http://airbnb-team4-mockup.herokuapp.com"
    
    enum EndPoint {
        static let priceChart = "/accommodationPriceStats"
        static let accommodations = "/accommodations"
    }
}
