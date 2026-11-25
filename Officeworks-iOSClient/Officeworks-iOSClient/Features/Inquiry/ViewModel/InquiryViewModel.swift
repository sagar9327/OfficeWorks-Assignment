//
//  InquiryViewModel.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//

import Foundation
import Combine

@MainActor
final class InquiryViewModel: ObservableObject {

    // MARK: - Dependencies

    private let productService: ProductServiceProtocol
    private let productID: Int

    // MARK: - Form Properties

    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var message = ""

    // MARK: - State

    @Published private(set) var isSubmitting = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isSubmissionSuccessful = false

    // MARK: - Initializer

    init(
        productID: Int,
        productService: ProductServiceProtocol
    ) {
        self.productID = productID
        self.productService = productService
    }

    // MARK: - Validation

    private func validateForm() -> String? {

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Please enter your name."
        }

        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Please enter your email."
        }

        guard email.contains("@"), email.contains(".") else {
            return "Please enter a valid email address."
        }

        guard !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Please enter your phone number."
        }

        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Please enter your message."
        }

        return nil
    }

    // MARK: - Submit Inquiry

    func submitInquiry() async {

        guard !isSubmitting else { return }

        if let validationError = validateForm() {
            errorMessage = validationError
            return
        }

        errorMessage = nil
        isSubmitting = true

        defer {
            isSubmitting = false
        }

        let request = InquiryRequest(
            productId: productID,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
            message: message.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            try await productService.submitInquiry(request)
            isSubmissionSuccessful = true

        } catch {
            print("Inquiry submission failed:", error)
            errorMessage = error.localizedDescription
        }
    }
}

