//
//  BudgetViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/31.
//

import UIKit

class BudgetViewController: UIViewController {

    private var conditionManager: ConditionManager?
    
    static func create(conditionManager: ConditionManager) -> BudgetViewController {
        let budgetViewController = BudgetViewController()
        budgetViewController.conditionManager = conditionManager
        return budgetViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
