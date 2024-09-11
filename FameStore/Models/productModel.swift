//
//  productModel.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import Foundation

struct productModel: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let category: String
    let image: String
    let description: String
}

enum productError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

// Category Model
struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let creationAt: String
    let updatedAt: String
}


// API'den Ürünleri Çekme Fonksiyonu
func getAllProducts() async throws -> [productModel] {
    let apiUrl = "https://fakestoreapi.com/products"
    
    guard let url = URL(string: apiUrl) else {
        throw productError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw productError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([productModel].self, from: data) // Listeyi decode ediyoruz
    } catch {
        throw productError.invalidData
    }
}




// GET CATEGORIES

  func getAllCategories() async throws -> [String] {
    let apiUrl = "https://fakestoreapi.com/products/categories"
    
    guard let url = URL(string: apiUrl) else {
        throw productError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw productError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String].self, from: data)
    } catch {
        throw productError.invalidData
    }
    
}

