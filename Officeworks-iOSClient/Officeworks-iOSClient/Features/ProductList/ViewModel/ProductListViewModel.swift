
//
//  ProductListViewModel.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {

    // MARK: - Dependencies

    private let productService: ProductServiceProtocol

    // MARK: - Search Configuration

    private let minimumSearchLength = 3
    private let debounceDelay: UInt64 = 500_000_000 // 500 milliseconds

    private var searchTask: Task<Void, Never>?
    private var activeRequestID = UUID()

    // MARK: - Published Properties

    @Published private(set) var products: [Product] = []
    @Published private(set) var topRatedProducts: [Product] = []
    @Published private(set) var categories: [String] = []

    @Published var selectedCategory: String? = nil
    @Published var searchText: String = ""

    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Initializer

    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }

    // MARK: - Initial Data

    func fetchInitialData(showLoading: Bool = true) async {

        // Cancel any pending search.
        searchTask?.cancel()

        let requestID = UUID()
        activeRequestID = requestID

        if showLoading {
            isLoading = true
            errorMessage = nil
        }

        defer {
            if activeRequestID == requestID && showLoading {
                isLoading = false
            }
        }

        do {

            async let productsRequest =
                productService.fetchProducts()

            async let topRatedRequest =
                productService.fetchTopRatedProducts()

            async let categoriesRequest =
                productService.fetchCategories()

            let (
                fetchedProducts,
                fetchedTopRatedProducts,
                fetchedCategories
            ) = try await (
                productsRequest,
                topRatedRequest,
                categoriesRequest
            )

            // Ignore results if another operation has started.
            guard activeRequestID == requestID else {
                return
            }

            products = fetchedProducts
            topRatedProducts = fetchedTopRatedProducts
            categories = fetchedCategories

        } catch {

            guard activeRequestID == requestID else {
                return
            }

            print("Product refresh failed:", error)

            if showLoading {
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Category Selection

    func selectCategory(_ category: String?) async {

        // Cancel an ongoing or pending search.
        searchTask?.cancel()

        let requestID = UUID()
        activeRequestID = requestID

        selectedCategory = category
        errorMessage = nil
        isLoading = true

        defer {
            if activeRequestID == requestID {
                isLoading = false
            }
        }

        do {

            let fetchedProducts: [Product]

            if let category {

                fetchedProducts =
                    try await productService.fetchProductsByCategory(category)

            } else {

                fetchedProducts =
                    try await productService.fetchProducts()
            }

            // Only accept the latest operation's result.
            guard activeRequestID == requestID else {
                return
            }

            products = fetchedProducts

        } catch {

            guard activeRequestID == requestID else {
                return
            }

            print("Category loading failed:", error)
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Debounced Search

    func search(for text: String) {

        // Cancel the previous debounce or search operation.
        searchTask?.cancel()

        let searchTerm = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Do not search if fewer than 3 characters are entered.
        guard searchTerm.count >= minimumSearchLength else {

            activeRequestID = UUID()
            isLoading = false
            errorMessage = nil

            return
        }

        // Give this search a unique identifier.
        let requestID = UUID()
        activeRequestID = requestID

        // Start the debounce timer.
        searchTask = Task {

            do {

                try await Task.sleep(
                    nanoseconds: debounceDelay
                )

            } catch {

                // Previous search was cancelled.
                return
            }

            guard
                !Task.isCancelled,
                activeRequestID == requestID
            else {
                return
            }

            // Start showing the product-section loader.
            isLoading = true
            errorMessage = nil

            do {

                let fetchedProducts =
                    try await productService.searchProducts(searchTerm)

                // Ignore outdated responses.
                guard
                    !Task.isCancelled,
                    activeRequestID == requestID
                else {
                    return
                }

                products = fetchedProducts

            } catch {

                guard
                    !Task.isCancelled,
                    activeRequestID == requestID
                else {
                    return
                }

                print("Product search failed:", error)
                errorMessage = error.localizedDescription
            }

            // Only the latest search can stop the loader.
            if activeRequestID == requestID {
                isLoading = false
            }
        }
    }

    // MARK: - Cancel Search

    func cancelSearch() {

        searchTask?.cancel()
        searchTask = nil

        activeRequestID = UUID()
        isLoading = false
        errorMessage = nil
    }
    
    func waitForSearchToComplete() async {
        await searchTask?.value
    }
}

