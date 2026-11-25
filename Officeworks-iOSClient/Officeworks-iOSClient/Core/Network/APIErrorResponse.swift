//
//  APIErrorResponse.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
struct APIErrorResponse: Decodable {
    let success: Bool
    let title: String
    let message: String
}
