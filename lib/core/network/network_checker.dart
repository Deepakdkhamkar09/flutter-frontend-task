import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkChecker {
  static Future<bool> isConnected() async {
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      // Fallback for local testing when no external internet
      try {
        final localResult = await InternetAddress.lookup('localhost');
        return localResult.isNotEmpty && localResult[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    } catch (_) {
      return true;
    }
  }
}
