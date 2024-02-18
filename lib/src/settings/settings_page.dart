import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrcodescanner/src/sample_feature/tc.dart';

class SettingsPage extends StatefulWidget {
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
        title: Text('Theme Settings'),
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
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Donatqe",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    onPressed: () {
                      Get.to(TermsAndConditionsPage());
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Copyright © 2024 [TradHut Ghana]\n\n"
                "All rights reserved.\n\n"
                "This QR code generator app, including its code, design, functionality, and user interface, is protected under copyright law and international treaties. No part of this app may be reproduced, distributed, or transmitted in any form or by any means, electronic or mechanical, including photocopying, recording, or by any information storage and retrieval system, without written permission from the copyright holder.\n\n"
                "Violations of copyright law are punishable by law, and may result in civil and criminal penalties.",
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
