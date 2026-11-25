//
//  InquiryViewModelTests.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import XCTest
@testable import Officeworks_iOSClient

@MainActor
final class InquiryViewModelTests: XCTestCase {

    private var mockService: MockProductService!
    private var sut: InquiryViewModel!

    override func setUp() {
        super.setUp()

        mockService = MockProductService()

        sut = InquiryViewModel(
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

    private func enterValidFormDetails() {
        sut.name = "John"
        sut.email = "john@example.com"
        sut.phone = "9876543210"
        sut.message = "I am interested in this product."
    }

    // MARK: - Validation Tests

    func testSubmitInquiryWithEmptyName() async {

        // Arrange
        sut.email = "john@example.com"
        sut.phone = "9876543210"
        sut.message = "Interested in this product."

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(
            sut.errorMessage,
            "Please enter your name."
        )

        XCTAssertEqual(mockService.submitInquiryCallCount, 0)
        XCTAssertFalse(sut.isSubmissionSuccessful)
    }

    func testSubmitInquiryWithEmptyEmail() async {

        // Arrange
        sut.name = "John"
        sut.phone = "9876543210"
        sut.message = "Interested in this product."

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(
            sut.errorMessage,
            "Please enter your email."
        )

        XCTAssertEqual(mockService.submitInquiryCallCount, 0)
    }

    func testSubmitInquiryWithInvalidEmail() async {

        // Arrange
        sut.name = "John"
        sut.email = "johnexample.com"
        sut.phone = "9876543210"
        sut.message = "Interested in this product."

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(
            sut.errorMessage,
            "Please enter a valid email address."
        )

        XCTAssertEqual(mockService.submitInquiryCallCount, 0)
    }

    func testSubmitInquiryWithEmptyPhone() async {

        // Arrange
        sut.name = "John"
        sut.email = "john@example.com"
        sut.message = "Interested in this product."

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(
            sut.errorMessage,
            "Please enter your phone number."
        )

        XCTAssertEqual(mockService.submitInquiryCallCount, 0)
    }

    func testSubmitInquiryWithEmptyMessage() async {

        // Arrange
        sut.name = "John"
        sut.email = "john@example.com"
        sut.phone = "9876543210"

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(
            sut.errorMessage,
            "Please enter your message."
        )

        XCTAssertEqual(mockService.submitInquiryCallCount, 0)
    }

    // MARK: - Submission Tests

    func testSubmitInquirySuccessfully() async {

        // Arrange
        enterValidFormDetails()

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertTrue(sut.isSubmissionSuccessful)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isSubmitting)

        XCTAssertEqual(mockService.submitInquiryCallCount, 1)
    }

    func testSubmitInquirySendsCorrectRequest() async {

        // Arrange
        enterValidFormDetails()

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertEqual(mockService.submittedInquiries.count, 1)

        let request = mockService.submittedInquiries[0]

        XCTAssertEqual(request.productId, 101)
        XCTAssertEqual(request.name, "John")
        XCTAssertEqual(request.email, "john@example.com")
        XCTAssertEqual(request.phone, "9876543210")
        XCTAssertEqual(
            request.message,
            "I am interested in this product."
        )
    }

    func testSubmitInquiryTrimsWhitespace() async {

        // Arrange
        sut.name = "  John  "
        sut.email = "  john@example.com  "
        sut.phone = "  9876543210  "
        sut.message = "  Interested in this product.  "

        // Act
        await sut.submitInquiry()

        // Assert
        let request = mockService.submittedInquiries[0]

        XCTAssertEqual(request.name, "John")
        XCTAssertEqual(request.email, "john@example.com")
        XCTAssertEqual(request.phone, "9876543210")
        XCTAssertEqual(
            request.message,
            "Interested in this product."
        )
    }

    func testSubmitInquiryFailure() async {

        // Arrange
        enterValidFormDetails()
        mockService.shouldThrowError = true

        // Act
        await sut.submitInquiry()

        // Assert
        XCTAssertFalse(sut.isSubmissionSuccessful)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isSubmitting)

        XCTAssertEqual(mockService.submitInquiryCallCount, 1)
    }
}

