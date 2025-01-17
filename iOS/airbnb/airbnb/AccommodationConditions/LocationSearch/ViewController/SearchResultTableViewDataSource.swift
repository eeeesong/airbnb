//
//  SearchResultTableViewDataSource.swift
//  airbnb
//
//  Created by Song on 2021/05/24.
//

import UIKit

class SearchResultTableViewDataSource: NSObject, UITableViewDataSource {

    private var searchResults = [Location]()
    
    func updateResults(with searchResults: [Location]) {
        self.searchResults = searchResults
    }
    
    func searchResult(for index: Int) -> Location {
        return searchResults[index]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = SearchResultTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SearchResultTableViewCell ?? SearchResultTableViewCell()
        cell.locationLabel.text = searchResults[indexPath.row].name
        return cell
    }
    
}
