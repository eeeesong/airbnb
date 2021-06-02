//
//  BudgetGraphView.swift
//  airbnb
//
//  Created by Song on 2021/06/01.
//

import UIKit
import MultiSlider

struct Budget {
    let count: Int
    let price: Int
}

extension Budget: Comparable {
    static func < (lhs: Budget, rhs: Budget) -> Bool {
        return lhs.count < rhs.count
    }
}

protocol BudgetSliderDelegate: AnyObject {
    func didDragEnded(with values: [Int])
}

final class BudgetGraphView: UIView {

    private lazy var budgetSlider: MultiSlider = {
        let height = frame.height * 0.03
        let origin = CGPoint(x: 0, y: graphStartAt.y - height / 2)
        let size = CGSize(width: frame.width, height: height)
        let frame = CGRect(origin: origin, size: size)
        let slider = MultiSlider(frame: frame)
        
        slider.orientation = .horizontal
        slider.isContinuous = false
        slider.tintColor = .white
        slider.showsThumbImageShadow = true
        slider.keepsDistanceBetweenThumbs = true
        slider.addTarget(self, action: #selector(sliderDragEnded), for: .valueChanged)
        return slider
    }()

    private lazy var graphStartAt: CGPoint = {
        let centerY = frame.height / 2
        return CGPoint(x: 0, y: centerY)
    }()
    
    private lazy var blendLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.compositingFilter = "differenceBlendMode"
        return layer
    }()
    
    private lazy var blendLayer2: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.compositingFilter = "differenceBlendMode"
        return layer
    }()
    
    private var currentBudgets: [Budget]?
    weak var delegate: BudgetSliderDelegate?
    
    func configure() {
        layer.addSublayer(blendLayer)
        layer.addSublayer(blendLayer2)
        addSubview(budgetSlider)
        NSLayoutConstraint.activate([
            budgetSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            budgetSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            budgetSlider.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func drawGraph(with budgets: [Budget]) {
        
        let budgets = addDummy(to: budgets, count: 10)
        
        guard let maxCount = budgets.max()?.count else { return }
        
        currentBudgets = budgets
        let Xspacing = frame.width / CGFloat(budgets.count)
        let path = UIBezierPath()
        path.move(to: graphStartAt)

        budgets.enumerated().forEach { (idx, budget) in
            let XPoint = Xspacing * CGFloat(idx)
            let YScale = CGFloat(budget.count) / CGFloat(maxCount)
            let YPoint = yCoordinate(for: YScale)
            let nextPoint = CGPoint(x: XPoint, y: YPoint)
            path.addLine(to: nextPoint)
        }
        
        let lastPoint = CGPoint(x: Xspacing * CGFloat(budgets.count), y: frame.height / 2)
        let lastPoint2 = CGPoint(x: 0, y: frame.height / 2)
        path.addLine(to: lastPoint)
        path.addLine(to: lastPoint2)
        path.fill()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.darkGray.cgColor
        
        self.layer.addSublayer(layer)
        
        changeBudgetSlider(with: budgets)
    }
    
    private func addDummy(to budgets: [Budget], count: Int) -> [Budget] {
        var budgets = budgets
        let dummy = Budget(count: 0, price: 0)
        let dummies = Array(repeating: dummy, count: count)
        budgets.append(contentsOf: dummies)
        budgets.insert(contentsOf: dummies, at: 0)
        return budgets
    }
    
    private func yCoordinate(for scale: CGFloat) -> CGFloat {
        let centerY = graphStartAt.y
        let point = centerY * scale
        return centerY - point
    }
    
    func changeBudgetSlider(with budgets: [Budget]) {
        let count = budgets.count
        budgetSlider.minimumValue = 0
        budgetSlider.maximumValue = CGFloat(count)
        budgetSlider.value = [0, CGFloat(count)]
        budgetSlider.snapStepSize = 1
    }
    
    func fillOffsets(values: [Int]) {
        guard let totalCount = currentBudgets?.count else { return }
        let unit = frame.width / CGFloat(totalCount)
        
        let firstWidth = CGFloat(values[0]) * unit
        let firstFrame = CGRect(x: 0, y: 0, width: firstWidth, height: frame.height / 2)
        blendLayer.frame = firstFrame
        
        let secondWidth = CGFloat(totalCount - values[1]) * unit
        let secondX = CGFloat(values[1]) * unit
        let secondFrame = CGRect(x: secondX, y: 0, width: secondWidth, height: frame.height / 2)
        blendLayer2.frame = secondFrame
    }
    
    @objc private func sliderDragEnded(_ sender: MultiSlider) {
        let newValues = sender.value.map{ Int($0) }
        delegate?.didDragEnded(with: newValues)
    }
    
}
