# Unsplash Photo Picker

A modern iOS photo browsing app built with **SwiftUI**, designed to let users explore and search high-quality photos using the **Unsplash API**. Users can browse photos, perform keyword searches, view detailed image information, and bookmark/download their favorite shots.

---

## Features

- Home view with trending and curated Unsplash photos  
- Real-time search functionality with pagination  
- Detailed view of selected images with user and photo info  
- Bookmark and download your favorite photos  
- Smooth animations, shimmering placeholders, and pull-to-refresh  

---

## Setup Instructions

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-username/UnsplashPhotoPicker.git
   cd UnsplashPhotoPicker
   ```

2. **Install dependencies**  
   Open the `.xcodeproj` or `.xcworkspace` file in Xcode. Wait for Swift Package Manager to resolve all packages.

3. **Configure API Keys**  
   - Sign up at [Unsplash Developers](https://unsplash.com/developers)  
   - Create an app and get your **Access Key**  
   - Add it to your project as a constant or load it securely from a `.plist`:
     ```swift
     let unsplashAccessKey = "YOUR_UNSPLASH_ACCESS_KEY"
     ```

4. **Run the project**  
   Select a simulator or connect your iOS device, then build and run using ⌘R.

---

## Screenshots

  <img src="https://github.com/user-attachments/assets/e7cbdac4-9aaf-4dfb-83cd-1a9ae6250c41" width="200"/>
  <img src="https://github.com/user-attachments/assets/f6dc2825-bbe3-49db-9da6-6e954d4bb793" width="200"/>
  <img src="https://github.com/user-attachments/assets/9fa46540-a4f4-4ee3-bf69-e33c0a1b22c2" width="200"/>
  <img src="https://github.com/user-attachments/assets/ecbdcb86-ff4c-40e5-9dde-381e3c17ad88" width="200"/>
  <img src="https://github.com/user-attachments/assets/4e9de61b-c630-4ad7-94f5-d2720b338a44" width="200"/>
  <img src="https://github.com/user-attachments/assets/bbf21bc3-ecd1-43de-944c-1858bd74ecb5" width="200"/>
  <img src="https://github.com/user-attachments/assets/a3eb0e03-2a91-44dc-93b1-fba162b2d866" width="200"/>
  <img src="https://github.com/user-attachments/assets/324ea753-654f-4fa1-b5ab-716f8d1bc77e" width="200"/>

---

## Architecture & Approach

The app is designed using a **modular MVVM architecture** with modern SwiftUI patterns:

- **SwiftUI + ObservableObject** for reactive UI updates  
- **Dedicated ViewModels** per screen: `HomeViewModel`, `SearchViewModel`, etc.  
- **Async/Await** for clean, modern asynchronous networking  
- **Pagination logic** for smooth infinite scrolling  
- **Shimmering placeholders and loading states** for better UX  

Folder structure includes:

- `Models/` – Codable structs like `Photo`, `User`, etc.  
- `Networking/` – Handles all API interactions  
- `ViewModels/` – Business logic and data binding  
- `Views/` – All SwiftUI views and UI components  

---

## Challenges Faced

- **Unsplash API rate limits**: Managed API throttling and optimized request frequency  
- **Shimmer placeholder views**: Built custom skeleton loaders that don't interfere with real data  
- **Image caching**: Avoided flickers by carefully managing asynchronous image loading  
- **Efficient pagination**: Balanced user experience and API performance  
- **State-driven navigation**: Handled SwiftUI's navigation stack without unwanted side effects  
