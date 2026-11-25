//
//  ProductDetailViewModelTests.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import XCTest
@testable import Officeworks_iOSClient

@MainActor
final class ProductDetailViewModelTests: XCTestCase {

    private var mockService: MockProductService!
    private var sut: ProductDetailViewModel!

    override func setUp() {
        super.setUp()

        mockService = MockProductService()

        sut = ProductDetailViewModel(
            productID: 101,
            productService: mockService
        )
    }

    override func tearDown() {
        sut = nil
        mockService = nil

        super.tearDown()
    }

    // MARK: - Test Data

    private func makeProduct() -> Product {
        Product(
            id: 101,
            title: "iPhone",
            price: 999,
            description: "Test product description",
            category: "electronics",
            image: "https://example.com/image.png",
            rating: 4.5,
            reviews: 100
        )
    }

    // MARK: - Fetch Product Tests

    func testFetchProductDetailsSuccessfully() async {

        // Arrange
        let expectedProduct = makeProduct()
        mockService.products = [expectedProduct]

        // Act
        await sut.fetchProductDetails()

        // Assert
        XCTAssertNotNil(sut.product)
        XCTAssertEqual(sut.product?.id, 101)
        XCTAssertEqual(sut.product?.title, "iPhone")

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func testFetchProductDetailsFailure() async {

        // Arrange
        mockService.shouldThrowError = true

        // Act
        await sut.fetchProductDetails()

        // Assert
        XCTAssertNil(sut.product)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func testFetchProductDetailsRequestsCorrectProductID() async {

        // Arrange
        mockService.products = [makeProduct()]

        // Act
        await sut.fetchProductDetails()

        // Assert
        XCTAssertEqual(mockService.requestedProductIDs, [101])
    }

    func testFetchProductDetailsClearsPreviousError() async {

        // Arrange
        mockService.shouldThrowError = true

        await sut.fetchProductDetails()

        XCTAssertNotNil(sut.errorMessage)

        // Act
        mockService.shouldThrowError = false
        mockService.products = [makeProduct()]

        await sut.fetchProductDetails()

        // Assert
        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.product)
    }
}

