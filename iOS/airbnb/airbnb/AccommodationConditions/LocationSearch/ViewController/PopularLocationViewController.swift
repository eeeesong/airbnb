//
//  PopularLocationViewController.swift
//  airbnb
//
//  Created by Song on 2021/05/18.
//

import UIKit

final class PopularLocationViewController: UIViewController {
    
    @IBOutlet weak var popularLocationTableView: UITableView!
    private var popularLocationTableViewDataSource: PopularLocationTableViewDataSource?
    private var searchController: LocationSearchController?
    private var searchResultUpdater: LocationSearchResultUpdating?
    private var viewModel: AnyResultHandleModel<[PopularLocation]>?

    static func create(with viewModel: AnyResultHandleModel<[PopularLocation]>) -> PopularLocationViewController {
        let storyboard = StoryboardFactory.create(.accommodationConditions)
        let popularLocationViewController = ViewControllerFactory.create(from: storyboard, type: PopularLocationViewController.self)
        popularLocationViewController.viewModel = viewModel
        return popularLocationViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popularLocationTableViewDataSource = PopularLocationTableViewDataSource()
        popularLocationTableView.dataSource = popularLocationTableViewDataSource
        
        setNavigationSearchController()
        
        searchResultUpdater = LocationSearchResultUpdating()
        searchController?.searchResultsUpdater = searchResultUpdater
        searchController?.searchBar.delegate = self

        bind()
    }
    
    private func setNavigationSearchController() {
        let searchResultViewModel = SearchResultViewModel()
        let searchResultViewController = SearchResultTableViewController.create(with: searchResultViewModel)
        searchController = LocationSearchController(searchResultsController: searchResultViewController)
        searchResultViewController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bind() {
        viewModel?.bind { [weak self] popularLocation in
            self?.updateTableView(with: popularLocation)
        } errorHandler: { [weak self] error in
            self?.alertError(error: error)
        }
    }
    
    private func updateTableView(with popularLocations: [PopularLocation]) {
        popularLocationTableViewDataSource?.updateLocations(with: popularLocations)
        DispatchQueue.main.async {
            self.popularLocationTableView.reloadData()
        }
    }
    
    private func alertError(error: Error) {
        let customError = error as? NetworkError ?? NetworkError.unknown
        let alert = AlertFactory.create(error: customError)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarCursurOn()
    }
    
    private func searchBarCursurOn() {
        DispatchQueue.main.async {
            self.searchController?.searchBar.becomeFirstResponder()
        }
    }
    
    @objc private func searchCanceled(_ sender: UIBarButtonItem) {
        inactiveSearchController()
        unsetCancelBarButton()
    }
    
    private func inactiveSearchController() {
        searchController?.isActive = false
    }
    
    private func unsetCancelBarButton() {
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inactiveSearchController()
    }

}

extension PopularLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.searchTextField.text else { return }
        searchText.count > 0 ? setCancelBarButton() : unsetCancelBarButton()
    }
    
    private func setCancelBarButton() {
        guard navigationItem.rightBarButtonItem == nil else { return }
        let buttonTitle = PopularLocationViewModel.ButtonTitle.cancel
        let cancelButtonItem = UIBarButtonItem(title: buttonTitle,
                                               style: .done,
                                               target: self,
                                               action: #selector(searchCanceled))
        navigationItem.setRightBarButton(cancelButtonItem, animated: true)
    }
    
}

extension PopularLocationViewController: SearchResultDelegate {
    
    func didSelect(result: Location) {
        pushNextViewController(with: result)
        inactiveSearchController()
        unsetCancelBarButton()
    }
    
    private func pushNextViewController(with result: Location) {
        let accommodationConditionManager = ConditionManager(location: result)
        let calendarViewModel = CalendarViewModel(conditionManager: accommodationConditionManager)
        let calendarViewController = CalendarViewController.create(with: calendarViewModel)
        self.navigationItem.backButtonTitle = PopularLocationViewModel.ButtonTitle.back
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }
    
}
