//
//  BudgetViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/31.
//

import UIKit

final class BudgetViewController: AccommodationConditionViewController {

    var accommodationConditionTableViewDataSource: AccommodationConditionTableViewDataSource?
    private var conditionManager: ConditionManager?
    
    static func create(conditionManager: ConditionManager) -> BudgetViewController {
        let budgetViewController = BudgetViewController()
        budgetViewController.conditionManager = conditionManager
        return budgetViewController
    }
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        accommodationConditionTableView.dataSource = accommodationConditionTableViewDataSource
    }
    
    @objc override func selectionCanceled(_ sender: UIBarButtonItem) {
        
    }
    
    @objc override func pushNextViewController(_ sender: UIBarButtonItem) {
        
    }

}
