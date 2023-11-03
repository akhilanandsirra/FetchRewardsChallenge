//
//  Meal.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 01/11/23.
//

import Foundation


// MARK: - Meals
struct Meals: Codable {
    let meals: [Meal]
}

// MARK: - Meal
struct Meal: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: URL
}
