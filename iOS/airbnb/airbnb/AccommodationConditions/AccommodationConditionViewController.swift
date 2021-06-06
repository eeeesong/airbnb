//
//  AccommodationConditionViewController.swift
//  airbnb
//
//  Created by Song on 2021/06/01.
//

import UIKit

class AccommodationConditionViewController: UIViewController {

    private lazy var passButton: UIBarButtonItem = {
        return UIBarButtonItem(title: CalendarViewModel.ButtonTitle.pass,
                               style: .plain,
                               target: self,
                               action: nil)
    }()
    
    private lazy var nextButton: UIBarButtonItem = {
        let nextButton = UIBarButtonItem(title: CalendarViewModel.ButtonTitle.next,
                                         style: .plain,
                                         target: self,
                                         action: #selector(pushNextViewController))
        nextButton.isEnabled = false
        return nextButton
    }()
    
    private lazy var toolBar: UIToolbar = {
        let tempFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let toolBar = UIToolbar(frame: tempFrame)
        toolBar.tintColor = .systemPink
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let passButton = self.passButton
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextButton = self.nextButton
        toolBar.setItems([passButton, spacing, nextButton], animated: true)
        
        return toolBar
    }()
    
    private(set) lazy var accommodationConditionTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let cellId = AccommodationConditionTableViewCell.reuseIdentifier
        tableView.register(AccommodationConditionTableViewCell.self, forCellReuseIdentifier: cellId)
        
        return tableView
    }()
    
    private(set) lazy var tableCellHeight: CGFloat = {
        let viewHeight = view.frame.height
        return viewHeight * 0.05
    }()
    
    private(set) lazy var viewInset: CGFloat = {
        let viewWidth = view.frame.width
        return viewWidth * 0.07
    }()
    
    override func loadView() {
        super.loadView()
        addToolBar()
        addTableView()
        view.backgroundColor = .white
        edgesForExtendedLayout = .all
        title = "숙소 찾기"
    }

    private func addToolBar() {
        view.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addTableView() {
        view.addSubview(accommodationConditionTableView)
        accommodationConditionTableView.rowHeight = tableCellHeight
        NSLayoutConstraint.activate([
            accommodationConditionTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            accommodationConditionTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            accommodationConditionTableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
            accommodationConditionTableView.heightAnchor.constraint(equalToConstant: tableCellHeight * 4)
        ])
    }
    
    func setCancelBarButton() {
        guard navigationItem.rightBarButtonItem == nil else { return }
        let buttonTitle = CalendarViewModel.ButtonTitle.cancel
        let cancelButtonItem = UIBarButtonItem(title: buttonTitle,
                                               style: .done,
                                               target: self,
                                               action: #selector(selectionCanceled))
        navigationItem.setRightBarButton(cancelButtonItem, animated: false)
        changeBarButtonStatus(isConditionSelected: true)
    }
    
    @objc func selectionCanceled(_ sender: UIBarButtonItem) {
        unsetCancelBarButton()
    }
    
    private func unsetCancelBarButton() {
        navigationItem.setRightBarButton(nil, animated: false)
        changeBarButtonStatus(isConditionSelected: false)
    }
    
    private func changeBarButtonStatus(isConditionSelected selectionStatus: Bool) {
        nextButton.isEnabled = selectionStatus
        passButton.isEnabled = !selectionStatus
    }
    
    @objc func pushNextViewController(_ sender: UIBarButtonItem) {
        
    }
    
}
