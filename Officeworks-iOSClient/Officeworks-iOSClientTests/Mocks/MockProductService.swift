//
//  MockProductService.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation
@testable import Officeworks_iOSClient

final class MockProductService: ProductServiceProtocol {
    
    private(set) var submitInquiryCallCount = 0
    private(set) var submittedInquiries: [InquiryRequest] = []
    private(set) var requestedProductIDs: [Int] = []
    
    var products: [Product] = []
    var topRatedProducts: [Product] = []
    var categories: [String] = []
    
    var shouldThrowError = false
    var errorToThrow = NSError(
        domain: "MockProductService",
        code: 500,
        userInfo: [
            NSLocalizedDescriptionKey: "Something went wrong"
        ]
    )
    
    private(set) var fetchProductsCallCount = 0
    private(set) var fetchTopRatedCallCount = 0
    private(set) var fetchCategoriesCallCount = 0
    
    private(set) var selectedCategories: [String] = []
    private(set) var searchTerms: [String] = []
    
    func fetchProducts() async throws -> [Product] {
        fetchProductsCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return products
    }
    
    func fetchTopRatedProducts() async throws -> [Product] {
        fetchTopRatedCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return topRatedProducts
    }
    
    func fetchCategories() async throws -> [String] {
        fetchCategoriesCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return categories
    }
    
    func fetchProductsByCategory(
        _ category: String
    ) async throws -> [Product] {
        selectedCategories.append(category)
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return products
    }
    
    func searchProducts(
        _ searchTerm: String
    ) async throws -> [Product] {
        searchTerms.append(searchTerm)
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return products
    }
    
    func fetchProductDetails(id: Int) async throws -> Product {
        requestedProductIDs.append(id)

        if shouldThrowError {
            throw errorToThrow
        }

        guard let product = products.first(where: { $0.id == id }) else {
            throw errorToThrow
        }
        return product
    }
    
    func submitInquiry(_ request: InquiryRequest) async throws {
        submitInquiryCallCount += 1
        submittedInquiries.append(request)

        if shouldThrowError {
            throw errorToThrow
        }
    }
}
