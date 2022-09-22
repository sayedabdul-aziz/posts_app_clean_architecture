import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class CheckInternet {
  Future<bool> get isConnected;
}

class checkInternetImpl implements CheckInternet {
  final InternetConnectionChecker checkInternet;

  checkInternetImpl(this.checkInternet);

  Future<bool> get isConnected => checkInternet.hasConnection;
}
