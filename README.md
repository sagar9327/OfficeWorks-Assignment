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

### 1. Backend Setup

Navigate to the backend directory:

```bash
cd officeworks-backend
npm install
```

### 2. Environment Configuration

Create a `.env` file in the `officeworks-backend` directory using `.env.example` as a reference.

Configure the following variables:

```env
EMAIL_MODE=resend
SALES_EMAIL=your-email@example.com
RESEND_API_KEY=your-resend-api-key
```

| Variable | Description |
|---|---|
| `EMAIL_MODE` | Email delivery mode: `console` or `resend` |
| `SALES_EMAIL` | Recipient email address for enquiries |
| `RESEND_API_KEY` | API key generated from Resend |

For local testing without actual email delivery, use:

```env
EMAIL_MODE=console
SALES_EMAIL=sales@example.com
```

In console mode, enquiry email content is printed in the backend terminal.

**Note:** Resend's test sender supports delivery to permitted verified recipients. A verified sending domain is required for sending to arbitrary recipients.

Never commit `.env` files or API credentials to version control.

### 3. Start Backend

```bash
npx tsx src/server.ts
```

Backend URL: `http://localhost:3000`

Health check:

```bash
curl http://localhost:3000/health
```

### 4. Run iOS Application

1. Open `Officeworks-iOSClient.xcodeproj` in Xcode.
2. Select the development scheme.
3. Verify the API base URL in `Development.xcconfig`.
4. Ensure the backend is running.
5. Select an iOS Simulator and run the application.

Development API URL:

```text
http://localhost:3000/api
```

For a physical device, configure the API URL using your development machine's reachable IP address.

Refer to the [iOS README](Officeworks-iOSClient/README.md) for detailed setup and testing instructions.

## Documentation

- [iOS Setup and Architecture](Officeworks-iOSClient/README.md)
- [Technical Decisions and Trade-offs](DECISIONS.md)
- [AI Usage and Development Workflow](AI_USAGE.md)

---

**Developed as part of the Officeworks AI-Native Engineer Code Challenge.**