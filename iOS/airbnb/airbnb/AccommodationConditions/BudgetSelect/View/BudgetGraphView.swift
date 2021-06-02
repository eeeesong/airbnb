//
//  BudgetGraphView.swift
//  airbnb
//
//  Created by Song on 2021/06/01.
//

import UIKit
import MultiSlider

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
        slider.isContinuous = true
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
    
    private var firstBlendLayer: CALayer?
    private var secondBlendLayer: CALayer?
    private var currentBudgets: [Budget]?
    private let dummyCount = 10
    private var maximumValue: CGFloat?
    weak var delegate: BudgetSliderDelegate?
    
    func configure() {
        configureBlendLayers()
        addSubview(budgetSlider)
        NSLayoutConstraint.activate([
            budgetSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            budgetSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            budgetSlider.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func configureBlendLayers() {
        firstBlendLayer = createBlendLayer()
        secondBlendLayer = createBlendLayer()
        
        guard let firstBlendLayer = firstBlendLayer,
              let secondBlendLayer = secondBlendLayer else { return }
        
        layer.addSublayer(firstBlendLayer)
        layer.addSublayer(secondBlendLayer)
    }
    
    private func createBlendLayer() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.compositingFilter = "differenceBlendMode"
        return layer
    }
    
    func drawGraph(with budgets: [Budget]) {
        let budgets = addDummy(to: budgets, count: dummyCount)
        
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
        self.maximumValue = CGFloat(count)
    }
    
    func fillOffsets(values: [Int]) {
        guard let totalCount = currentBudgets?.count,
              let firstBlendLayer = firstBlendLayer,
              let secondBlendLayer = secondBlendLayer else { return }
        
        let movedValues = values.map{ $0 + dummyCount }
        let unit = frame.width / CGFloat(totalCount)
        
        let firstWidth = CGFloat(movedValues[0]) * unit
        let firstFrame = CGRect(x: 0, y: 0, width: firstWidth, height: frame.height / 2)
        firstBlendLayer.frame = firstFrame
        
        let secondWidth = CGFloat(totalCount - movedValues[1]) * unit
        let secondX = CGFloat(movedValues[1]) * unit
        let secondFrame = CGRect(x: secondX, y: 0, width: secondWidth, height: frame.height / 2)
        secondBlendLayer.frame = secondFrame
    }
    
    func resetThumbs() {
        let max = self.maximumValue ?? 0
        budgetSlider.value = [0, max]
        fillOffsets(values: budgetSlider.value.map{ Int($0) })
    }
    
    @objc private func sliderDragEnded(_ sender: MultiSlider) {
        let newValues = sender.value.map{ Int($0) - dummyCount }
        delegate?.didDragEnded(with: newValues)
    }
    
}
