import 'package:flutter/foundation.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

String safeErrorMessage(
  Object error, {
  String fallback = 'No se pudo cargar la información.',
}) {
  if (!kReleaseMode) {
    logging.d('UI error: ${error.runtimeType}');
  }
  return fallback;
}
