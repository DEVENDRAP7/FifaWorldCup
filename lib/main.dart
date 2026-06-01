import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/locale_provider.dart';
import 'services/analytics_service.dart';
import 'services/consent_manager.dart';
import 'services/ad_service.dart';
import 'l10n/gen/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Route Flutter + platform errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();
  await Hive.openBox('user');
  await Hive.openBox('contest');
  await initializeDateFormatting();

  // GDPR/UMP consent must resolve before the Ads SDK initializes.
  try {
    await ConsentManager.instance.initialize();
  } catch (_) {}

  runApp(const ProviderScope(child: WorldCupApp()));
}

class WorldCupApp extends ConsumerStatefulWidget {
  const WorldCupApp({super.key});
  @override
  ConsumerState<WorldCupApp> createState() => _WorldCupAppState();
}

class _WorldCupAppState extends ConsumerState<WorldCupApp> with WidgetsBindingObserver {
  bool _firstResume = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdService.instance.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Skip the very first resume (cold launch is covered by the splash).
      if (_firstResume) {
        _firstResume = false;
        return;
      }
      AdService.instance.showAppOpenIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider); // null = follow device language
    return MaterialApp(
      title: 'World Cup 2026 - Live Scores',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      navigatorObservers: [Analytics.observer],
      home: const SplashScreen(),
    );
  }
}
