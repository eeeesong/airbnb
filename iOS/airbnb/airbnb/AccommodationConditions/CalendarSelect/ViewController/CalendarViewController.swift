//
//  CalendarViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/19.
//

import UIKit

final class CalendarViewController: AccommodationConditionViewController {
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let cellId = CalendarCollectionViewCell.reuseIdentifier
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let headerId = MonthHeaderCollectionViewCell.reuseIdentifier
        collectionView.register(MonthHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

        return collectionView
    }()
    
    private lazy var weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let weekdays = CalendarViewModel.weekdays
        weekdays.forEach { day in
            let label = UILabel()
            label.text = day
            label.textColor = .gray
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15, weight: .bold)
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    override func loadView() {
        super.loadView()
        addStackView()
        addCollectionView()
    }

    private func addStackView() {
        view.addSubview(weekdayStackView)
        NSLayoutConstraint.activate([
            weekdayStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            weekdayStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            weekdayStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewInset),
            weekdayStackView.heightAnchor.constraint(equalToConstant: accommodationConditionTableView.rowHeight)
        ])
    }
    
    private func addCollectionView() {
        view.addSubview(calendarCollectionView)
        NSLayoutConstraint.activate([
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            calendarCollectionView.bottomAnchor.constraint(equalTo: accommodationConditionTableView.topAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor)
        ])
    }
    
    private var accommodationConditionTableViewDataSource: AccommodationConditionTableViewDataSource?
    private var calendarCollecionViewDataSource: CalendarCollectionViewDataSource?
    private var viewModel: (AnySearchConditionHandleModel<[Month]> & CalendarManageModel)?
    
    static func create(with viewModel: AnySearchConditionHandleModel<[Month]> & CalendarManageModel) -> CalendarViewController {
        let storyboard = StoryboardFactory.create(.accommodationConditions)
        let calendarViewController = ViewControllerFactory.create(from: storyboard, type: CalendarViewController.self)
        calendarViewController.viewModel = viewModel
        return calendarViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accommodationConditionTableViewDataSource = AccommodationConditionTableViewDataSource()
        self.calendarCollecionViewDataSource = CalendarCollectionViewDataSource()
        accommodationConditionTableView.dataSource = accommodationConditionTableViewDataSource
        accommodationConditionTableViewDataSource?.updateTitles(with: CalendarViewModel.conditionTitles)
        calendarCollectionView.dataSource = calendarCollecionViewDataSource
        calendarCollectionView.delegate = self
        bind()
    }
    
    private func bind() {
        viewModel?.bind(dataHandler: { [weak self] months in
            self?.calendarCollecionViewDataSource?.updateCalendar(with: months)
            self?.updateCalendarView()
        }, conditionHandler: { [weak self] conditions in
            self?.accommodationConditionTableViewDataSource?.updateContents(with: conditions)
            self?.updateConditionView()
            self?.updateCalendarView()
            
            if conditions[1] != "" {
                self?.setCancelBarButton()
            }
        })
    }
    
    private func updateConditionView() {
        DispatchQueue.main.async {
            self.accommodationConditionTableView.reloadData()
        }
    }
    
    private func updateCalendarView() {
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
        }
    }
    
    @objc override func selectionCanceled(_ sender: UIBarButtonItem) {
        super.selectionCanceled(sender)
        viewModel?.didSelectionCanceled()
    }

    @objc override func pushNextViewController(_ sender: UIBarButtonItem) {
        super.pushNextViewController(sender)
        let tempLocation = Location(name: "임시", coordinate: Coordinate(latitude: 0, longitude: 0))
        let tempConditionManager = ConditionManager(location: tempLocation)
        let budgetViewController = BudgetViewController.create(conditionManager: tempConditionManager)
        budgetViewController.accommodationConditionTableViewDataSource = accommodationConditionTableViewDataSource
        self.navigationController?.pushViewController(budgetViewController, animated: true)
    }
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 7.0
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: viewInset, left: 0, bottom: viewInset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: viewInset * 2.5)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel?.calendarCreationNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didNewDateSelected(at: indexPath)
    }

}
