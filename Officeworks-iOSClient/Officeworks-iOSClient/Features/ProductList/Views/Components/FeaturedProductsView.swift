//
//  FeaturedProductsView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct FeaturedProductsView: View {

    let products: [Product]
    let onProductTap: (Product) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Section Header
            HStack {
                Text("Top Rated Products")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "star.fill")
                    .foregroundStyle(.orange)
            }
            .padding(.horizontal)

            // Horizontal Product List
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {

                    ForEach(products) { product in
                        ProductCardView(product: product) {
                            onProductTap(product)
                        }
                        .frame(width: 170)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
