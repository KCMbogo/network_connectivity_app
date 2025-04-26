// main.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:app_settings/app_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Controls',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NetworkDemoPage(),
    );
  }
}

class NetworkDemoPage extends StatefulWidget {
  const NetworkDemoPage({super.key});

  @override
  State<NetworkDemoPage> createState() => _NetworkDemoPageState();
}

class _NetworkDemoPageState extends State<NetworkDemoPage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  bool _isLoading = false;
  String _responseData = "No data fetched yet";
  
  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = 
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  
  // Initialize connectivity method
  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      return;
    }
    
    if (!mounted) {
      return;
    }
    
    _updateConnectionStatus(result);
  }
  
  // Update connection status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
  
  // Fetch data from API
  Future<void> _fetchData() async {
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _responseData = "No internet connection available!";
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _responseData = "Title: ${data['title']}\n\nBody: ${data['body']}";
          _isLoading = false;
        });
      } else {
        setState(() {
          _responseData = "Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _responseData = "Error: $e";
        _isLoading = false;
      });
    }
  }
  
  // Open WiFi settings
  void _openWiFiSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.wifi);
  }
  
  // Open Mobile Data settings
  void _openDataSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.wireless);
  }
  
  // Get connection type icon
  IconData _getConnectionIcon() {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.signal_cellular_4_bar;
      case ConnectivityResult.ethernet:
        return Icons.lan;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.none:
        return Icons.signal_wifi_off;
      default:
        return Icons.question_mark;
    }
  }
  
  // Get connection type color
  Color _getConnectionColor() {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        return Colors.blue;
      case ConnectivityResult.mobile:
        return Colors.green;
      case ConnectivityResult.ethernet:
        return Colors.purple;
      case ConnectivityResult.bluetooth:
        return Colors.indigo;
      case ConnectivityResult.none:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  String _getConnectionStatusString() {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Network';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Connected to Bluetooth';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown Connection Status';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Controls Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection status card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getConnectionIcon(),
                          color: _getConnectionColor(),
                          size: 36,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Connection Status:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _getConnectionStatusString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: _getConnectionColor(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Network controls card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Network Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _openWiFiSettings,
                          icon: const Icon(Icons.wifi),
                          label: const Text('WiFi Settings'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _connectionStatus == ConnectivityResult.wifi
                                ? Colors.blue.shade100
                                : null,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _openDataSettings,
                          icon: const Icon(Icons.signal_cellular_alt),
                          label: const Text('Mobile Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _connectionStatus == ConnectivityResult.mobile
                                ? Colors.green.shade100
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Note: These buttons will open system settings panels where you can toggle connection settings.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // API Test Section
            Text(
              'Test Network Connection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(_isLoading ? 'Loading...' : 'Fetch Data from API'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'API Response:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_responseData),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}