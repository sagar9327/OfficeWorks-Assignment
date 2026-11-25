//
//  ProductDetailView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import SwiftUI

struct ProductDetailView: View {

    // MARK: - Dependencies

    @StateObject private var viewModel: ProductDetailViewModel

    let onEnquire: (Product) -> Void

    // MARK: - Initializer

    init(
        viewModel: ProductDetailViewModel,
        onEnquire: @escaping (Product) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onEnquire = onEnquire
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.isLoading {
                    ProgressView("Loading product...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)

                } else if let product = viewModel.product {
                    productContent(product)

                } else {
                    ProgressView("Preparing product details...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchProductDetails()
        }
    }

    // MARK: - Product Content

    private func productContent(_ product: Product) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Product Image
                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()

                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)

                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .padding()

                // Product Information
                VStack(alignment: .leading, spacing: 12) {

                    Text(product.category.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)

                    // Rating
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.orange)

                        Text(String(format: "%.1f", product.rating))
                            .fontWeight(.semibold)

                        Text("(\(product.reviews) reviews)")
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    Text("Description")
                        .font(.headline)

                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)

                // Enquire Button
                Button {
                    onEnquire(product)
                } label: {
                    Text("Enquire Now")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Error View

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await viewModel.fetchProductDetails()
                }
            }
        }
        .padding()
    }
}

