//
//  MealListViewModel.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 01/11/23.
//

import Foundation

@MainActor
final class MealListViewModel: ObservableObject {
    private let networkingManager: GenericAPI
    private let mealsURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    @Published private(set) var mealsData = [Meal]()
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    
    init(networkingManager: GenericAPI) {
        self.networkingManager = networkingManager
    }
    
    convenience init() {
        self.init(networkingManager: NetworkingManager())
    }
    
    func fetchMeals() async {
        do {
            let response = try await networkingManager.getData(for: Meals.self, endpoint: mealsURL)
            mealsData = response.meals
        } catch let error {
            print("Error: \(error.localizedDescription)")
            
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        hasError = false
        errorMessage = ""
    }
}
