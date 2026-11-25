//
//  APIError.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(
        statusCode: Int,
        title: String,
        message: String
    )
    case decodingError(Error)
    case unknown(Error)
}
