import 'package:flutter/material.dart';

import '../sample_feature/theme_manager.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.call,
                color: Colors.white,
              ),
              label: const Text(
                "Contact Support",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.money,
                color: Colors.white,
              ),
              label: const Text(
                "Donate",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SettingsPage(),
    );
  }
}

void showThemeSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ThemeSettingsDialog();
    },
  );
}
