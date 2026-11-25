//
//  ProductService.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

final class ProductService: ProductServiceProtocol {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch All Products

    func fetchProducts() async throws -> [Product] {
        return try await networkClient.request(
            endpoint: "products",
            method: .get,
            body: nil
        )
    }

    // MARK: - Fetch Top Rated Products

    func fetchTopRatedProducts() async throws -> [Product] {
        return try await networkClient.request(
            endpoint: "products/top-rated",
            method: .get,
            body: nil
        )
    }

    // MARK: - Fetch Categories

    func fetchCategories() async throws -> [String] {
        return try await networkClient.request(
            endpoint: "products/categories",
            method: .get,
            body: nil
        )
    }

    // MARK: - Fetch Products By Category

    func fetchProductsByCategory(
        _ category: String
    ) async throws -> [Product] {

        let encodedCategory = category.addingPercentEncoding(
            withAllowedCharacters: .urlPathAllowed
        ) ?? category

        return try await networkClient.request(
            endpoint: "products/category/\(encodedCategory)",
            method: .get,
            body: nil
        )
    }

    // MARK: - Search Products

    func searchProducts(
        _ searchTerm: String
    ) async throws -> [Product] {

        var components = URLComponents()
        components.path = "/products/search"
        components.queryItems = [
            URLQueryItem(name: "search", value: searchTerm)
        ]

        guard let endpoint = components.string else {
            throw APIError.invalidURL
        }

        return try await networkClient.request(
            endpoint: String(endpoint.dropFirst()),
            method: .get,
            body: nil
        )
    }

    // MARK: - Fetch Product Details

    func fetchProductDetails(id: Int) async throws -> Product {
        return try await networkClient.request(
            endpoint: "products/\(id)",
            method: .get,
            body: nil
        )
    }
    
    func submitInquiry(_ request: InquiryRequest) async throws {

        let body = try JSONEncoder().encode(request)

        let _: EmptyResponse = try await networkClient.request(
            endpoint: "enquiries",
            method: .post,
            body: body
        )
    }
}
