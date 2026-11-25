//
//  AppCoordinator.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    // MARK: - Navigation

    func showProductDetail(productID: Int) {
        path.append(
            AppRoute.productDetail(productID: productID)
        )
    }

    func showInquiry(productID: Int) {
        path.append(
            AppRoute.inquiry(productID: productID)
        )
    }

    func showInquirySuccess() {
        path.append(AppRoute.inquirySuccess)
    }

    // MARK: - Navigation Control

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

