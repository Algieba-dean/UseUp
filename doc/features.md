# UseUp - Feature Documentation
**Version: 1.0.2**

UseUp is a Flutter-based personal inventory management and expiry date tracking application. It is designed to help users reduce food waste and manage their household items efficiently.

## Core Features

### 1. Smart Dashboard
The central hub of the application provides an at-a-glance view of the user's inventory.
*   **Visual Expiry Tracking:** Items are color-coded based on their expiration status (e.g., Green for safe, Orange for expiring soon, Red for expired).
*   **Smart Filtering:** 
    *   **Search:** Instant text search for items.
    *   **Drill-down:** Filter inventory by specific **Categories** (e.g., Dairy, Meat) or **Locations** (e.g., Fridge, Pantry).
    *   **Tabs:** Quick toggles for "All Items", "Expiring Soon", and "Expired".
*   **Quick Actions:** 
    *   **Swipe Gestures:** Swipe left to **Delete**, swipe right to **Consume**.
    *   **Expiring Soon Highlight:** A horizontal scrollable section at the top prominently displays items nearing their expiry date.

### 2. Advanced Item Management
A robust system for adding and editing inventory items with support for various tracking methods.
*   **Dual Entry Modes:**
    *   **Expiry Date Mode:** Directly pick the expiration date.
    *   **Production Mode:** Enter Production Date + Shelf Life (e.g., "18 months") to automatically calculate expiry.
*   **Rich Details:**
    *   **Images:** Attach photos via Camera or Gallery.
    *   **Organization:** Assign items to customizable Categories and Locations.
    *   **Units:** Support for multiple units (pcs, kg, g, L, ml, pack, box).
    *   **Pricing:** Track item cost.
*   **Custom Notifications:** Users can set multiple reminder alerts for an item (e.g., "Notify me 1 week and 1 day before expiry").

### 3. History & Restocking
Tracks usage patterns and simplifies repurchasing.
*   **Consumption Log:** Items marked as "Consumed" are moved to the History screen, keeping the main inventory clean.
*   **One-Tap Restock:** Users can quickly re-add items from the history list. This pre-fills the add-item form with the product's previous details (name, category, shelf life), saving time.

### 4. Localization
*   **Multi-language Support:** The app fully supports **English** and **Chinese**, automatically adapting unit names, currency symbols, and UI text.

## Technical Stack

*   **Framework:** Flutter (Mobile - iOS/Android)
*   **Architecture:** Riverpod (State Management) + GoRouter (Navigation)
*   **Database:** Isar (High-performance local NoSQL database)
*   **Notifications:** Flutter Local Notifications (Scheduled alerts)
*   **UI/UX:** Material 3 Design with custom green/neutral aesthetic.

## Data Models

### Item Entity
*   `name`: Item name
*   `quantity` / `unit`: Amount tracking
*   `expiryDate`: The critical date for notifications
*   `productionDate` / `shelfLife`: Alternative tracking metadata
*   `category` / `location`: Relational links for organization
*   `imagePath`: Local file path to item photo
*   `notifyDaysList`: List of integers representing days-before-expiry to trigger alerts.
