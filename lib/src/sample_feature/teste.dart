import 'package:flutter/material.dart';

class ToggleSwitchExample extends StatefulWidget {
  @override
  _ToggleSwitchExampleState createState() => _ToggleSwitchExampleState();
}

class _ToggleSwitchExampleState extends State<ToggleSwitchExample> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toggle Switch Example'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Off'),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Text('On'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ToggleSwitchExample(),
  ));
}
