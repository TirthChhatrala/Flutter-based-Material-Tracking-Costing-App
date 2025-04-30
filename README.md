# SmartFab Material Tracking & Costing App

## Overview
The SmartFab Material Tracking & Costing App is a Flutter-based solution designed to streamline material logging, automate cost calculations, and enforce role-based access for production teams. This app replaces manual spreadsheets and paper logs, preventing stock discrepancies, cost overruns, and slow, error-prone reporting.

## Features
- **Role-based Access Control:** 
  - Admins: Manage materials, processes, users, and view analytics.
  - Operators: Scan materials, log usage, and track assigned tasks.
- **Real-time Material Tracking:** Supports QR/barcode scanning for instant logging.
- **Automated Cost Calculations:** Ensures accurate material cost computation and pricing.
- **Offline Functionality:** Logs scans locally and syncs with Firebase (or similar) once online.
- **Inventory & Cost History Management:** Maintains synchronized data across multiple devices.
- **Low-stock & Cost Alerts:** Provides timely notifications to prevent shortages and overruns.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider / Riverpod / Bloc (choose based on project needs)
- **Offline Storage:** SQLite / Hive
- **Backend & Syncing:** Firebase Firestore / Supabase
- **Authentication:** Firebase Auth / OAuth
- **QR/Barcode Scanning:** `flutter_barcode_scanner` or `qr_code_scanner`
- **Analytics & Reporting:** Firebase Analytics / Custom Charts

## Installation
To set up the project locally, follow these steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/TirthChhatrala/Flutter-based-Material-Tracking-Costing-App.git
Navigate into the project directory:cd smartfab-material-tracking

    cd smartfab-material-tracking
- Install dependencies:
  
      flutter pub get
- Run the app:

      flutter run
Usage Guide
- Admins: Log in and configure materials, processes, and user roles.
- Operators: Scan QR/barcodes, log material usage, and track assigned tasks.
- Offline Mode: Ensure scans are cached locally for seamless operation.
- Sync Data: Once online, reconcile logs with the cloud storage.

Contributing
Contact
For queries and support, reach out via:
- Email: tirthchhatrala@gmail.com
- GitHub Issues: SmartFab Material Tracking & Costing App
