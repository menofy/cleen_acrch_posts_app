import 'package:internet_connection_checker/internet_connection_checker.dart';
 
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
 
// Actual implementation of network connectivity checking using InternetConnectionChecker
class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
 
  NetworkInfoImp({required this.connectionChecker});
 
  @override
  Future<bool> get isConnected async => connectionChecker.hasConnection;
}
 
// Mock implementation (used for testing or when no network check is needed)
class MockNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true; // Always returns true (no actual check)
}