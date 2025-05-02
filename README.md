# Flutter Music Player

A modern and beautiful music player application built with Flutter and Riverpod state management.

## Features

- 🎵 Beautiful carousel-based music discovery
- 🎨 Modern UI with smooth animations
- ▶️ Full playback controls (play/pause, next/previous)
- 🔄 Repeat and shuffle functionality
- 📱 Responsive design
- 🎚️ Seek through tracks with a slider
- 🔍 Search and browse music
- 💫 Loading states and error handling

## Screenshots

[Add your screenshots here]

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  just_audio: ^0.9.36
  carousel_slider: ^4.2.1
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/music_player.git
```

2. Navigate to the project directory:
```bash
cd music_player
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   └── services/
│       └── music_api_service.dart
├── models/
│   └── song.dart
├── providers/
│   ├── providers.dart
│   └── states/
│       ├── loading_state.dart
│       └── player_state.dart
├── views/
│   └── screens/
│       ├── discover_screen.dart
│       └── now_playing_screen.dart
├── viewmodels/
│   ├── loading_viewmodel.dart
│   └── player_viewmodel.dart
└── main.dart
```

## Architecture

This project follows a clean architecture pattern with:
- Riverpod for state management
- Repository pattern for data access
- MVVM (Model-View-ViewModel) architecture
- Separation of concerns with dedicated providers and state management

## Features in Detail

### Music Discovery
- Carousel-based UI for browsing music
- Beautiful album art display
- Artist and track information

### Playback Controls
- Play/Pause
- Next/Previous track
- Seek through tracks
- Shuffle playlist
- Repeat modes (none, single, all)

### UI/UX
- Loading indicators
- Error handling with retry options
- Smooth animations
- Responsive layout
- Dark theme

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management
- just_audio for audio playback
- carousel_slider for the beautiful carousel implementation
