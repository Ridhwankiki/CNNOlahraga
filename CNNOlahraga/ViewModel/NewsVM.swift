//
//  NewsVM.swift
//  CNNOlahraga
//
//  Created by MacBook Pro on 23/04/24.
//

import Foundation

@MainActor
class NewsVM: ObservableObject {
    @Published var articles = [NewsArticle]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchNews() async {
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false}
        
        do {
            articles = try await APIService.shared.fetchNews()
//            isLoading = false
        } catch {
            errorMessage = "🔥 \(error.localizedDescription). Failed to fetch News from API!!! 🔥"
            print(errorMessage ?? "N/A")
//            isLoading = false
        }
    }
}
