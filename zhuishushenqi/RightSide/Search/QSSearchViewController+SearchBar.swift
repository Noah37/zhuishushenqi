//
//  QSSearchViewController+SearchBar.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/12.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

extension QSSearchViewController:UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate {
    //MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        self.presenter?.interactor.updateHistoryList(history: searchBar.text ?? "")
        self.presenter?.interactor.fetchBooks(key: searchBar.text ?? "")
    }// called when keyboard search button pressed
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar){
        
    }// called when bookmark button pressed
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
    }// called when cancel button pressed
    
    //MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController){
        showSearching()
    }
    
    func didPresentSearchController(_ searchController: UISearchController){

    }
    
    func willDismissSearchController(_ searchController: UISearchController){
        showHistory()
    }
    
    func didDismissSearchController(_ searchController: UISearchController){
        
    }
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController){
        let text = searchController.searchBar.text ?? ""
        if !text.isEmpty {
            presenter?.interactor.autoComplete(key: text)
        }
    }
}
