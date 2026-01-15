# 💬 Chat App

A modern, real-time chat application built with Flutter and Firebase, featuring end-to-end messaging, media sharing, and push notifications.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Features

### Core Messaging
- ✅ Real-time one-to-one messaging
- ✅ Message status tracking (Sending → Sent → Delivered → Read)
- ✅ Typing indicators
- ✅ Message deletion
- ✅ Offline message queue

### Media Sharing
- ✅ Image sharing (Camera & Gallery)
- ✅ File attachments (PDF, Documents, etc.)
- ✅ Voice messages with recording
- ✅ Upload progress indicators
- ✅ Media preview in chat

### Authentication
- ✅ Email/Password authentication
- ✅ Auto-login with cached credentials
- ✅ Password reset
- ✅ User profile management

### Notifications
- ✅ Push notifications for new messages
- ✅ Background and foreground notifications
- ✅ Notification tap navigation
- ✅ Message type indicators

### Additional Features
- ✅ User avatars with fallback initials
- ✅ Last seen timestamps
- ✅ Unread message counts
- ✅ Pull-to-refresh
- ✅ Dark mode support
- ✅ Material 3 design

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                   # Core utilities and constants
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error handling
│   ├── network/            # Network utilities
│   ├── services/           # Core services (notifications, etc.)
│   ├── theme/              # App theming
│   └── utils/              # Helper utilities
│
├── features/               # Feature modules
│   ├── authentication/     # Auth feature
│   │   ├── data/          # Data layer (models, datasources, repositories)
│   │   ├── domain/        # Domain layer (entities, usecases)
│   │   └── presentation/  # UI layer (pages, widgets, BLoC)
│   │
│   ├── chat/              # Chat feature
│   ├── media/             # Media handling
│   └── user_profile/      # User profile
│
├── config/                # App configuration
│   ├── routes/            # Navigation
│   └── environment/       # Environment config
│
├── injection.dart         # Dependency injection setup
├── app.dart              # Root app widget
└── main.dart             # Entry point
```

### Architecture Layers

**Domain Layer** (Business Logic)
- Entities: Pure business objects
- Repositories: Abstract interfaces
- UseCases: Single-responsibility business operations

**Data Layer** (Data Management)
- Models: Data transfer objects with JSON serialization
- DataSources: Firebase, local storage implementations
- Repositories: Concrete implementations

**Presentation Layer** (UI)
- Pages: Screen widgets
- Widgets: Reusable UI components
- BLoC: State management

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language

### Backend & Services
- **Firebase Authentication**: User authentication
- **Cloud Firestore**: Real-time database
- **Firebase Storage**: File storage
- **Firebase Cloud Messaging**: Push notifications
- **Firebase Cloud Functions**: Backend logic

### State Management & Architecture
- **BLoC Pattern**: Business Logic Component
- **GetIt**: Dependency injection
- **Injectable**: Code generation for DI

### Local Storage
- **Hive**: NoSQL database for caching
- **SharedPreferences**: Key-value storage
- **Flutter Secure Storage**: Encrypted storage

### Utilities & Tools
- **Dartz**: Functional programming (Either pattern)
- **Freezed**: Code generation for immutable classes
- **Json Serializable**: JSON serialization
- **Equatable**: Value equality
- **Connectivity Plus**: Network status
- **Image Picker**: Camera/Gallery access
- **File Picker**: File selection
- **Record**: Audio recording
- **Just Audio**: Audio playback
- **Cached Network Image**: Image caching
- **Timeago**: Relative time formatting
- **UUID**: Unique ID generation
- **Logger**: Logging utility

---

## 📋 Prerequisites

Before running this project, ensure you have:

- Flutter SDK (3.10 or higher)
- Dart SDK (3.0 or higher)
- Firebase account
- Node.js and npm (for Firebase Functions)
- Android Studio / Xcode (for mobile development)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/chat_app.git
cd chat_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### a. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable the following services:
    - Authentication (Email/Password)
    - Cloud Firestore
    - Cloud Storage
    - Cloud Messaging

#### b. Configure Firebase for Flutter

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your Flutter app
flutterfire configure
```

This will:
- Create `firebase_options.dart`
- Download configuration files
- Register your app with Firebase

#### c. Add Firebase Security Rules

**Firestore Rules** (`firestore.rules`):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /chats/{chatId} {
      allow read: if request.auth.uid in resource.data.participantIds;
      allow create: if request.auth != null;
      allow update: if request.auth.uid in resource.data.participantIds;
      
      match /messages/{messageId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participantIds;
        allow create: if request.auth != null;
        allow update: if request.auth.uid == resource.data.senderId;
      }
      
      match /typing/{userId} {
        allow read: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participantIds;
        allow write: if request.auth.uid == userId;
      }
    }
  }
}
```

**Storage Rules** (`storage.rules`):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /avatars/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /chat_images/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /chat_files/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /voice_messages/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

Deploy rules:
```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

### 4. Deploy Cloud Functions (for Push Notifications)

```bash
# Initialize Firebase Functions
firebase init functions

# Navigate to functions directory
cd functions

# Install dependencies
npm install

# Deploy functions
firebase deploy --only functions

# Return to project root
cd ..
```

### 5. Generate Code

```bash
# Generate dependency injection and model code
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Run the App

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>
```

---

## 📱 Platform-Specific Setup

### Android

#### Permissions (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

#### Minimum SDK Version (`android/app/build.gradle`)

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimum Android 5.0
        targetSdkVersion 33
    }
}
```

### iOS

#### Permissions (`ios/Runner/Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access to record voice messages</string>

<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Minimum iOS Version (`ios/Podfile`)

```ruby
platform :ios, '12.0'
```

---

## 🧪 Testing

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test
```

### Run Widget Tests

```bash
flutter test test/widget_test.dart
```

---

## 🏗️ Build for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Build IPA (requires macOS)
flutter build ipa --release
```

---

## 📂 Project Structure Details

### Key Directories

**`lib/core/`**: Shared utilities and configurations
- Constants (Firebase, Storage, App)
- Error handling (Failures, Exceptions)
- Network utilities
- Theme configuration
- Services (Notifications)

**`lib/features/`**: Feature modules following Clean Architecture
- Each feature has data, domain, and presentation layers
- Completely independent and testable

**`lib/config/`**: App-wide configuration
- Routing setup
- Environment configuration

---

## 🔧 Configuration Files

- **`pubspec.yaml`**: Dependencies and assets
- **`analysis_options.yaml`**: Dart analyzer rules
- **`firebase.json`**: Firebase configuration
- **`firestore.rules`**: Firestore security rules
- **`storage.rules`**: Storage security rules
- **`functions/`**: Cloud Functions code

---

## 🎨 Design Patterns Used

- **Repository Pattern**: Data access abstraction
- **BLoC Pattern**: State management
- **Factory Pattern**: Object creation
- **Singleton Pattern**: Dependency injection
- **Observer Pattern**: Streams and real-time updates
- **Strategy Pattern**: Different message types
- **Either Pattern**: Functional error handling

---

## 🔐 Security

- Firebase Authentication for user verification
- Firestore security rules for data access control
- Storage rules for file access control
- Encrypted local storage for sensitive data
- FCM token validation for push notifications
- Input validation on all forms

---

## 🐛 Known Issues & Limitations

- Voice messages playback not yet implemented (only recording)
- Group chat functionality not yet available
- Video calling not supported
- No end-to-end encryption (messages are encrypted in transit only)

---

## 🗺️ Roadmap

- [ ] Voice message playback
- [ ] Group chat support
- [ ] User search and discovery
- [ ] Message reactions (emoji)
- [ ] Message forwarding
- [ ] Video/Audio calling
- [ ] End-to-end encryption
- [ ] Story/Status feature
- [ ] Desktop app (Windows, macOS, Linux)
- [ ] Web app support

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Use consistent code formatting (`flutter format .`)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Your Name** - *Initial work* - [YourGithub](https://github.com/yourusername)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- All open-source contributors whose packages made this possible

---

## 📞 Support

For support, email your-email@example.com or open an issue in the GitHub repository.

---

## 📸 Screenshots

<!-- Add screenshots here -->
```
| Login Screen | Chat List | Chat Room |
|--------------|-----------|-----------|
| ![Login](screenshots/login.png) | ![Chat List](screenshots/chat_list.png) | ![Chat](screenshots/chat_room.png) |
```

---

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture Article](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Made with ❤️ using Flutter**