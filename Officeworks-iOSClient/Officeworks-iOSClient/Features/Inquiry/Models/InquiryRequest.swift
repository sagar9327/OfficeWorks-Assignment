//
//  InquiryRequest.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

struct InquiryRequest: Encodable {
    let productId: Int
    let name: String
    let email: String
    let phone: String
    let message: String
}

