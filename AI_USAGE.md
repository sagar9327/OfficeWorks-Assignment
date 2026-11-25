# AI Usage – Officeworks Product Catalogue

## 1. AI Tools Used

**Primary AI Tool:** ChatGPT

ChatGPT was used as an AI development assistant throughout the assignment.

It helped with:
- Understanding requirements and breaking them into smaller tasks.
- Exploring architecture and implementation approaches.
- Generating initial code and implementation suggestions.
- Understanding unfamiliar backend concepts.
- Preparing and reviewing unit tests.
- Debugging implementation and test failures.
- Improving project documentation.

## 2. Development Workflow

AI assistance was used across the following stages.

### Planning and Architecture

ChatGPT was used to:
- Break down the assignment requirements.
- Define the responsibilities of the iOS client and backend.
- Discuss the client-server architecture.
- Evaluate the use of SwiftUI, MVVM, Coordinator and dependency injection.
- Plan backend API endpoints and external service integrations.

### iOS Development

ChatGPT assisted with:
- Structuring the SwiftUI application.
- Implementing ViewModels and service protocols.
- Setting up dependency injection.
- Implementing centralized API communication using URLSession.
- Implementing product search with debounce.
- Handling API errors and enquiry submission.

### Backend Development

ChatGPT assisted with:
- Understanding Node.js, TypeScript and Express.
- Designing REST API endpoints.
- Integrating the Fake Store API.
- Mapping external product responses into application models.
- Integrating Resend for enquiry email notifications.
- Configuring environment variables and protecting API credentials.

### Testing and Debugging

ChatGPT assisted with:
- Creating XCTest cases for ViewModels and NetworkClient.
- Building mock services and MockURLProtocol.
- Understanding asynchronous test execution.
- Investigating test failures and improving test synchronization.
- Reviewing expected API and error-handling behaviour.

### Documentation

ChatGPT assisted with preparing:
- Root README.md.
- iOS README.md.
- DECISIONS.md.
- AI_USAGE.md.

## 3. Key Prompts and AI-Assisted Development Examples

The following are representative prompts and development interactions from the implementation process.

### Example 1: Architecture Planning

**Prompt:**

"Help me design the architecture for an iOS product catalogue application using SwiftUI and a Node.js backend. The backend should communicate with Fake Store API, and the iOS application should communicate only with our backend."

**Outcome:**

Used the discussion to establish the client-server architecture, feature-based MVVM structure, service protocols and backend responsibilities.

### Example 2: Backend Email Integration

**Prompt:**

"How can I integrate an email service into my Node.js and TypeScript backend to send product enquiry notifications?"

**Outcome:**

Explored email integration options and implemented Resend as the email delivery provider. Environment variables were used to configure the API key and recipient inbox.

### Example 3: XCTest and Mock Networking

**Prompt:**

"Help me write unit tests for NetworkClient using URLProtocol so that I can test successful API responses, HTTP errors and network failures without calling the actual backend."

**Outcome:**

Created MockURLProtocol and NetworkClientTests to simulate network responses and verify request handling.

### Example 4: Asynchronous Search Testing

**Prompt:**

"My ProductListViewModel search test is failing because products are not updated after the debounce delay. Help me identify the issue and make the test reliable."

**Outcome:**

Investigated asynchronous task execution and improved test synchronization by waiting for the search task to complete instead of relying only on a fixed sleep duration.

### Example 5: Code Review and Trade-offs

**Prompt:**

"Review the current implementation and suggest which additional tests and architectural improvements are important within the assignment time limit."

**Outcome:**

Prioritized essential functionality and testing while documenting deferred improvements such as ProductService-specific tests, backend automated tests and UI automation.

## 4. AI-Generated Suggestions Reviewed and Corrected

AI-generated code and suggestions were reviewed against the actual project implementation.

Examples include:

- **Network request testing:** Initial POST body assertions did not account for how URLSession exposes request bodies through URLProtocol. The test was adjusted to inspect the available body representation.
- **Asynchronous testing:** Fixed-duration sleeps were not always reliable for verifying completed search operations. Task completion was used for synchronization.
- **Project configuration:** Verified Xcode target membership and Compile Sources when a test target could not resolve MockURLProtocol.
- **Email configuration:** Verified Resend integration by submitting an enquiry and confirming receipt of the email.
- **Architecture:** Avoided introducing unnecessary repository abstractions and additional layers where the existing service-based implementation was sufficient.

## 5. AI Usage and Human Review

AI was used as an assistant, not as a replacement for implementation review or decision-making.

The development process included:

- Reviewing generated code before integrating it.
- Understanding the purpose of suggested implementations.
- Building and running the application after changes.
- Executing unit tests and investigating failures.
- Verifying actual email delivery.
- Making final decisions based on assignment requirements and available development time.

AI-generated suggestions were not accepted blindly. Implementation decisions and final verification were performed as part of the development process.

## 6. Agent Instructions and Project Context

ChatGPT was provided with the assignment requirements and relevant project context during development.

The project was developed incrementally, with implementation and testing decisions discussed as individual features were completed.

No separate custom AI agent or autonomous development workflow was configured for this assignment.

## 7. Actual Time Spent

The assignment was developed within the requested timebox.

The actual time spent should be recorded below based on the development activity.

| Activity | Actual time |
|---|---|
| Requirement analysis and planning | To be recorded |
| Architecture and project setup | To be recorded |
| iOS implementation | To be recorded |
| Backend implementation | To be recorded |
| Testing and debugging | To be recorded |
| Documentation and final review | To be recorded |
| **Total** | **To be recorded** |

## 8. Conclusion

AI assistance helped accelerate requirement analysis, implementation, debugging, testing and documentation.

The primary focus was to use AI effectively while maintaining an understanding of the generated code, reviewing suggestions and validating the final implementation.

The experience demonstrated how AI can support development productivity while keeping technical decisions and quality verification under developer control.