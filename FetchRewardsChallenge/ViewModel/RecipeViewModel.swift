//
//  RecipeViewModel.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 01/11/23.
//

import Foundation

@MainActor
final class RecipeViewModel: ObservableObject {
    private let networkingManager: GenericAPI
    private let recipeURL = "https://themealdb.com/api/json/v1/1/lookup.php?i="
    
    @Published private(set) var recipeData = [String: Recipe]()
    @Published private(set) var errorMessage: String = ""
    @Published var hasError: Bool = false
    
    init(networkingManager: GenericAPI) {
        self.networkingManager = networkingManager
    }
    
    convenience init() {
        self.init(networkingManager: NetworkingManager())
    }
    
    func fetchRecipes(for mealID: String) async {
        do {
            let response = try await networkingManager.getData(for: Recipes.self, endpoint: recipeURL + mealID)
            recipeData[mealID] = response.meals.first
        } catch let error {
            print("Error: \(error.localizedDescription)")
            
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchIngredients(for recipe: Recipe?) -> String {
        guard let recipe = recipe else {
            return "No Ingredients"
        }
        
        var result = ""
        
        let mirror = Mirror(reflecting: recipe)
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if let ingredient = mirror.children.first(where: { $0.label == ingredientKey })?.value as? String,
               let measure = mirror.children.first(where: { $0.label == measureKey })?.value as? String,
               !ingredient.isEmpty && !measure.isEmpty {
                let formattedIngredient = "\(ingredient) - \(measure)"
                result += "\n\(formattedIngredient)"
            } else {
                // Exit the loop if either ingredient or measure is empty
                break
            }
        }
        
        return result
    }
    
    func clearError() {
        hasError = false
        errorMessage = ""
    }
}
