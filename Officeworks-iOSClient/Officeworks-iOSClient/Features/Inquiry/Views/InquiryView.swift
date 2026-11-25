//
//  InquiryView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct InquiryView: View {

    @StateObject private var viewModel: InquiryViewModel
    @State private var showErrorAlert = false

    let onSuccess: () -> Void

    init(
        viewModel: InquiryViewModel,
        onSuccess: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSuccess = onSuccess
    }

    var body: some View {
        Form {

            // MARK: - Contact Information

            Section("Contact Information") {

                TextField("Full Name", text: $viewModel.name)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)

                TextField("Email Address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                TextField("Phone Number", text: $viewModel.phone)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }

            // MARK: - Message

            Section("Your Message") {

                TextEditor(text: $viewModel.message)
                    .frame(minHeight: 120)
            }

            // MARK: - Submit Button

            Section {

                Button {
                    Task {
                        await viewModel.submitInquiry()

                        if viewModel.isSubmissionSuccessful {
                            onSuccess()
                        } else if viewModel.errorMessage != nil {
                            showErrorAlert = true
                        }
                    }
                } label: {

                    HStack {
                        Spacer()

                        if viewModel.isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit Enquiry")
                                .fontWeight(.semibold)
                        }

                        Spacer()
                    }
                }
                .disabled(viewModel.isSubmitting)
            }
        }
        .navigationTitle("Product Enquiry")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: - Error Alert

        .alert(
            "Unable to Submit Enquiry",
            isPresented: $showErrorAlert
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(
                viewModel.errorMessage
                ?? "Something went wrong. Please try again."
            )
        }
    }
}


