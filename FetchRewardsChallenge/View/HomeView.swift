//
//  HomeView.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 01/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemFill).ignoresSafeArea()
                MealListView()
                .navigationTitle("Desserts")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // To avoid sidebar on iPad
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
