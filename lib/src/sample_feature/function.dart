import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';

String generateRandomName({int length = 10}) {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}



