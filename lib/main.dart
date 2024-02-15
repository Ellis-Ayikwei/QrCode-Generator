import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Now that the Flutter binding is initialized, you can safely access SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  String initialRoute = isFirstTime ? '/onboarding' : '/home';

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(initialRoute: initialRoute));
}
