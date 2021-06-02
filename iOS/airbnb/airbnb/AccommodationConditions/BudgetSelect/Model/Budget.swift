//
//  Budget.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import Foundation

struct Budget {
    let count: Int
    let price: Int
}

extension Budget: Comparable {
    static func < (lhs: Budget, rhs: Budget) -> Bool {
        return lhs.count < rhs.count
    }
}
