//
//  Sport.swift
//  CNNOlahraga
//
//  Created by MacBook Pro on 23/04/24.
//

import Foundation

// MARK: - Welcome
struct News: Codable {
    let message: String
    let total: Int
    let data: [NewsArticle]
}

// MARK: - Datum
struct NewsArticle: Codable, Identifiable {
    var id: String { link }
    let title: String
    let link: String
    let contentSnippet, isoDate: String
    let image: Image
}

// MARK: - Image
struct Image: Codable {
    let small, large: String
}
