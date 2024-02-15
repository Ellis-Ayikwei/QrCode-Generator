import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcodescanner/src/sample_feature/pretty_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/sample_feature/first_qr.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Check if it's the first time launch
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  
  // Set initial route based on first-time launch
  String initialRoute = isFirstTime ? '/onboarding' : '/home';

  // Run the app and pass in the MultiProvider
  runApp(
    MultiProvider(
      providers: [
        // Provide your CounterProvider
        ChangeNotifierProvider(create: (_) => updateTheImages()),
        // Add more providers if needed
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
