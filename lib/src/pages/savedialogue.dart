


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showPngInfo(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final shouldShowInfo = !prefs.containsKey('showPngInfo'); // Check if key exists

  if (shouldShowInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Heads Up About Your QR Code'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "We saved your QR code as a PNG image. This format gives you the freedom to place it on any background you choose! Because of this transparency, the QR code itself might appear black in some apps. Don't worry, it will still scan perfectly!",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0), // Add some space between text and checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: prefs.containsKey('showPngInfo'), // Check if key exists (inverted)
                        onChanged: (value) async {
                          await prefs.setBool('showPngInfo', !value!); // Store negation of value
                          Navigator.pop(context); // Close dialog after selection
                        },
                      ),
                      const Text('Do not show again'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

