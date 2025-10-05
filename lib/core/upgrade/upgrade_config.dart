import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgraderConfig {
  static Upgrader builderUpgrader({
    required BuildContext context,
  }) {
    // Configuración para web
    if (kIsWeb) {
      return Upgrader(
        debugLogging: false,
        // Configuración mínima para web que no requiere store controller
        minAppVersion: '0.0.0',
      );
    }

    // Configuración para móviles
    return Upgrader(
      debugLogging: true,
      languageCode: Localizations.localeOf(context).languageCode,
      messages: UpgraderMessages(
        code: Localizations.localeOf(context).languageCode,
      ),
      countryCode: Localizations.localeOf(context).countryCode,
      minAppVersion: '1.0.0',
      durationUntilAlertAgain: const Duration(days: 1),
    );
  }
}
