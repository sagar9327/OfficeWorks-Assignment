//
//  ProductCardView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct ProductCardView: View {

    let product: Product
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {

                // Product Image
                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)

                    default:
                        ProgressView()
                    }
                }
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .padding(8)

                // Product Title
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Price
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundStyle(.primary)

                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)

                    Text(String(format: "%.1f", product.rating))
                        .foregroundStyle(.secondary)

                    Text("(\(product.reviews))")
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

