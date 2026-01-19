# ToStore Chat Demo

A Flutter application demonstrating local chat functionality using the ToStore database.

## Features

- **Local Database**: Uses ToStore for persistent local storage of users and messages
- **Inbox View**: Displays a list of users with preview of last messages
- **Chat Interface**: Real-time chat with individual users
- **Message History**: Persistent message storage with timestamps
- **Clear Chat**: Option to clear conversation history for each user

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.7)
- Dart SDK

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

## Project Structure

- `lib/models/`: Data models (User, Message)
- `lib/services/`: ToStore service for database operations
- `lib/views/`: UI screens (HomeView for inbox, ChatView for conversations)

## Dependencies

- [ToStore](https://pub.dev/packages/tostore): Local database solution
- Flutter SDK

## Usage

1. Launch the app to see the inbox with 10 default users
2. Tap on any user to start chatting
3. Send messages and view conversation history
4. Use the delete button in chat to clear messages for that user

## Development

This app serves as an example implementation of a chat application using local storage with ToStore.
