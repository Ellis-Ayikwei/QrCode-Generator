import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  void checkConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectivity Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Internet Connection:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            _connectionStatus == ConnectivityResult.mobile
                ? Text(
                    "Connected to Mobile Data",
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )
                : _connectionStatus == ConnectivityResult.wifi
                    ? Text(
                        "Connected to Wi-Fi",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      )
                    : Text(
                        "No Internet Connection",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
          ],
        ),
      ),
    );
  }
}
