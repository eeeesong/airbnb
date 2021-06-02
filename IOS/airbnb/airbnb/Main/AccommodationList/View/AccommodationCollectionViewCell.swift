//
//  AccommodationCollectionViewCell.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import UIKit

final class AccommodationCollectionViewCell: UICollectionViewCell {
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPink
        imageView.layer.cornerRadius = 0.08
        return imageView
    }()
    
    private lazy var averageRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "5.0"
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "(후기 199개)"
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        let star = UIImage(systemName: "star.fill")
        let starImageView = UIImageView(image: star)
        starImageView.tintColor = .red
        [starImageView, averageRatingLabel, reviewCountLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "₩800,000"
        return label
    }()
    
    private lazy var allInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        let allViews = [thumbImageView, ratingStackView, titleLabel, priceLabel]
        allViews.forEach { view in
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(allInfoStackView)
        NSLayoutConstraint.activate([
            allInfoStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            allInfoStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            allInfoStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            allInfoStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateCell() {
        
    }
    
}

/*
 {
     "id": 3,
     "name": "프레디 여관",
     "accommodationOption": {
       "capacity": 2,
       "pricePerNight": 40000,
       "accommodationType": "ONEROOM",
       "bedroomCount": 1,
       "restroomCount": 1,
       "restroomType": "PUBLIC",
       "hasKitchen": false,
       "hasInternet": false,
       "hasAirconditioner": true,
       "hasHairdrier": true
     },
     "totalPrice": null,
     "reviewRating": 3.1,
     "reviewCounts": 5,
     "mainImage": "https://image.zdnet.co.kr/2016/12/08/imc_47ix3fAqITYz5QtR.jpg"
   }
 */
