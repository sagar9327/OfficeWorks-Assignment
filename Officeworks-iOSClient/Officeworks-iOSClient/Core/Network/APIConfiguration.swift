//
//  APIConfiguration.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

enum APIConfiguration {

    static var baseURL: URL {
        guard
            let urlString = Bundle.main.object(
                forInfoDictionaryKey: "API_BASE_URL"
            ) as? String,
            let url = URL(string: urlString)
        else {
            fatalError("API_BASE_URL is missing or invalid")
        }

        return url
    }
}
