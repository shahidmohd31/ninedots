//
//  ViewModel.swift
//  ninedot
//
//  Created by mohd shahid on 25/08/24.
//

import Foundation
import UIKit

class ViewModel {
    private(set) var categories: [Category] = []
    private(set) var filteredFruits: [String] = []
    private(set) var selectedCategory: Category?

    var onCategoriesUpdated: (() -> Void)?
    var onFilteredFruitsUpdated: (() -> Void)?

    func loadData() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("Error: Could not find data.json file.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dataModel = try JSONDecoder().decode(DataModel.self, from: data)
            categories = dataModel.categories
            selectedCategory = categories.first
            updateFilteredFruits()
            onCategoriesUpdated?()
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }

    func updateFilteredFruits(with searchText: String = "") {
        if let selectedCategory = selectedCategory {
            filteredFruits = searchText.isEmpty ? selectedCategory.fruits : selectedCategory.fruits.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
            print("Filtered fruits updated: \(filteredFruits)")
            onFilteredFruitsUpdated?()
        }
    }

    func selectCategory(_ category: Category) {
        selectedCategory = category
        updateFilteredFruits()
    }
}
