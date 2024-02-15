import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:qrcodescanner/src/sample_feature/first_qr.dart';
import 'package:qrcodescanner/src/sample_feature/onboarding.dart';
import 'package:qrcodescanner/src/sample_feature/theme_manager.dart';
import 'package:qrcodescanner/src/Utils/theme/theme.dart';

ThemeManager _themeManager = ThemeManager();

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      //
      // The appTitle is defined in .arb files found in the localization
      // directory.
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      getPages: [
        GetPage(
          name: '/home',
          page: () => FileUploadView(),
        ),
        GetPage(
          name: '/onboarding',
          page: () => OnboardingScreen(),
        ),
      ],
      initialRoute: widget.initialRoute,
    );
  }
}
