// lib/services/auth_service.dart

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Stocke le numéro et le mot de passe localement après la connexion
  static Future<void> saveCredentials(String msisdn, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("msisdnCache", msisdn);
    await prefs.setString("pinCache", pin);
  }

  /// Récupère les identifiants stockés
  static Future<Map<String, String?>?> getStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final msisdn = prefs.getString("msisdnCache");
    final pin = prefs.getString("pinCache");

    if (msisdn != null && pin != null) {
      return {"msisdn": msisdn, "pin": pin};
    }
    return null;
  }

  /// Authentifie via empreinte digitale
  static Future<bool> authenticateWithBiometrics(BuildContext context) async {
    try {
      final isAuthorized = await _localAuth.authenticate(
        localizedReason: "Connectez-vous avec votre empreinte",
        authMessages: [
          const AndroidAuthMessages(
            signInTitle: "Authentification biométrique",
            cancelButton: "Annuler",
          )
        ],
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return isAuthorized;
    } catch (e) {
      print("Erreur biométrique : $e");
      return false;
    }
  }
}
