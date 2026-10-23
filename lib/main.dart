import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/core/routes/app_router.dart';
import 'package:mangueras_sv_entire/core/theme/theme.dart';
import 'package:mangueras_sv_entire/core/upgrade/upgrade_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Local development may use .env, but production/web must use dart-define.
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // Missing .env is expected in a packaged build.
  }

  const buildUrl = String.fromEnvironment('SUPABASE_URL');
  const buildAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  final supabaseUrl = buildUrl.isNotEmpty
      ? buildUrl
      : dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = buildAnonKey.isNotEmpty
      ? buildAnonKey
      : dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw StateError(
      'Faltan SUPABASE_URL y SUPABASE_ANON_KEY. Usa --dart-define en builds.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,

    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
      detectSessionInUri: !kIsWeb,
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Router único por rol (sin FLAVOR). FLAVOR queda como legacy ignorado.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mangueras SV',
      theme: AppTheme,
      builder: (context, router) {
        return UpgradeAlert(
          upgrader: UpgraderConfig.builderUpgrader(context: context),
          child: router ?? const SizedBox.shrink(),
        );
      },
      routerConfig: appRouter,
    );
  }
}
