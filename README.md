# ToStore Chat Demo

A Flutter application demonstrating local chat functionality using the ToStore database.

## Features

- **Local Database**: Uses ToStore for persistent local storage of users and messages
- **Inbox View**: Displays a list of users with preview of last messages
- **Chat Interface**: Real-time chat with individual users
- **Message History**: Persistent message storage with timestamps
- **Clear Chat**: Option to clear conversation history for each user
- **Stream-based Updates**: Real-time message updates using Dart streams
- **Material Design**: Modern UI with light/dark theme support

## Architecture

### Database Schema

The app uses ToStore with two main tables:

**Users Table:**
- `id` (Primary Key): String identifier
- `name`: User's display name

**Messages Table:**
- `id` (Primary Key): Unique message identifier
- `sender`: Message sender name
- `text`: Message content
- `createdAt`: ISO 8601 timestamp string
- `userId`: Foreign key referencing user chat

**Indexes:**
- `user_idx` on `userId` for efficient message queries

### Service Layer

`ToStoreService` provides:
- Database initialization with schema setup
- CRUD operations for users and messages
- Stream controllers for real-time chat updates
- Automatic inbox seeding with 10 default users

### UI Architecture

- **HomeView**: Stateful widget managing user list and navigation
- **ChatView**: Stateful widget handling message display and input
- Stream-based reactive updates for seamless chat experience

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.7)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd tostore_db
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS (on macOS)
flutter build ios --release

# Web
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart              # App entry point and theme configuration
├── models/
│   ├── user.dart          # User data model
│   └── message.dart       # Message data model
├── services/
│   └── tostore_service.dart # Database service layer
└── views/
    ├── home_view.dart     # Inbox screen
    └── chat_view.dart     # Chat interface
```

## Dependencies

- **[ToStore](https://pub.dev/packages/tostore)**: Local database solution
- **Flutter SDK**: UI framework
- **Cupertino Icons**: iOS-style icons

## Usage

### Basic Workflow

1. **Launch App**: Opens to inbox with 10 seeded users
2. **Select User**: Tap any user to open chat
3. **Send Messages**: Type and send messages (appears as "You")
4. **View History**: Messages persist across app restarts
5. **Clear Chat**: Use delete button to remove conversation

### Code Examples

#### Initializing Database
```dart
await ToStoreService.instance.init();
```

#### Sending a Message
```dart
final message = Message(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  sender: 'You',
  text: 'Hello!',
  createdAt: DateTime.now(),
);
await ToStoreService.instance.sendMessage(userId, message);
```

#### Listening to Messages
```dart
final stream = ToStoreService.instance.messagesStream(userId);
stream.listen((messages) {
  // Update UI with new messages
});
```

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Formatting

```bash
dart format .
```

## Performance Considerations

- **Indexing**: Messages table indexed on `userId` for fast queries
- **Streaming**: Efficient real-time updates without polling
- **Lazy Loading**: Messages loaded on-demand per user
- **Memory Management**: Stream controllers properly disposed

## Troubleshooting

### Common Issues

**Database Initialization Fails**
- Ensure proper file permissions for app data directory
- Check ToStore version compatibility

**Messages Not Updating**
- Verify stream subscription is active
- Check for stream controller disposal issues

**Build Errors**
- Run `flutter clean` and `flutter pub get`
- Ensure Flutter SDK version matches requirements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Submit a pull request

## License

This project is for demonstration purposes. See Flutter license for details.
