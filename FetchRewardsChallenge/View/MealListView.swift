//
//  MealListView.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 02/11/23.
//

import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        List(viewModel.mealsData, id: \.idMeal) { meal in
            NavigationLink(destination: RecipeView(mealID: meal.idMeal)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        AsyncImage(
                            url: meal.strMealThumb, content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }, placeholder: {
                                Rectangle()
                                    .foregroundColor(.secondary)
                            }
                        )
                        .frame(width: 70, height: 70)
                        .cornerRadius(4)
                        .padding()
                        
                        Text(meal.strMeal)
                            .font(.headline)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .background(.clear)
                    .foregroundColor(Color(.systemBackground))
                
                    .padding(
                        EdgeInsets(
                            top: 5,
                            leading: 10,
                            bottom: 5,
                            trailing: 10
                        )
                    )
            )
        }
        .listStyle(.plain)
        .task {
            await viewModel.fetchMeals()
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

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
