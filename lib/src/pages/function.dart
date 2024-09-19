import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

String generateRandomName({int length = 10}) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}



Future<void> launchTheUrl(url) async {
final Uri url0 = Uri.parse(url);

  if (!await launchUrl(url0)) {
    throw Exception('Could not launch $url0');
  }
}


