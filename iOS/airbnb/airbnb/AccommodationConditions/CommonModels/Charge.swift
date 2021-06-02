//
//  Charge.swift
//  airbnb
//
//  Created by Song on 2021/05/27.
//

import Foundation

class Charge {
    var minimum: Int?
    var maximum: Int?
}

extension Charge: CustomStringConvertible {
    var description: String {
        if let minimum = minimum, let maximum = maximum {
            return "₩\(minimum) ~ ₩\(maximum)"
        } else {
            return ""
        }
    }
}
