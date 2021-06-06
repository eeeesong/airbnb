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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var averageRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var reviewCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let star = UIImage(systemName: "star.fill")
        let starImageView = UIImageView(image: star)
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
        starImageView.tintColor = .red
        starImageView.isHidden = true
        return starImageView
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = spacing * 0.5
        [starImageView, averageRatingLabel, reviewCountLabel].forEach { view in
            stackView.addArrangedSubview(view)
        }
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "           "
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "           "
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
        shimmerOn()
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
            ratingStackView.widthAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
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
            priceLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func updateCell(with card: AccommodationCard) {
        shimmerOff()
        averageRatingLabel.text = "\(card.reviewRating)"
        reviewCountLabel.text = "(후기 \(card.reviewCounts)개)"
        titleLabel.text = card.name
        priceLabel.text = "₩ \(card.price)"
        
        if let imagePath = card.mainImagePath {
            thumbImageView.image = UIImage(contentsOfFile: imagePath)
        } else {
            thumbImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private var gradientLayers = [CALayer]()
    
    private func shimmerOn() {
        let animation = ShimmerFactory.shimmerAnimation()
        let shimmerColor = UIColor(named: "Shimmer")
        let viewsToShimmer = [thumbImageView, ratingStackView, titleLabel, priceLabel]
        
        viewsToShimmer.forEach { view in
            view.backgroundColor = shimmerColor
            let gradient = ShimmerFactory.gradientLayer(frame: view.frame)
            gradientLayers.append(gradient)
            gradient.add(animation, forKey: animation.keyPath)
            view.layer.addSublayer(gradient)
        }
    }
    
    private func shimmerOff() {
        starImageView.isHidden = false
        thumbImageView.layer.cornerRadius = thumbImageView.frame.width * 0.03
        
        let viewsToUnshimmer = [thumbImageView, ratingStackView, titleLabel, priceLabel]
        
        viewsToUnshimmer.forEach { view in
            view.backgroundColor = .white
        }
        
        gradientLayers.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }
    
}
