//
//  BudgetGraphView.swift
//  airbnb
//
//  Created by Song on 2021/06/01.
//

import UIKit

struct Budget {
    let count: Int
}

extension Budget: Comparable {
    static func < (lhs: Budget, rhs: Budget) -> Bool {
        return lhs.count < rhs.count
    }
}

final class BudgetGraphView: UIView {

    private lazy var centerYPoint: CGPoint = {
        let centerY = frame.height / 2
        return CGPoint(x: 0, y: centerY)
    }()
    
    func drawGraph(with budgets: [Budget]) {
    
        guard let maxCount = budgets.max()?.count else { return }
        
        let Xspacing = frame.width / CGFloat(budgets.count + 2)
        let path = UIBezierPath()
        path.move(to: centerYPoint)
        
        budgets.enumerated().forEach { (idx, budget) in
            let XPoint = Xspacing * CGFloat(idx + 1)
            let YScale = CGFloat(budget.count) / CGFloat(maxCount)
            let YPoint = yCoordinate(for: YScale)
            let nextPoint = CGPoint(x: XPoint, y: YPoint)
            path.addLine(to: nextPoint)
        }
        
        let lastPoint = CGPoint(x: frame.width, y: frame.height / 2)
        let lastPoint2 = CGPoint(x: 0, y: frame.height / 2)
        path.addLine(to: lastPoint)
        path.addLine(to: lastPoint2)
        path.fill()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.darkGray.cgColor
        
        self.layer.addSublayer(layer)
        
    }
    
    private func yCoordinate(for scale: CGFloat) -> CGFloat {
        let centerY = centerYPoint.y
        let point = centerY * scale
        return centerY - point
    }

}
