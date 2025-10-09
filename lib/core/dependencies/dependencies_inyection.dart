import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:mangueras_sv_entire/app/shared/local_storage/infrastructure/providers/app_local_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});


final logging = Logger(
  level: kReleaseMode ? Level.nothing : Level.debug,
  printer: PrettyPrinter(), // opcional, puedes cambiarlo por SimplePrinter()
);

final localDatabaseProvider = FutureProvider<AppLocalDatabase>((ref) async {
  final database = await AppLocalDatabase.create();
  // Cerrar la base de datos cuando el provider se destruya
  ref.onDispose(() {
    database.close();
  });
  return database;
});
