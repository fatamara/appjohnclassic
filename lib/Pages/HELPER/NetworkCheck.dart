import 'package:connectivity_plus/connectivity_plus.dart';

import 'dart:io';

class NetworkCheck {
  /// Vérifie s'il y a une vraie connexion Internet
  Future<bool> check() async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) return false;

      // Test réel de connexion (ping Google)
      final lookup = await InternetAddress.lookup('example.com');
      if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {
      // Erreur réseau ou pas de connexion réelle
    }
    return false;
  }

  /// Appelle un callback avec le statut (true/false)
  void checkInternet(Function(bool) callback) {
    check().then(callback);
  }
}

