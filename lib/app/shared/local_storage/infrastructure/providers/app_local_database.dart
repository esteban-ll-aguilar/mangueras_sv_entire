// Este archivo exporta la implementación correcta de AppLocalDatabase
// según la plataforma en la que se ejecute la aplicación.
//
// - En plataformas nativas (Android, iOS, Desktop): usa app_local_database_native.dart
// - En plataforma web: usa app_local_database_web.dart

export 'app_local_database_native.dart'
    if (dart.library.html) 'app_local_database_web.dart';
