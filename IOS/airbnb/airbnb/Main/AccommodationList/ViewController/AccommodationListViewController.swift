//
//  AccommodationListViewController.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import UIKit

final class AccommodationListViewController: UIViewController {

    private lazy var locationLabel = UILabel()
    private lazy var periodLabel = UILabel()
    private lazy var headcountLabel = UILabel()
    
    private lazy var conditionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [locationLabel, periodLabel, headcountLabel].forEach { label in
            label.font = .systemFont(ofSize: 15, weight: .light)
            label.textColor = .darkGray
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private lazy var accommodationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = viewInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let cellId = AccommodationCollectionViewCell.reuseIdentifier
        collectionView.register(AccommodationCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var viewInset: CGFloat = {
        let viewWidth = view.frame.width
        return viewWidth * 0.08
    }()
    
    private var conditionManager: ConditionManager?
    private var accommodationCollectionViewDataSource: AccommodationCollectionViewDataSource?
    
    static func create(conditionManager: ConditionManager) -> AccommodationListViewController {
        let accommodationListViewController = AccommodationListViewController()
        accommodationListViewController.conditionManager = conditionManager
        return accommodationListViewController
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        edgesForExtendedLayout = .all
        title = "숙소 찾기"
        addStackView()
        addCollectionView()
    }
    
    private func addStackView() {
        view.addSubview(conditionStackView)
        NSLayoutConstraint.activate([
            conditionStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            conditionStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            conditionStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            conditionStackView.heightAnchor.constraint(equalToConstant: viewInset * 2)
        ])
    }
    
    private func addCollectionView() {
        view.addSubview(accommodationCollectionView)
        NSLayoutConstraint.activate([
            accommodationCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            accommodationCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            accommodationCollectionView.topAnchor.constraint(equalTo: conditionStackView.bottomAnchor),
            accommodationCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        accommodationCollectionViewDataSource = AccommodationCollectionViewDataSource()
        accommodationCollectionView.dataSource = accommodationCollectionViewDataSource
        accommodationCollectionView.delegate = self
    }
    
    private func updateLabels() {
        if let info = conditionManager?.gettableInfos() {
            locationLabel.text = info[0]
            periodLabel.text = info[1]
            headcountLabel.text = info[3]
        }
    }
    
}

extension AccommodationListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight = cellWidth * 1.15
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
