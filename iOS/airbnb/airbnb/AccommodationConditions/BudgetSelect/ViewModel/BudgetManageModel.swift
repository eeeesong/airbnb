//
//  BudgetManageModel.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import Foundation

protocol BudgetManageModel {
    func didNewBudgetSelected(values: [Int])
    func didSelectionCanceled()
}
