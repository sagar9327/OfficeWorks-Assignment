//
//  ProductGridView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct ProductGridView: View {

    let products: [Product]
    let onProductTap: (Product) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: 16
        ) {
            ForEach(products) { product in
                ProductCardView(product: product) {
                    onProductTap(product)
                }
            }
        }
        .padding(.horizontal)
    }
}

