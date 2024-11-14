//
//  ProductModel.swift
//  PruebaLiverpool
//
//  Created by MacBook Pro 2015 on 14/11/24.
//

import Foundation

struct Product: Identifiable, Codable {
    var id: String { productId }
    var productId: String
    var productDisplayName: String
    var listPrice: Double
    var promoPrice: Double?
    var smImage: String
    var variantsColor: [ColorVariant]
    
    var displayPrice: String {
        if let promoPrice = promoPrice, promoPrice < listPrice {
            return "$\(promoPrice)"
        } else {
            return "$\(listPrice)"
        }
    }
    
    var displayColor: String {
        return (promoPrice != nil && promoPrice! < listPrice) ? "red" : "black"
    }
}

struct ColorVariant: Codable {
    var colorName: String
}

struct ProductResponse: Codable {
    var plpResults: PLPResults
}

struct PLPResults: Codable {
    var records: [Product]
}

enum SortOption: String, CaseIterable {
    case predefined = "predefined"
    case lowestPrice = "lowestPrice"
    case highestPrice = "highestPrice"
    case relevance = "relevance"
    case newest = "newest"
    case ratings = "ratings"
    
    var displayName: String {
        switch self {
        case .predefined: return "Predeterminado"
        case .lowestPrice: return "Menor precio"
        case .highestPrice: return "Mayor precio"
        case .relevance: return "Relevancia"
        case .newest: return "Lo más nuevo"
        case .ratings: return "Calificaciones"
        }
    }
}


