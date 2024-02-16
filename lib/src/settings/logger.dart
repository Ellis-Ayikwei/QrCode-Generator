import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Logger {
  static late File _logFile;

  static Future<void> init() async {
    // Get the app's documents directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    // Define the file path for the log file
    String logFilePath = '${appDocDir.path}/app_log.txt';
    // Open or create the log file
    _logFile = File(logFilePath);
    if (!_logFile.existsSync()) {
      await _logFile.create();
    }
  }

  static Future<void> log(String message) async {
    String logEntry = '${DateTime.now()}: $message\n';
    // Append the log entry to the log file
    await _logFile.writeAsString(logEntry, mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    // Read the contents of the log file
    return _logFile.readAsString();
  }
}
