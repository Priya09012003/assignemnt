# Flutter Posts App

A Flutter application that displays a list of posts from JSONPlaceholder API with offline-first approach, local storage, and real-time synchronization.

## Features

- **📱 Offline-First Architecture**: App works seamlessly offline with cached data
- **🔄 Background Sync**: Automatically syncs with API when online
- **💾 Local Storage**: Persistent data storage using SharedPreferences
- **🎯 Mark as Read**: Visual indicators for read/unread posts
- **⏱️ Timer System**: Countdown timers for each post
- **🌐 Network Status**: Real-time network connectivity indicator
- **🎨 Modern UI**: Clean Material Design with smooth animations
- **🔄 Error Handling**: Comprehensive error handling with retry functionality

## Technical Implementation

### Architecture
- **BLoC Pattern**: Clean state management using flutter_bloc
- **Repository Pattern**: Data abstraction layer
- **Local Storage Service**: SharedPreferences for data persistence
- **Connectivity Plus**: Network status monitoring

### Key Components
- **DataModel**: Post data structure with read status and timer
- **PostBloc**: State management for posts and timers
- **Repository**: API integration with offline fallback
- **LocalStorageService**: Data persistence layer
- **NetworkStatusWidget**: Real-time connectivity indicator

## API Integration

- **Posts List**: `https://jsonplaceholder.typicode.com/posts`
- **Post Details**: `https://jsonplaceholder.typicode.com/posts/{postId}`

## Requirements

- Flutter SDK 3.8.1 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Android device/emulator or iOS simulator

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  http: ^1.5.0
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2
  cupertino_icons: ^1.0.8
```

## Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd practice_assignment
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Android
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   
   # For web
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── config/
│   └── routes/
│       ├── routes.dart
│       └── routes_name.dart
├── core/
│   └── theme/
│       ├── app_sizes.dart
│       └── colors.dart
├── data/
│   ├── model.dart
│   └── local_storage_service.dart
├── presentation/
│   ├── bloc/
│   │   ├── bloc.dart
│   │   ├── event.dart
│   │   └── state.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── post_detail_screen.dart
│   │   └── splash_screen.dart
│   └── widgets/
│       ├── item_card.dart
│       └── network_status_widget.dart
├── repository/
│   └── post_repo.dart
└── main.dart
```

## Features Implementation

### Offline-First Approach
- App loads data from local storage first
- Background sync with API when online
- Graceful fallback to cached data when offline
- Network status indicator in app bar

### Local Storage
- Posts are cached locally using SharedPreferences
- Read status persists across app sessions
- Timer states are preserved
- Automatic data synchronization

### State Management
- BLoC pattern for clean architecture
- Event-driven state updates
- Timer management for posts
- Error state handling

### UI/UX Features
- Light yellow background for unread posts
- White background for read posts
- Green "Read" badge for read posts
- Loading indicators with descriptive text
- Error screens with retry functionality
- Network status indicator

## Testing Offline Functionality

### Test Scenarios

1. **First Launch (Online)**
   - Launch app with internet
   - Verify posts load from API
   - Mark some posts as read
   - Check console logs for sync status

2. **Offline Mode**
   - Turn off internet connection
   - Close and reopen app
   - Verify posts load from cache
   - Check that read status is preserved

3. **Background Sync**
   - Turn internet back on
   - Refresh or restart app
   - Verify data syncs with API
   - Confirm read status is maintained

### Console Logs
The app provides detailed logging for testing:
```
🌐 Network Status: ONLINE/OFFLINE
💾 Local Posts Found: X
📡 API Posts Fetched: X
💾 Posts Saved to Local Storage
```

## Error Handling

- Network connectivity errors
- API timeout handling
- Local storage errors
- User-friendly error messages
- Retry functionality

## Performance Optimizations

- Efficient data caching
- Minimal API calls
- Optimized state updates
- Memory management for timers

## Future Enhancements

- Pull-to-refresh functionality
- Search and filter capabilities
- Pagination for large datasets
- Push notifications
- Dark mode support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please contact the development team.

---

**Note**: This app demonstrates best practices for Flutter development including offline-first architecture, state management, and data persistence.