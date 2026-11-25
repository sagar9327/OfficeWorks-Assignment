# Technical Decisions – Officeworks Product Catalogue

## 1. Architecture Decisions

### Client-Server Architecture

The application uses a client-server architecture with a SwiftUI iOS client and a Node.js backend.

**Reasoning:**
- Keeps external API integrations away from the iOS client.
- Centralizes product data processing and email delivery.
- Allows the frontend and backend to evolve independently.
- Makes it easier to replace external providers in the future.

### iOS – SwiftUI and MVVM

SwiftUI was selected for building the iOS interface, with feature-based MVVM architecture.

**Key decisions:**
- MVVM separates presentation logic from UI components.
- Protocol-oriented services make dependencies easier to replace and mock.
- Dependency injection improves testability.
- Coordinator-based navigation keeps navigation logic separate from views.
- URLSession is used for API communication.

A separate repository layer was not introduced because the current application has a relatively small data-access scope. The service layer is sufficient for the current requirements.

### Backend – Node.js, TypeScript and Express

Node.js with TypeScript and Express was selected for the backend.

**Reasoning:**
- TypeScript provides static typing.
- Express provides a lightweight REST API implementation.
- Axios is used for external API communication.
- The service layer separates email delivery from API handling.

### Product Data – Fake Store API

Fake Store API was selected as the external product data provider.

The backend retrieves product information and maps the external response into application-specific models.

The iOS application communicates only with the backend and does not directly access Fake Store API.

### Email Provider – Resend

Resend was selected for enquiry email delivery.

**Reasoning:**
- Simple API-based integration.
- Minimal configuration for local development.
- Keeps email delivery separate from enquiry handling.
- Allows the provider to be replaced without changing the iOS application.

Email configuration is managed through environment variables.

## 2. Key Implementation Decisions

### Product Listing

- The home screen displays five top-rated products.
- Products are sorted using their rating.
- Category selection retrieves products belonging to the selected category.
- Category results are ordered by rating.

### Search

- Search requires a minimum of three characters.
- A 500 ms debounce is implemented to avoid unnecessary API requests.
- Previous search tasks are cancelled when a new search is initiated.
- Search currently matches product titles.

### Networking

- A centralized NetworkClient handles HTTP requests.
- API responses use a common response structure.
- HTTP errors, decoding errors and network failures are handled separately.
- API base URLs are managed through environment-specific Xcode configuration files.

### Enquiry Submission

- Required fields are validated before submission.
- The backend verifies the product and processes the enquiry.
- Email delivery is handled through a separate email service.
- The customer receives a submission confirmation after successful processing.

## 3. Assumptions

The following assumptions were made during implementation:

- Fake Store API provides the product data required for the assignment.
- Product ratings are used to determine top-rated products.
- Product title is the primary field used for search.
- The configured sales inbox receives product enquiry notifications.
- Resend is used for email delivery during the current implementation.
- A successful email provider response is treated as successful enquiry submission.
- The application targets an iOS Simulator using a locally running backend during development.

## 4. Simplifications and Trade-offs

Given the 2–3 hour development timebox, the following areas were intentionally kept simple.

| Area | Current implementation | Possible improvement |
|---|---|---|
| Data access | Service layer without repository abstraction | Introduce repository layer if data sources grow |
| Search | Product title matching | Support description and category matching |
| Networking | Centralized URLSession client | Add retry and advanced request policies |
| Email | Direct Resend integration | Introduce provider abstraction for multiple email providers |
| Testing | ViewModel and NetworkClient unit tests | Add ProductService and backend automated tests |
| UI testing | Manual application verification | Add automated UI and end-to-end tests |
| Deployment | Local development setup | Add cloud deployment and CI/CD |

These decisions were made to prioritize the required user journeys and maintain a working application within the available time.

## 5. Scalability Considerations

The current architecture provides some flexibility for future changes:

- The product data provider can be replaced within the backend without requiring changes to the iOS application, provided the API contract remains consistent.
- Email delivery is isolated in a separate service.
- Protocol-based services make it easier to introduce alternative implementations.
- Development and production API configurations are maintained separately.
- Feature-based organization allows additional functionality to be introduced without significantly changing existing features.

For a production-scale application, further improvements would include:

- Persistent storage and caching.
- Pagination for large product catalogues.
- Better search capabilities.
- Request rate limiting and monitoring.
- Improved email delivery tracking and retry handling.
- Backend automated testing and CI/CD.

## 6. What I Would Improve With One Additional Development Day

If additional development time were available, I would prioritize:

1. **Backend testing:** Add automated tests for API endpoints, validation and email service behaviour.
2. **Service layer testing:** Add ProductService tests to verify API integration and response mapping.
3. **Error handling:** Improve user-facing error states and retry behaviour.
4. **UI testing:** Add automated tests for important user journeys.
5. **Documentation and deployment:** Improve setup documentation and introduce a repeatable deployment process.

## 7. Conclusion

The implementation prioritizes a clear separation between the iOS client and backend, maintainable code organization, basic error handling and testability.

Some advanced features and additional testing layers were intentionally excluded to stay within the assignment timebox.

The current solution provides the required product browsing, search, product details and enquiry workflows while leaving clear opportunities for future improvements.