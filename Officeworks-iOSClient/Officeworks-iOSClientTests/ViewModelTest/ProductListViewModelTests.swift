//
//  ProductListViewModelTests.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import XCTest
@testable import Officeworks_iOSClient

@MainActor
final class ProductListViewModelTests: XCTestCase {

    private var mockService: MockProductService!
    private var sut: ProductListViewModel!

    override func setUp() {
        super.setUp()

        mockService = MockProductService()
        sut = ProductListViewModel(productService: mockService)
    }

    override func tearDown() {
        sut = nil
        mockService = nil

        super.tearDown()
    }

    // MARK: - Test Data

    private func makeProduct(
        id: Int = 1,
        title: String = "iPhone",
        rating: Double = 4.5
    ) -> Product {
        Product(
            id: id,
            title: title,
            price: 999,
            description: "Test product",
            category: "electronics",
            image: "https://example.com/image.png",
            rating: rating,
            reviews: 100
        )
    }

    // MARK: - Initial Loading Tests

    func testFetchInitialDataSuccessfully() async {

        // Arrange
        let products = [
            makeProduct(id: 1),
            makeProduct(id: 2, title: "MacBook")
        ]

        let topRatedProducts = [
            makeProduct(id: 1, rating: 4.9)
        ]

        mockService.products = products
        mockService.topRatedProducts = topRatedProducts
        mockService.categories = ["electronics", "jewelery"]

        // Act
        await sut.fetchInitialData()

        // Assert
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(sut.topRatedProducts.count, 1)
        XCTAssertEqual(sut.categories.count, 2)

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)

        XCTAssertEqual(mockService.fetchProductsCallCount, 1)
        XCTAssertEqual(mockService.fetchTopRatedCallCount, 1)
        XCTAssertEqual(mockService.fetchCategoriesCallCount, 1)
    }

    func testFetchInitialDataFailure() async {

        // Arrange
        mockService.shouldThrowError = true

        // Act
        await sut.fetchInitialData()

        // Assert
        XCTAssertTrue(sut.products.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
    }

    // MARK: - Category Tests

    func testSelectCategorySuccessfully() async {

        // Arrange
        let products = [
            makeProduct(id: 1, title: "Laptop")
        ]

        mockService.products = products

        // Act
        await sut.selectCategory("electronics")

        // Assert
        XCTAssertEqual(sut.selectedCategory, "electronics")
        XCTAssertEqual(sut.products.count, 1)

        XCTAssertEqual(
            mockService.selectedCategories,
            ["electronics"]
        )

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testSelectAllProductsSuccessfully() async {

        // Arrange
        mockService.products = [
            makeProduct(id: 1),
            makeProduct(id: 2)
        ]

        // Act
        await sut.selectCategory(nil)

        // Assert
        XCTAssertNil(sut.selectedCategory)
        XCTAssertEqual(sut.products.count, 2)
        XCTAssertEqual(mockService.fetchProductsCallCount, 1)
    }

    func testSelectCategoryFailure() async {

        // Arrange
        mockService.shouldThrowError = true

        // Act
        await sut.selectCategory("electronics")

        // Assert
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Search Tests

    func testSearchWithLessThanThreeCharactersDoesNotCallAPI() async {

        // Act
        sut.search(for: "ip")

        // Assert
        XCTAssertTrue(mockService.searchTerms.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testSearchWithThreeOrMoreCharactersCallsAPI() async {

        // Arrange
        mockService.products = [
            makeProduct(id: 1, title: "iPhone")
        ]

        // Act
        sut.search(for: "iphone")

        // Wait for actual search completion
        await sut.waitForSearchToComplete()

        // Assert
        XCTAssertEqual(mockService.searchTerms, ["iphone"])
        XCTAssertEqual(sut.products.count, 1)
        XCTAssertEqual(sut.products.first?.title, "iPhone")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testSearchFailure() async throws {

        // Arrange
        mockService.shouldThrowError = true

        // Act
        sut.search(for: "iphone")

        try await Task.sleep(nanoseconds: 700_000_000)

        // Assert
        XCTAssertEqual(mockService.searchTerms, ["iphone"])
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
}

