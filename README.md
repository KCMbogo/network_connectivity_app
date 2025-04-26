# Network Connectivity Flutter App

A mobile application built with Flutter that demonstrates how to implement and manage network connectivity features.

## Features

- **Real-time Network Status Monitoring**: Displays the current network connection status (WiFi, Mobile Data, or No Connection)
- **Connection Type Detection**: Identifies and displays whether the device is connected via WiFi, mobile data, Ethernet, or Bluetooth
- **Network Controls**: Provides easy access to system settings for managing WiFi and mobile data connections
- **API Data Fetching**: Demonstrates how to fetch data from an API while handling various network states
- **Connection State UI**: Updates the UI based on the current connection status

## Screenshots

[Place your screenshots here]

## Technologies Used

- Flutter
- Dart
- connectivity_plus package
- http package
- app_settings package
- permission_handler package

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/network_connectivity_app.git
```

2. Navigate to the project directory:
```bash
cd network_connectivity_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Required Dependencies

Add these dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^4.0.2
  http: ^1.1.0
  app_settings: ^5.0.0
  permission_handler: ^10.2.0
```

## Permissions

This app requires the following permissions:

### Android
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

### iOS
Add these keys to your Info.plist file:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## How It Works

1. **Network Status Detection**: The app uses the `connectivity_plus` package to detect and monitor network connection status.
2. **Dynamic UI Updates**: The interface updates in real-time when network status changes using a `StreamSubscription`.
3. **Network Settings**: The app uses the `app_settings` package to open system network settings.
4. **API Integration**: The app demonstrates fetching data from a sample API and handling different network states.

## Project Structure

- `main.dart` - The entry point of the application
- `AndroidManifest.xml` - Contains required Android permissions
- Additional Flutter components and resources

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Flutter Documentation](https://flutter.dev/docs)
- [connectivity_plus package](https://pub.dev/packages/connectivity_plus)
- [app_settings package](https://pub.dev/packages/app_settings)
