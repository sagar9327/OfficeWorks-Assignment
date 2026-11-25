//
//  APIResponse.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
}
