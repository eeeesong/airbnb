//
//  AccommodationCollectionViewDataSource.swift
//  airbnb
//
//  Created by Song on 2021/06/02.
//

import UIKit

final class AccommodationCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var accommodations = [AccommodationCard]()
    
    func updateInfos(with accommodations: [AccommodationCard]) {
        self.accommodations = accommodations
    }
    
    func updateCachePath(with cachePath: String, for index: Int) {
        accommodations[index].mainImagePath = cachePath
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accommodations.count > 0 ? accommodations.count : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = AccommodationCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AccommodationCollectionViewCell ?? AccommodationCollectionViewCell()
        guard !accommodations.isEmpty else { return cell }
        let cellInfo = accommodations[indexPath.row]
        cell.updateCell(with: cellInfo)
        return cell
    }

}
