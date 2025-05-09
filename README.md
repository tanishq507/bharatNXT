#  Readify 

A modern Flutter application that displays articles from JSONPlaceholder API with features like favorites, search, and theme customization.

## Features

- Article list with pull-to-refresh
- Search functionality
- Favorite articles with local storage
- Light/dark theme toggle
- Smooth animations and transitions
- Error handling and loading states

## Setup Instructions

1. Ensure you have Flutter installed (version 3.0.0 or higher)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Dependencies

- `provider`: State management
- `http`: API requests
- `shared_preferences`: Local storage
- `flutter_staggered_animations`: List animations
- `flutter_slidable`: Swipe actions

## State Management

The app uses Provider for state management with two main providers:

- `ArticleProvider`: Manages article data, favorites, and search
- `ThemeProvider`: Handles theme mode preferences

## Project Structure

```
lib/
  ├── models/         # Data models
  ├── providers/      # State management
  ├── screens/        # UI screens
  ├── services/       # API and storage
  └── widgets/        # Reusable widgets
```

## Known Limitations

- Articles are stored locally and may consume storage space
- Search is performed client-side
- No offline support for initial article fetch
- No pagination for article list
