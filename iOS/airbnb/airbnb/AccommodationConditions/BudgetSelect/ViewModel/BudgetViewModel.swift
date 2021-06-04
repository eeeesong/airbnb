//
//  BudgetViewModel.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import Foundation

final class BudgetViewModel: AnySearchConditionHandleModel<[Budget]> {
    
    private var budgets: [Budget]? {
        didSet {
            guard let budgets = budgets else { return }
            dataHandler?(budgets)
        }
    }
    
    private var accommodationConditions: [String]? {
        didSet {
            guard let searchResult = accommodationConditions else { return }
            conditionHandler?(searchResult)
        }
    }
    
    enum ButtonTitle {
        static let back = "가격 선택"
    }
    
    private var budgetManager: BudgetManager?
    
    override func bind(dataHandler: @escaping DataHandler, conditionHandler: @escaping ConditionHandler) {
        super.bind(dataHandler: dataHandler, conditionHandler: conditionHandler)
        getPriceData()
    }
    
    private let networkManager = AlamofireNetworkManager(with: "http://airbnb-team4-mockup.herokuapp.com")
    
    private func getPriceData() {
        networkManager.get(decodingType: [Budget].self,
                           endPoint: "/accommodationPriceStats", parameter: nil) { [weak self] result in
            switch result {
            case .success(let budgets):
                self?.createBudgetManager(with: budgets)
            case .failure(let error):
                print(error)
                let mockBudget = self?.createMock() ?? []
                self?.createBudgetManager(with: mockBudget)
            }
        }
    }
    
    private func createBudgetManager(with budgets: [Budget]) {
        budgetManager = BudgetManager(budgets: budgets)
        self.budgets = budgetManager?.budgets
    }
    
    private func createMock() -> [Budget] {
        var randomNumbers = [Int]()
        (0...100).forEach { index in
            randomNumbers.append(Int.random(in: 0...300))
        }
        var mockBudget = [Budget]()
        randomNumbers.enumerated().forEach { (index, number) in
            mockBudget.append(Budget(count: number,
                                     price: (index+1) * 10000))
        }
        return mockBudget
    }
    
    private func updateConditions() {
        accommodationConditions = conditionManager.gettableInfos()
    }
    
}

extension BudgetViewModel: BudgetManageModel {
    
    func didNewBudgetSelected(values: [Int]) {
        guard let min = budgetManager?.findPrice(at: values[0]),
              let max = budgetManager?.findPrice(at: values[1]) else { return }
        conditionManager.updateCharge(with: [min, max])
        updateConditions()
        
    }
    
    func didSelectionCanceled() {
        conditionManager.updateCharge(with: [nil, nil])
        updateConditions()
    }
    
}
