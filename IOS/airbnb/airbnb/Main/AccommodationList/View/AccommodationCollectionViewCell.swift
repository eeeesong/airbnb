//
//  AccommodationCollectionViewCell.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import UIKit

final class AccommodationCollectionViewCell: UICollectionViewCell {
    
    private lazy var thumbImageView: UIImageView = {
        let imageWidth = frame.width
        let imageHeight = imageWidth * 0.75
        let imageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        let imageView = UIImageView(frame: imageFrame)
        imageView.backgroundColor = .systemPink
        imageView.layer.cornerRadius = imageWidth * 0.03
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var averageRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "5.0"
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "(후기 199개)"
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = spacing * 0.5
        let star = UIImage(systemName: "star.fill")
        let starImageView = UIImageView(image: star)
        starImageView.tintColor = .red
        [starImageView, averageRatingLabel, reviewCountLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Very Amazing Cool Hotel You Must Not Miss"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "₩800,000"
        return label
    }()
    
    private let spacing: CGFloat = 15
    
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
        addImageView()
        addRatingStackView()
        addTitleLabel()
        addPriceLabel()
    }
    
    private func addImageView() {
        addSubview(thumbImageView)
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            thumbImageView.heightAnchor.constraint(equalTo: thumbImageView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    private func addRatingStackView() {
        addSubview(ratingStackView)
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: spacing),
            ratingStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            ratingStackView.widthAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            ratingStackView.heightAnchor.constraint(equalToConstant: spacing * 1.5)
        ])
    }
    
    private func addTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addPriceLabel() {
        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            priceLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func updateCell(with card: AccommodationCard) {
        averageRatingLabel.text = "\(card.reviewRating)"
        reviewCountLabel.text = "(후기 \(card.reviewCounts)개)"
        titleLabel.text = card.name
        priceLabel.text = "₩\(card.price)"
        
        if let imagePath = card.mainImagePath {
            thumbImageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
    
}
