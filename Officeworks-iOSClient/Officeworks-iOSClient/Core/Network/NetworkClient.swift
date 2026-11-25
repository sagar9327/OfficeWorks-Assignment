//
//  NetworkClient.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

final class NetworkClient: NetworkClientProtocol {

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Initializer

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - API Request

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data? = nil
    ) async throws -> T {

        // Build the complete URL.
        let url = try makeURL(endpoint: endpoint)

        // Create URL request.
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue
        request.httpBody = body

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        do {

            // Execute API request.
            let (data, response) = try await session.data(for: request)

            // Validate HTTP response.
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            // Handle HTTP errors.
            guard (200...299).contains(httpResponse.statusCode) else {

                let errorResponse = try? JSONDecoder().decode(
                    APIErrorResponse.self,
                    from: data
                )

                throw APIError.httpError(
                    statusCode: httpResponse.statusCode,
                    title: errorResponse?.title ?? "Request Failed",
                    message: errorResponse?.message
                        ?? "Something went wrong."
                )
            }

            // Decode successful API response.
            do {

                let apiResponse = try JSONDecoder().decode(
                    APIResponse<T>.self,
                    from: data
                )

                return apiResponse.data

            } catch {

                throw APIError.decodingError(error)
            }

        } catch let error as APIError {

            throw error

        } catch {

            throw APIError.unknown(error)
        }
    }

    // MARK: - URL Construction

    private func makeURL(endpoint: String) throws -> URL {

        // Parse endpoint separately to identify its path and query.
        guard
            let endpointComponents = URLComponents(string: endpoint),
            !endpointComponents.path.isEmpty,
            var urlComponents = URLComponents(
                url: APIConfiguration.baseURL,
                resolvingAgainstBaseURL: false
            )
        else {
            throw APIError.invalidURL
        }

        // Preserve the existing API base path.
        let basePath = urlComponents.percentEncodedPath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        // Remove leading and trailing slashes from endpoint path.
        let endpointPath = endpointComponents.percentEncodedPath
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        // Combine base path and endpoint path.
        let combinedPath = [basePath, endpointPath]
            .filter { !$0.isEmpty }
            .joined(separator: "/")

        urlComponents.percentEncodedPath = "/" + combinedPath

        // Preserve query parameters separately from the path.
        urlComponents.percentEncodedQuery =
            endpointComponents.percentEncodedQuery

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        return url
    }
}
