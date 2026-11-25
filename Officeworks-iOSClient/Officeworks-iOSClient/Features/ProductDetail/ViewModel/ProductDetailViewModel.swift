//
//  ProductDetailViewModel.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {

    // MARK: - Dependencies

    private let productService: ProductServiceProtocol

    // MARK: - Properties

    private let productID: Int

    // MARK: - Published Properties

    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Initializer

    init(
        productID: Int,
        productService: ProductServiceProtocol
    ) {
        self.productID = productID
        self.productService = productService
    }

    // MARK: - Fetch Product Details

    func fetchProductDetails() async {

        print("Fetching product ID:", productID)

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let fetchedProduct = try await productService.fetchProductDetails(
                id: productID
            )

            print("Product fetched:", fetchedProduct.title)

            product = fetchedProduct

        } catch {
            print("Product Detail API Error:", error)
            errorMessage = error.localizedDescription
        }
    }
}

