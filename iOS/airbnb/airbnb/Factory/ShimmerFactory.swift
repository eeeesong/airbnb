//
//  ShimmerFactory.swift
//  airbnb
//
//  Created by Song on 2021/06/04.
//

import UIKit

struct ShimmerFactory {
    
    static func gradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradientColorOne = UIColor(white: 0.87, alpha: 1.0).cgColor
        let gradientColorTwo = UIColor(white: 0.93, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        return gradientLayer
    }

    static func shimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.3
        return animation
    }
    
}
