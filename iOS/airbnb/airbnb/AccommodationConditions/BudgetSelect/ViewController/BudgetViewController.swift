//
//  BudgetViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/31.
//

import UIKit

final class BudgetViewController: AccommodationConditionViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "가격 범위"
        return label
    }()
    
    private lazy var rangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.text = "₩10,000 ~ ₩100,000,000"
        return label
    }()
    
    private lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .gray
        label.text = "평균 1박 요금은 777,777원입니다."
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel, rangeLabel, averageLabel].forEach { label in
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private lazy var budgetGraphView: BudgetGraphView = {
        let view = BudgetGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var accommodationConditionTableViewDataSource: AccommodationConditionTableViewDataSource?
    private var conditionManager: ConditionManager?
    
    static func create(conditionManager: ConditionManager) -> BudgetViewController {
        let budgetViewController = BudgetViewController()
        budgetViewController.conditionManager = conditionManager
        return budgetViewController
    }
    
    override func loadView() {
        super.loadView()
        addStackView()
        addGraphView()
    }

    private func addStackView() {
        view.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            infoStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewInset),
            infoStackView.heightAnchor.constraint(equalToConstant: tableCellHeight * 2)
        ])
    }
    
    private func addGraphView() {
        view.addSubview(budgetGraphView)
        NSLayoutConstraint.activate([
            budgetGraphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            budgetGraphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            budgetGraphView.bottomAnchor.constraint(equalTo: accommodationConditionTableView.topAnchor),
            budgetGraphView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: viewInset)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        accommodationConditionTableView.dataSource = accommodationConditionTableViewDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawGraph()
        budgetGraphView.configure()
    }
    
    private func drawGraph() {
        var randomNumbers = [Int]()
        (0...30).forEach { index in
            randomNumbers.append(Int.random(in: 0...300))
        }
        var mockBudget = [Budget]()
        randomNumbers.enumerated().forEach { (index, number) in
            mockBudget.append(Budget(count: number,
                                     price: index * 10000))
        }
        budgetGraphView.drawGraph(with: mockBudget)
    }
    
    @objc override func selectionCanceled(_ sender: UIBarButtonItem) {
        
    }
    
    @objc override func pushNextViewController(_ sender: UIBarButtonItem) {
        
    }

}
