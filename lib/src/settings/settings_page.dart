import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qrcodegenerator/core.dart';
import 'package:qrcodegenerator/src/settings/support.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
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
                    onPressed: () {
                      Get.to(const ContactSupportPage());
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Launch Twitter page
                      launchTheUrl(
                          "https://www.buymeacoffee.com/ellisrockefeller");
                    },
                    icon: const Icon(FontAwesomeIcons.mugHot, color: Colors.white),
                    label: const Text('Buy Me a coffee'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Goldish,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Terms  And Conditions",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () {
                      Get.to(const TermsAndConditionsPage());
                    },
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Copyright © 2024 [TradHut Ghana]\n"
                "All rights reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey), // Customize as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSettingsDialog extends StatelessWidget {
  const ThemeSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SettingsPage(),
    );
  }
}

void showThemeSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ThemeSettingsDialog();
    },
  );
}
