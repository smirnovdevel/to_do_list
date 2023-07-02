import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfo implements INetworkInfo {
  NetworkInfo(this.connectionChecker);
  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
