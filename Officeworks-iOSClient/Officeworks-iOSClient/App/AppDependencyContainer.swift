//
//  AppDependencyContainer.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation

@MainActor
final class AppDependencyContainer {

    // MARK: - Shared Dependencies

    let networkClient: NetworkClientProtocol

    // MARK: - Services

    let productService: ProductServiceProtocol

    // MARK: - Coordinators

    let appCoordinator: AppCoordinator

    // MARK: - Initializer

    init() {

        let networkClient = NetworkClient()

        self.networkClient = networkClient

        self.productService = ProductService(
            networkClient: networkClient
        )

        self.appCoordinator = AppCoordinator()
    }

    // MARK: - ViewModels

    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(
            productService: productService
        )
    }
    
    func makeProductDetailViewModel(
        productID: Int
    ) -> ProductDetailViewModel {
        ProductDetailViewModel(
            productID: productID,
            productService: productService
        )
    }
    
    func makeInquiryViewModel(productID: Int) -> InquiryViewModel {
        InquiryViewModel(
            productID: productID,
            productService: productService
        )
    }
}

