# Officeworks – iOS Client

SwiftUI-based product catalogue application developed for the Officeworks AI-Native Engineer Code Challenge.

## Tech Stack

- Swift
- SwiftUI
- MVVM Architecture
- Coordinator Pattern
- URLSession
- XCTest

## Features

- Featured products and top-rated products.
- Product listing and category filtering.
- Product search with 500 ms debounce.
- Product detail screen.
- Product enquiry form.
- Enquiry submission confirmation.

## Architecture

The application follows feature-based MVVM architecture.

- **App:** Application entry point, dependency container and navigation.
- **Core/Network:** API configuration, network client, response models and error handling.
- **Features/ProductList:** Product listing, search and category filtering.
- **Features/ProductDetail:** Product details.
- **Features/Inquiry:** Enquiry form and submission flow.

Dependencies are injected through the application dependency container. Navigation is managed using the Coordinator pattern.

## Setup

### Requirements

- Xcode
- iOS Simulator
- Running Officeworks backend

### Run the Application

1. Open `Officeworks-iOSClient.xcodeproj`.
2. Select the development scheme.
3. Verify the API base URL in `Development.xcconfig`.
4. Start the backend.
5. Select an iOS Simulator and run the application.

Development API URL:

```text
http://localhost:3000/api
```

For a physical device, configure the API URL using your development machine's reachable IP address.

## Testing

The project uses XCTest.

Current test coverage:

| Test Suite | Test Cases |
|---|---:|
| ProductListViewModelTests | 8 |
| ProductDetailViewModelTests | 4 |
| InquiryViewModelTests | 9 |
| NetworkClientTests | 12 |
| **Total** | **33** |

Run tests using `Cmd + U` in Xcode.

ProductService-specific unit tests and automated UI tests are outside the current scope.

