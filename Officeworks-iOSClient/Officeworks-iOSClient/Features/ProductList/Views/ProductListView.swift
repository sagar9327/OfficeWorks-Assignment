
//
//  ProductListView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct ProductListView: View {

    // MARK: - Dependencies

    private let dependencyContainer: AppDependencyContainer

    @StateObject private var viewModel: ProductListViewModel
    @ObservedObject private var coordinator: AppCoordinator

    // MARK: - Screen State

    @State private var hasSelectedCategory = false
    @State private var hasCompletedInitialLoad = false
    @State private var hasSubmittedSearch = false

    // MARK: - Initializer

    init(
        dependencyContainer: AppDependencyContainer,
        coordinator: AppCoordinator
    ) {
        self.dependencyContainer = dependencyContainer

        _viewModel = StateObject(
            wrappedValue: dependencyContainer.makeProductListViewModel()
        )

        _coordinator = ObservedObject(
            wrappedValue: coordinator
        )
    }

    // MARK: - Computed Properties

    private var isSearching: Bool {
        hasSubmittedSearch
    }

    private var categoryTitle: String {
        viewModel.selectedCategory?.capitalized ?? "All Products"
    }

    // MARK: - Body

    var body: some View {

        NavigationStack(path: $coordinator.path) {

            Group {

                if !hasCompletedInitialLoad {

                    loadingView

                } else {

                    mainContent
                }
            }
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.large)

            // MARK: - Navigation Destinations

            .navigationDestination(for: AppRoute.self) { route in

                switch route {

                case .productDetail(let productID):

                    ProductDetailView(
                        viewModel: dependencyContainer
                            .makeProductDetailViewModel(
                                productID: productID
                            ),
                        onEnquire: { product in
                            coordinator.showInquiry(
                                productID: product.id
                            )
                        }
                    )

                case .inquiry(let productID):

                    InquiryView(
                        viewModel: dependencyContainer
                            .makeInquiryViewModel(
                                productID: productID
                            ),
                        onSuccess: {
                            coordinator.showInquirySuccess()
                        }
                    )

                case .inquirySuccess:

                    InquirySuccessView {
                        coordinator.popToRoot()
                    }
                }
            }

            // MARK: - Initial API Call

            .task {

                guard !hasCompletedInitialLoad else {
                    return
                }

                await viewModel.fetchInitialData(showLoading: true)

                hasCompletedInitialLoad = true
            }

            // MARK: - Search Text Observation

            .onChange(of: viewModel.searchText) { _, newValue in

                handleSearchTextChange(newValue)
            }

            // MARK: - Refresh When Returning From Detail

            .onChange(of: coordinator.path.count) { oldValue, newValue in

                if oldValue > 0 && newValue == 0 {

                    Task {
                        await refreshProductsInBackground()
                    }
                }
            }
        }
    }

    // MARK: - Main Content

    private var mainContent: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                searchBar

                categorySelector

                if viewModel.isLoading {

                    loadingView

                } else if let errorMessage = viewModel.errorMessage {

                    errorView(errorMessage)

                } else if isSearching {

                    searchResultsSection

                } else if hasSelectedCategory {

                    categoryProductsSection

                } else {

                    topRatedSection
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: - Search Handling

    private func handleSearchTextChange(_ text: String) {

        let searchTerm = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Search only when minimum 3 characters are entered.
        guard searchTerm.count >= 3 else {

            // Restore previous screen only when leaving search mode.
            if hasSubmittedSearch {

                hasSubmittedSearch = false
                viewModel.cancelSearch()

                if hasSelectedCategory {

                    Task {
                        await viewModel.selectCategory(
                            viewModel.selectedCategory
                        )
                    }
                }
            }

            return
        }

        hasSubmittedSearch = true

        // ViewModel handles debounce and request cancellation.
        viewModel.search(for: searchTerm)
    }

    // MARK: - Background Refresh

    private func refreshProductsInBackground() async {

        // Refresh products, top-rated products and categories.
        await viewModel.fetchInitialData(showLoading: false)

        // Refresh the currently selected category if required.
        if !isSearching && hasSelectedCategory {

            await viewModel.selectCategory(
                viewModel.selectedCategory
            )
        }

        // Refresh current search results if the user
        // returns while search mode is active.
        if isSearching {

            viewModel.search(for: viewModel.searchText)
        }
    }

    // MARK: - Top Rated Products

    private var topRatedSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Top Rated Products")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            if viewModel.topRatedProducts.isEmpty {

                emptyView

            } else {

                ProductGridView(
                    products: viewModel.topRatedProducts,
                    onProductTap: openProduct
                )
            }
        }
    }

    // MARK: - Category Products

    private var categoryProductsSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(categoryTitle)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            if viewModel.products.isEmpty {

                emptyView

            } else {

                ProductGridView(
                    products: viewModel.products,
                    onProductTap: openProduct
                )
            }
        }
    }

    // MARK: - Search Results

    private var searchResultsSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Search Results")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            if viewModel.products.isEmpty {

                emptyView

            } else {

                ProductGridView(
                    products: viewModel.products,
                    onProductTap: openProduct
                )
            }
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {

        VStack(spacing: 12) {

            ProgressView()

            Text("Loading products...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 300)
    }

    // MARK: - Search Bar

    private var searchBar: some View {

        HStack {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search products..",
                text: $viewModel.searchText
            )
            .submitLabel(.search)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {

                Button {

                    viewModel.searchText = ""

                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    // MARK: - Category Selector

    private var categorySelector: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                categoryButton(
                    title: "All",
                    category: nil
                )

                ForEach(viewModel.categories, id: \.self) { category in

                    categoryButton(
                        title: category.capitalized,
                        category: category
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    private func categoryButton(
        title: String,
        category: String?
    ) -> some View {

        let isSelected = hasSelectedCategory &&
            viewModel.selectedCategory == category

        return Button {

            guard !viewModel.isLoading else {
                return
            }

            // Reset search state.
            hasSubmittedSearch = false
            viewModel.searchText = ""
            viewModel.cancelSearch()

            // Mark explicit category selection.
            hasSelectedCategory = true

            Task {
                await viewModel.selectCategory(category)
            }

        } label: {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(
                    isSelected
                        ? Color.accentColor
                        : Color(.secondarySystemBackground)
                )
                .foregroundStyle(
                    isSelected ? .white : .primary
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private var emptyView: some View {

        VStack(spacing: 12) {

            Image(systemName: "shippingbox")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("No products found")
                .font(.headline)

            Text("Try another search or category.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }

    // MARK: - Error State

    private func errorView(_ message: String) -> some View {

        VStack(spacing: 12) {

            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundStyle(.orange)

            Text(message)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)

            Button("Try Again") {

                Task {

                    if isSearching {

                        viewModel.search(for: viewModel.searchText)

                    } else if hasSelectedCategory {

                        await viewModel.selectCategory(
                            viewModel.selectedCategory
                        )

                    } else {

                        await viewModel.fetchInitialData(
                            showLoading: false
                        )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    // MARK: - Navigation

    private func openProduct(_ product: Product) {

        coordinator.showProductDetail(
            productID: product.id
        )
    }
}


