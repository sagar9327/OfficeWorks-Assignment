# Officeworks – Product Catalogue

A product catalogue application developed for the **Officeworks AI-Native Engineer Code Challenge**.

## Tech Stack

- **iOS:** Swift, SwiftUI, MVVM
- **Backend:** Node.js, TypeScript, Express.js
- **Product Data:** Fake Store API
- **Email Service:** Resend

## Features

- Browse featured and top-rated products.
- Explore products by category.
- Search products.
- View product details.
- Submit product enquiries.
- Receive enquiry notifications through email.

## Architecture

The application follows a client-server architecture.

The iOS application communicates with a Node.js backend through REST APIs. The backend retrieves product data from the Fake Store API and handles enquiry email notifications.

## Getting Started

### Backend

```bash
cd officeworks-backend
npm install
```

Configure environment variables using `.env.example`, then start the backend:

```bash
npx tsx src/server.ts
```

Backend URL: `http://localhost:3000`

### iOS Application

Open `Officeworks-iOSClient.xcodeproj` in Xcode.

Ensure the backend is running and the development API URL is configured before launching the application in an iOS Simulator.

Refer to the [iOS README](Officeworks-iOSClient/README.md) for detailed setup and testing instructions.

## Documentation

- [iOS Setup and Architecture](Officeworks-iOSClient/README.md)
- [Technical Decisions and Trade-offs](DECISIONS.md)
- [AI Usage and Development Workflow](AI_USAGE.md)

---

**Developed as part of the Officeworks AI-Native Engineer Code Challenge.**