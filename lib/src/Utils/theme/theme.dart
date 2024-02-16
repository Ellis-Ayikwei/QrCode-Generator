import 'package:flutter/material.dart';

const Color obsidian = Color.fromARGB(255, 28, 28, 28);
const Color kScafold = Color.fromARGB(154, 28, 28, 28);
const Color Goldish = Color(0xFFA67C00);
const Color lightGray = Color(0xFFEAEAEA);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  toggleButtonsTheme: ToggleButtonsThemeData(
      disabledColor: Colors.grey[50], borderColor: Colors.grey, color: Goldish),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) => lightGray),
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) => Goldish),
  )),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 96, fontWeight: FontWeight.w300, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 60, fontWeight: FontWeight.w400, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 48, fontWeight: FontWeight.w400, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
    bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
    bodySmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 255, 255, 255)),
    // Remove the shadow on the back button in the search bar
    foregroundColor: Colors.white,
    backgroundColor: Goldish,

    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Goldish).copyWith(
    primary: Goldish,
    surface: lightGray,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: kScafold,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Goldish; // Use a custom color for selected state
      } else if (states.contains(MaterialState.hovered)) {
        return Colors.limeAccent; // Adjust for hovered state (optional)
      } else {
        return Color.fromARGB(
            255, 74, 74, 74); // Default color for other states
      }
    }),
    trackColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return Color.fromARGB(
            255, 224, 223, 223); // Adjust track color based on selection
      } else {
        return Colors.grey; // Default track color
      }
    }),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
      disabledColor: Colors.grey[50], borderColor: Colors.grey, color: Goldish),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) => Goldish,
    ),
  )),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 96, fontWeight: FontWeight.w300, color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 60, fontWeight: FontWeight.w400, color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 48, fontWeight: FontWeight.w400, color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: 34, fontWeight: FontWeight.w400, color: Colors.white),
    headlineSmall: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
    bodySmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white54),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 255, 255, 255)),
    // Remove the shadow on the back button in the search bar
    foregroundColor: Colors.white,
    backgroundColor: obsidian,
    actionsIconTheme: IconThemeData(color: Colors.white),

    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: obsidian).copyWith(
      primary: lightGray,
      surface: obsidian,
      secondary: Colors.grey,
      onSurface: Colors.white,
      onBackground: Colors.white,
      brightness: Brightness.dark),
);
