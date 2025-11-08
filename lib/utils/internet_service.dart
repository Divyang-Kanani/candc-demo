import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection {
  // Singleton instance
  static final InternetConnection instance = InternetConnection._internal();

  final Connectivity _connectivity = Connectivity();

  InternetConnection._internal();

  /// ✅ One-time check for internet availability
  Future<bool> hasConnection() async {
    final List<ConnectivityResult> result = await _connectivity
        .checkConnectivity();

    // Return true if any valid network type is available
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn) ||
        result.contains(ConnectivityResult.bluetooth) ||
        result.contains(ConnectivityResult.other);
  }
}
