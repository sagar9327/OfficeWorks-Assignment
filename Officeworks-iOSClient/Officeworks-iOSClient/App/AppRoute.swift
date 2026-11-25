//
//  AppRoute.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//


import Foundation

enum AppRoute: Hashable {
    case productDetail(productID: Int)
    case inquiry(productID: Int)
    case inquirySuccess
}
