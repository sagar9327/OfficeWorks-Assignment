//
//  ProductServiceProtocol.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation

protocol ProductServiceProtocol {

    func fetchProducts() async throws -> [Product]

    func fetchTopRatedProducts() async throws -> [Product]

    func fetchCategories() async throws -> [String]

    func fetchProductsByCategory(
        _ category: String
    ) async throws -> [Product]

    func searchProducts(
        _ searchTerm: String
    ) async throws -> [Product]

    func fetchProductDetails(
        id: Int
    ) async throws -> Product
    
    func submitInquiry(_ request: InquiryRequest) async throws
}

