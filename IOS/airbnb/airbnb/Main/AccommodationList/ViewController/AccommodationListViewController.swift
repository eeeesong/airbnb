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
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [locationLabel, periodLabel, headcountLabel].forEach { label in
            label.font = .systemFont(ofSize: 15, weight: .light)
            label.textColor = .darkGray
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "0개의 숙소"
        return label
    }()
    
    private lazy var accommodationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = viewInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let cellId = AccommodationCollectionViewCell.reuseIdentifier
        collectionView.register(AccommodationCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var viewInset: CGFloat = {
        let viewWidth = view.frame.width
        return viewWidth * 0.04
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
        addLabel()
        addCollectionView()
    }
    
    private func addStackView() {
        view.addSubview(conditionStackView)
        NSLayoutConstraint.activate([
            conditionStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            conditionStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            conditionStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            conditionStackView.heightAnchor.constraint(equalToConstant: viewInset * 3)
        ])
    }
    
    private func addLabel() {
        view.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            countLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            countLabel.topAnchor.constraint(equalTo: conditionStackView.bottomAnchor)
        ])
    }
    
    private func addCollectionView() {
        view.addSubview(accommodationCollectionView)
        NSLayoutConstraint.activate([
            accommodationCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewInset),
            accommodationCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -viewInset),
            accommodationCollectionView.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: viewInset),
            accommodationCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        accommodationCollectionViewDataSource = AccommodationCollectionViewDataSource()
        accommodationCollectionView.dataSource = accommodationCollectionViewDataSource
        accommodationCollectionView.delegate = self
        requestCards()
    }
    
    private func updateLabels() {
        if let info = conditionManager?.gettableInfos() {
            locationLabel.text = info[0]
            periodLabel.text = info[1]
            headcountLabel.text = info[3]
        }
    }
    
    private func updateDataSource(with cards: [AccommodationCard]) {
        accommodationCollectionViewDataSource?.updateInfos(with: cards)
        DispatchQueue.main.async {
            self.accommodationCollectionView.reloadData()
        }
    }
    
    private var networkManager = AlamofireNetworkManager(with: "http://airbnb-team4-mockup.herokuapp.com")
    
}

extension AccommodationListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight = cellWidth * 1.08
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//뷰모델로 옮겨야 함!
extension AccommodationListViewController {
    private func requestCards() {
        guard let parameters = conditionManager?.query() else { return }
        
        networkManager.get(decodingType: [AccommodationDTO].self,
                           endPoint: "/accommodations",
                           parameter: parameters) { [weak self] result in
            switch result {
            case .success(let data):
                var accomodationCards = [AccommodationCard]()
                data.forEach { dto in
                    let card = AccommodationCard(mainImage: dto.mainImage,
                                                 mainImagePath: nil,
                                                 reviewRating: dto.reviewRating,
                                                 reviewCounts: dto.reviewCounts,
                                                 name: dto.name,
                                                 price: dto.pricePerNight)
                    accomodationCards.append(card)
                }
                
                self?.updateDataSource(with: accomodationCards)
                self?.countLabel.text = "\(accomodationCards.count)개의 숙소"
                
                let cacheManager = AlamofireImageLoadManager()
                
                accomodationCards.enumerated().forEach { (index, card) in
                    if let url = card.mainImage {
                    cacheManager.load(from: url) { [weak self] cachePath in
                        self?.accommodationCollectionViewDataSource?.updateCachePath(with: cachePath, for: index)
                            DispatchQueue.main.async {
                                self?.accommodationCollectionView.reloadData()
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
