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
    
    private lazy var budgetSlider: UISlider = {
        let height = frame.height * 0.03
        let origin = CGPoint(x: 0, y: graphStartAt.y - height / 2)
        let size = CGSize(width: frame.width, height: height)
        let frame = CGRect(origin: origin, size: size)
        let slider = UISlider(frame: frame)
        let pause = UIImage(systemName: "pause")
        
        slider.setThumbImage(pause, for: .normal)
        slider.setMaximumTrackImage(pause, for: .normal)
        slider.setMinimumTrackImage(pause, for: .normal)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        return slider
    }()

    private lazy var graphStartAt: CGPoint = {
        let centerY = frame.height / 2
        return CGPoint(x: 0, y: centerY)
    }()
    
    func configure() {
        addSubview(budgetSlider)
        NSLayoutConstraint.activate([
            budgetSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            budgetSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            budgetSlider.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func drawGraph(with budgets: [Budget]) {
    
        guard let maxCount = budgets.max()?.count else { return }
        
        let Xspacing = frame.width / CGFloat(budgets.count + 6)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: graphStartAt.x + Xspacing * 2, y: graphStartAt.y))

        budgets.enumerated().forEach { (idx, budget) in
            let XPoint = Xspacing * CGFloat(idx + 2)
            let YScale = CGFloat(budget.count) / CGFloat(maxCount)
            let YPoint = yCoordinate(for: YScale)
            let nextPoint = CGPoint(x: XPoint, y: YPoint)
            path.addLine(to: nextPoint)
        }
        
        let lastPoint = CGPoint(x: Xspacing * CGFloat(budgets.count + 4), y: frame.height / 2)
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
        let centerY = graphStartAt.y
        let point = centerY * scale
        return centerY - point
    }

}
