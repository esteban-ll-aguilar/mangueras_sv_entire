import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});


final logging = Logger(
  level: kReleaseMode ? Level.nothing : Level.debug,
  printer: PrettyPrinter(), // opcional, puedes cambiarlo por SimplePrinter()
);