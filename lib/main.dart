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

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,

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
