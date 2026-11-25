//
//  InquirySuccessView.swift
//  Officeworks-iOSClient
//
//  Created by Sagar Kalathil on 25/11/26.
//
import SwiftUI

struct InquirySuccessView: View {

    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 75))
                .foregroundStyle(.green)

            Text("Thank You!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your enquiry has been submitted successfully. Our team will get back to you soon.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()

            Button {
                onDone()
            } label: {
                Text("Back to Products")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

