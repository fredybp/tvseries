# TVSeries

An iOS application for browsing and discovering TV shows, built with Swift and following best practices.

## Features

### Core Features
- 📺 Browse TV shows with pagination
- 🔍 Search shows by name
- 📱 Responsive UI with posters and show details
- 📋 Detailed show information including:
  - Show name and poster
  - Air schedule (days and times)
  - Genres
  - Summary
  - Episodes organized by season
- 🎬 Episode details including:
  - Episode name and number
  - Season information
  - Summary
  - Episode image (when available)

### Bonus Features
- 🔒 PIN protection for app security
- ⭐️ Favorites management:
  - Add/remove shows to favorites
  - Browse favorites in alphabetical order
  - Access favorite show details

## Technical Implementation

### Architecture
- MVVM architecture pattern
- Coordinator pattern for navigation
- Protocol-oriented programming
- Dependency injection for better testability

### Key Components
- **Services**:
  - `TVMazeService`: Handles API communication
  - `FavoritesService`: Manages favorite shows
  - `PINService`: Handles PIN security
  - `Keychain`: Secure storage for sensitive data

- **ViewModels**:
  - `HomeViewModel`: Manages show listing and search
  - `DetailViewModel`: Handles show details
  - `PINViewModel`: Manages PIN entry and verification

- **ViewControllers**:
  - `HomeViewController`: Main show listing
  - `DetailViewController`: Show details
  - `PINViewController`: PIN entry interface
  - `SettingsViewController`: App settings

### Testing
- Comprehensive unit tests
- Mock implementations for services
- Test coverage for core functionality
- UI testing for critical paths

## Technical Stack
- Swift
- UIKit
- Combine for reactive programming
- URLSession for networking
- UserDefaults for local storage
- Keychain for secure data

## Project Structure
```
TVSeries/
├── App/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Models/
│   ├── TVShow.swift
│   ├── Episode.swift
│   └── Network.swift
├── Services/
│   ├── TVMazeService.swift
│   ├── FavoritesService.swift
│   └── PINService.swift
├── ViewControllers/
│   ├── Home/
│   ├── Details/
│   └── Settings/
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── DetailViewModel.swift
│   └── PINViewModel.swift
├── Views/
│   ├── Cells/
│   └── Components/
└── Tests/
    ├── ViewModels/
    └── Services/
```

## Best Practices
- Clean, modular code structure
- Protocol-oriented design
- Dependency injection
- Comprehensive error handling
- Memory management
- UI/UX following iOS guidelines
- Secure data handling
- Unit testing

## Features not able to be implemented
- Fingerprint authentication
- People search functionality
- Person details view
- Enhanced UI/UX improvements
- Additional testing coverage
- Performance optimizations

## Requirements
- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+

## Installation
1. Clone the repository
2. Open `TVSeries.xcodeproj` in Xcode
3. Build and run the project

## API
The application uses the [TVMaze API](https://www.tvmaze.com/api) for show data.

## License
This project is available under the MIT license. See the LICENSE file for more info. 