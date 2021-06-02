//
//  BudgetManager.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import Foundation

struct BudgetManager {
    private(set) var budgets: [Budget]
    
    func findPrice(at index: Int) -> Int {
        let index = safeIndex(for: index)
        return budgets[index].price
    }
    
    private func safeIndex(for index: Int) -> Int {
        if index < 0 {
            return 0
        } else if index >= budgets.count - 1 {
            return budgets.count - 1
        } else {
            return index
        }
    }
    
    func findIndex(of price: Int) -> Int? {
        var targetIndex: Int?
        budgets.enumerated().forEach { (index, budget) in
            if budget.price == price {
                targetIndex = index
            }
        }
        return targetIndex
    }
}
