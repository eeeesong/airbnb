//
//  BudgetViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/31.
//

import UIKit

final class BudgetViewController: AccommodationConditionViewController {
    
    private lazy var rangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.text = "₩10,000 ~ ₩1,010,000"
        return label
    }()
    
    private lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .gray
        label.text = "평균 1박 요금은 70,000원입니다."
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17, weight: .bold)
            label.text = "가격 범위"
            return label
        }()
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
    private var viewModel: (AnySearchConditionHandleModel<[Budget]> & BudgetManageModel)?
    
    static func create(viewModel: AnySearchConditionHandleModel<[Budget]> & BudgetManageModel) -> BudgetViewController {
        let budgetViewController = BudgetViewController()
        budgetViewController.viewModel = viewModel
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
        budgetGraphView.delegate = self
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        budgetGraphView.configure()
    }
    
    private func bind() {
        viewModel?.bind(dataHandler: { [weak self] budgets in
            self?.drawGraph(with: budgets)
        }, conditionHandler: { [weak self] conditions in
            self?.accommodationConditionTableViewDataSource?.updateContents(with: conditions)
            self?.updateConditionView()

            if conditions[2] != "" {
                self?.setCancelBarButton()
            }
        })
    }
    
    private func drawGraph(with budgets: [Budget]) {
        DispatchQueue.main.async {
            self.budgetGraphView.drawGraph(with: budgets)
        }
    }
    
    private func updateConditionView() {
        DispatchQueue.main.async {
            self.accommodationConditionTableView.reloadData()
        }
    }
    
    @objc override func selectionCanceled(_ sender: UIBarButtonItem) {
        super.selectionCanceled(sender)
        budgetGraphView.resetThumbs()
        viewModel?.didSelectionCanceled()
    }
    
    @objc override func pushNextViewController(_ sender: UIBarButtonItem) {
        
    }

}

extension BudgetViewController: BudgetSliderDelegate {
    func didDragEnded(with values: [Int]) {
        budgetGraphView.fillOffsets(values: values)
        viewModel?.didNewBudgetSelected(values: values)
    }
}
