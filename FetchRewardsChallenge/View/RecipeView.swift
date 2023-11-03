//
//  RecipeView.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 02/11/23.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showingAlert = false
    
    let mealID: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.recipeData[mealID]?.strMeal ?? "No Value")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                AsyncImage(
                    url: viewModel.recipeData[mealID]?.strMealThumb, content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }, placeholder: {
                        Rectangle()
                            .foregroundColor(.secondary)
                    }
                )
                .frame(width: 200, height: 200)
                .cornerRadius(4)
                .padding()
                
                Text("Country of Origin: \(viewModel.recipeData[mealID]?.strArea ?? "No Origin")").padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients & Measurements:")
                        .font(.headline)
                    
                    Text(viewModel.fetchIngredients(for: viewModel.recipeData[mealID]))
                    
                    Spacer()
                    
                    Text("Recipe:")
                        .font(.headline)
                    
                    Text(viewModel.recipeData[mealID]?.strInstructions ?? "No Instructions")
                    
                }
                .frame(maxWidth: .infinity)
                .padding(25)
                
                if let youtubeURL = viewModel.recipeData[mealID]?.strYoutube {
                    Link(destination: youtubeURL, label: {
                        Label("Watch Video", systemImage: "play.rectangle.fill")
                            .font(.system(size: 18).bold())
                            .padding(15)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                    .padding()
                }
                
            }
            .padding()
            .task {
                await viewModel.fetchRecipes(for: mealID)
                showingAlert = viewModel.hasError
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK")) {
                        viewModel.clearError()
                    }
                )
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(mealID: "52928")
    }
}
