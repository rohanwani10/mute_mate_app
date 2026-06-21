# MuteMate: Your Ultimate Sign Language Companion

**MuteMate** is a comprehensive Flutter application designed to bridge
communication gaps for the Deaf and Hard of Hearing community. It provides
real-time sign language translation, voice-to-sign conversion, and interactive
learning tools, all within a beautiful, user-centric interface.

## 🚀 Key Features

- **Real-Time Translation**: Instantly translate spoken language to sign
  language (and vice versa) using advanced AI models.
- **Interactive Learning**: Gamified lessons and challenges to help users learn
  and master sign language at their own pace.
- **Community Hub**: Connect with other learners and native signers, share
  progress, and participate in group activities.
- **Personalized Dashboard**: Track your learning streak, achievements, and
  daily goals.
- **Offline Support**: Access core features and downloaded lessons even without
  an internet connection.

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **UI/UX**: Custom design system with glassmorphism effects
- **AI/ML**: Integration with Google ML Kit and custom translation models
- **Database**: Hive (Local), Firebase Firestore (Cloud)

## 📂 Project Structure

```
mute_mate_app/
├── lib/
│   ├── core/
│   │   ├── app_theme.dart       # Theme configuration
│   │   ├── constants.dart       # App constants and strings
│   │   └── navigation.dart      # Router configuration
│   ├── features/                # Feature modules
│   │   ├── home/                # Home screen and widgets
│   │   ├── translation/         # Translation features
│   │   ├── learning/            # Learning modules
│   │   └── profile/             # User profile and settings
│   ├── shared/                  # Shared components
│   │   ├── layouts/             # App layouts (e.g., BottomNav)
│   │   ├── widgets/             # Reusable widgets
│   │   └── providers/           # Shared providers
│   └── main.dart                # App entry point
├── assets/
│   ├── images/                  # App images and icons
│   ├── fonts/                   # Custom fonts
│   └── translations/            # Translation data
├── pubspec.yaml                 # Dependencies and assets
└── README.md                    # Project documentation
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (stable channel, version 3.x or higher)
- Dart SDK (compatible with your Flutter version)
- Android Studio or VS Code with Flutter extension
- (Optional) Firebase project for cloud features

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd mute_mate_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase (optional)**
   - Create a Firebase project at
     [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Add Android and/or iOS apps to your Firebase project
   - Download the `google-services.json` (Android) or `GoogleService-Info.plist`
     (iOS) files
   - Place them in the `android/app/` and `ios/Runner/` directories respectively

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎨 Design System

MuteMate uses a custom design system focused on accessibility and visual
clarity:

- **Primary Color**: `#00A896` (Teal)
- **Background**: `#F9F9F8` (Off-white)
- **Typography**: `Plus Jakarta Sans` font family
- **Effects**: Glassmorphism, subtle shadows, and smooth animations

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Create a feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to the branch (`git push origin feature/AmazingFeature`)
4. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file
for details.
