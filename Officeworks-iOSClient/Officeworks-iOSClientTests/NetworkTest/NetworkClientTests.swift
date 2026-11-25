//
//  NetworkClientTests.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import XCTest
import Foundation
@testable import Officeworks_iOSClient

final class NetworkClientTests: XCTestCase {

    // MARK: - Test Model

    private struct TestProduct: Decodable, Equatable {
        let id: Int
        let title: String
    }

    // MARK: - Properties

    private var networkClient: NetworkClient!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        networkClient = NetworkClient(session: makeMockSession())
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        networkClient = nil
        super.tearDown()
    }

    // MARK: - Helper

    private func makeMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    private func makeHTTPResponse(
        statusCode: Int,
        url: URL
    ) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
    }

    // MARK: - Success Tests

    func testRequestSuccessfullyDecodesResponse() async throws {

        let expectedProduct = TestProduct(
            id: 1,
            title: "iPhone"
        )

        let json = """
        {
            "success": true,
            "data": {
                "id": 1,
                "title": "iPhone"
            }
        }
        """

        let data = Data(json.utf8)

        MockURLProtocol.requestHandler = { request in

            XCTAssertEqual(
                request.url?.absoluteString,
                APIConfiguration.baseURL
                    .appendingPathComponent("products")
                    .absoluteString
            )

            XCTAssertEqual(request.httpMethod, "GET")

            return (
                self.makeHTTPResponse(
                    statusCode: 200,
                    url: request.url!
                ),
                data
            )
        }

        let product: TestProduct = try await networkClient.request(
            endpoint: "products",
            method: .get,
            body: nil
        )

        XCTAssertEqual(product, expectedProduct)
    }

    func testRequestSuccessfullyHandlesCreatedResponse() async throws {

        let json = """
        {
            "success": true,
            "data": {
                "id": 2,
                "title": "MacBook"
            }
        }
        """

        MockURLProtocol.requestHandler = { request in

            return (
                self.makeHTTPResponse(
                    statusCode: 201,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        let product: TestProduct = try await networkClient.request(
            endpoint: "products",
            method: .post,
            body: nil
        )

        XCTAssertEqual(product.id, 2)
        XCTAssertEqual(product.title, "MacBook")
    }

    // MARK: - HTTP Error Tests

    func testRequestThrowsHTTPError() async {

        let json = """
        {
            "success": false,
            "title": "Bad Request",
            "message": "Invalid product ID"
        }
        """

        MockURLProtocol.requestHandler = { request in

            return (
                self.makeHTTPResponse(
                    statusCode: 400,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products",
                method: .get,
                body: nil
            )

            XCTFail("Expected HTTP error")

        } catch let APIError.httpError(statusCode, title, message) {

            XCTAssertEqual(statusCode, 400)
            XCTAssertEqual(title, "Bad Request")
            XCTAssertEqual(message, "Invalid product ID")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRequestUsesDefaultMessageForInvalidErrorJSON() async {

        MockURLProtocol.requestHandler = { request in

            return (
                self.makeHTTPResponse(
                    statusCode: 500,
                    url: request.url!
                ),
                Data("Invalid JSON".utf8)
            )
        }

        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products",
                method: .get,
                body: nil
            )

            XCTFail("Expected HTTP error")

        } catch let APIError.httpError(statusCode, title, message) {

            XCTAssertEqual(statusCode, 500)
            XCTAssertEqual(title, "Request Failed")
            XCTAssertEqual(message, "Something went wrong.")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Decoding Tests

    func testRequestThrowsDecodingErrorForInvalidSuccessResponse() async {

        let invalidJSON = """
        {
            "success": true,
            "data": {
                "id": "invalid",
                "title": "iPhone"
            }
        }
        """

        MockURLProtocol.requestHandler = { request in

            return (
                self.makeHTTPResponse(
                    statusCode: 200,
                    url: request.url!
                ),
                Data(invalidJSON.utf8)
            )
        }

        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products",
                method: .get,
                body: nil
            )

            XCTFail("Expected decoding error")

        } catch APIError.decodingError {
            XCTAssertTrue(true)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Network Error Tests

    func testRequestThrowsUnknownErrorForNetworkFailure() async {

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products",
                method: .get,
                body: nil
            )

            XCTFail("Expected network error")

        } catch APIError.unknown {
            XCTAssertTrue(true)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - URL Validation Tests

    func testRequestThrowsInvalidURLForEmptyEndpoint() async {

        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "",
                method: .get,
                body: nil
            )

            XCTFail("Expected invalid URL error")

        } catch APIError.invalidURL {
            XCTAssertTrue(true)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestSendsCorrectPOSTBody() async throws {

        // Arrange
        let requestBody = """
        {
            "name": "John",
            "email": "john@example.com"
        }
        """

        let bodyData = Data(requestBody.utf8)

        let responseJSON = """
        {
            "success": true,
            "data": {
                "id": 10,
                "title": "MacBook"
            }
        }
        """

        MockURLProtocol.requestHandler = { request in

            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(self.getRequestBody(from: request), bodyData)

            return (
                self.makeHTTPResponse(
                    statusCode: 201,
                    url: request.url!
                ),
                Data(responseJSON.utf8)
            )
        }

        // Act
        let product: TestProduct = try await networkClient.request(
            endpoint: "products",
            method: .post,
            body: bodyData
        )

        // Assert
        XCTAssertEqual(product.id, 10)
        XCTAssertEqual(product.title, "MacBook")
    }
    
    private func getRequestBody(from request: URLRequest) -> Data? {

        if let httpBody = request.httpBody {
            return httpBody
        }

        guard let stream = request.httpBodyStream else {
            return nil
        }

        stream.open()
        defer { stream.close() }

        var data = Data()
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)

        while stream.hasBytesAvailable {
            let bytesRead = stream.read(&buffer, maxLength: bufferSize)

            if bytesRead <= 0 {
                break
            }

            data.append(buffer, count: bytesRead)
        }

        return data
    }
    
    func testRequestPreservesQueryParameters() async throws {

        // Arrange
        let json = """
        {
            "success": true,
            "data": {
                "id": 1,
                "title": "iPhone"
            }
        }
        """

        MockURLProtocol.requestHandler = { request in

            let components = URLComponents(
                url: request.url!,
                resolvingAgainstBaseURL: false
            )

            XCTAssertEqual(
                components?.path,
                "/api/products/search"
            )

            XCTAssertEqual(
                components?.queryItems?.first(where: {
                    $0.name == "search"
                })?.value,
                "iphone"
            )

            return (
                self.makeHTTPResponse(
                    statusCode: 200,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        // Act
        let product: TestProduct = try await networkClient.request(
            endpoint: "products/search?search=iphone",
            method: .get,
            body: nil
        )

        // Assert
        XCTAssertEqual(product.title, "iPhone")
    }
    
    func testRequestHandlesNotFoundResponse() async {

        // Arrange
        let json = """
        {
            "success": false,
            "title": "Product Not Found",
            "message": "The requested product does not exist."
        }
        """

        MockURLProtocol.requestHandler = { request in
            return (
                self.makeHTTPResponse(
                    statusCode: 404,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        // Act & Assert
        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products/999",
                method: .get,
                body: nil
            )

            XCTFail("Expected HTTP 404 error")

        } catch APIError.httpError(let statusCode, let title, let message) {

            XCTAssertEqual(statusCode, 404)
            XCTAssertEqual(title, "Product Not Found")
            XCTAssertEqual(
                message,
                "The requested product does not exist."
            )

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestHandlesServiceUnavailableResponse() async {

        // Arrange
        let json = """
        {
            "success": false,
            "title": "Service Unavailable",
            "message": "Please try again later."
        }
        """

        MockURLProtocol.requestHandler = { request in
            return (
                self.makeHTTPResponse(
                    statusCode: 503,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        // Act & Assert
        do {
            let _: TestProduct = try await networkClient.request(
                endpoint: "products",
                method: .get,
                body: nil
            )

            XCTFail("Expected HTTP 503 error")

        } catch APIError.httpError(let statusCode, let title, let message) {

            XCTAssertEqual(statusCode, 503)
            XCTAssertEqual(title, "Service Unavailable")
            XCTAssertEqual(message, "Please try again later.")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRequestSendsCorrectHeaders() async throws {

        // Arrange
        let json = """
        {
            "success": true,
            "data": {
                "id": 1,
                "title": "iPhone"
            }
        }
        """

        MockURLProtocol.requestHandler = { request in

            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Content-Type"),
                "application/json"
            )

            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Accept"),
                "application/json"
            )

            return (
                self.makeHTTPResponse(
                    statusCode: 200,
                    url: request.url!
                ),
                Data(json.utf8)
            )
        }

        // Act
        let product: TestProduct = try await networkClient.request(
            endpoint: "products",
            method: .get,
            body: nil
        )

        // Assert
        XCTAssertEqual(product.id, 1)
    }
}

