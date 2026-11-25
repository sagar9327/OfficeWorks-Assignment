//
//  Product.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Double
    let reviews: Int
}

