import 'package:flutter/material.dart';
var appThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 252, 100, 1),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(TextStyle(
          fontSize: 21,
          color: Color.fromARGB(255, 252, 100, 1),
        )),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return size 40, otherwise 20
        if (states.contains(MaterialState.pressed)) {
          return const Color.fromARGB(255, 252, 100, 1);
        }
        return const Color.fromARGB(255, 252, 100, 1);
      }),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromARGB(255, 252, 100, 1), //  <-- dark color
      textTheme:
      ButtonTextTheme.accent, //  <-- this auto selects the right color
    ),
    cardTheme: const CardTheme(
        shadowColor: Colors.black,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 3
    ),
    primaryColor: const Color.fromARGB(255, 252, 100, 1),
    backgroundColor: const Color.fromARGB(255, 238, 238, 238),
    useMaterial3: true,
    textTheme: const TextTheme(

      /// В приложении должны использоваться только стили определенные ниже
      /// Используй их appThemeData.textTheme.*TextStyleName*
      displayLarge:
      TextStyle(fontSize: 57, color: Color.fromARGB(255, 116, 116, 117)),
      displayMedium:
      TextStyle(fontSize: 45, color: Color.fromARGB(255, 116, 116, 117)),
      displaySmall:
      TextStyle(fontSize: 36, color: Color.fromARGB(255, 116, 116, 117)),

      headlineLarge:
      TextStyle(fontSize: 32, color: Color.fromARGB(255, 116, 116, 117)),
      headlineMedium:
      TextStyle(fontSize: 28, color: Color.fromARGB(255, 116, 116, 117)),
      headlineSmall:
      TextStyle(fontSize: 24, color: Color.fromARGB(255, 84, 84, 84)),

      titleLarge: TextStyle(fontSize: 25),
      titleMedium: TextStyle(fontSize: 17),
      titleSmall:
      TextStyle(fontSize: 15, color: Color.fromARGB(255, 84, 84, 84)),

      labelLarge: TextStyle(fontSize: 14),
      labelMedium: TextStyle(fontSize: 12),
      labelSmall: TextStyle(fontSize: 11),

      bodyLarge: TextStyle(fontSize: 23),
      bodyMedium: TextStyle(fontSize: 20),
      bodySmall: TextStyle(fontSize: 14),

      /// используй код ниже чтобы быстро проверить все стилли
      // Text("Lorem Ипсум",style: appThemeData.textTheme.displayLarge,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.displayMedium,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.displaySmall,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.titleLarge,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.titleMedium,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.titleSmall,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.headlineLarge,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.headlineMedium,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.headlineSmall,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.labelLarge,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.labelMedium,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.labelSmall,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.bodyLarge,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.bodyMedium,),
      // Text("Lorem Ипсум",style: appThemeData.textTheme.bodySmall,),
    ),
    colorScheme: const ColorScheme(
        shadow: Colors.black26,
        primary: Color.fromARGB(255, 91, 91, 91),
        secondary: Color.fromARGB(255, 255, 255, 255),
        brightness: Brightness.light,
        onPrimary: Color.fromARGB(255, 0, 0, 0),
        onSecondary: Color.fromARGB(255, 252, 100, 1),
        background: Colors.white,
        error: Colors.red,
        onError: Colors.black,
        onBackground: Colors.black,
        surface: Color.fromARGB(255, 243, 243, 243),
        onSurface: Color.fromARGB(255, 252, 100, 1),
        tertiary: Color.fromARGB(255, 255, 255, 255)));

var appDarkThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 252, 100, 1)
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(TextStyle(
            fontSize: 21,
            color: Color.fromARGB(255, 252, 100, 1)
        )),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return size 40, otherwise 20
        if (states.contains(MaterialState.pressed)) {
          return const Color.fromARGB(255, 252, 100, 1);
        }
        return const Color.fromARGB(255, 252, 100, 1);
      }),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromARGB(255, 252, 100, 1),
      textTheme:
      ButtonTextTheme.accent,
    ),
    cardTheme: const CardTheme(
      shadowColor: Colors.black,
      color: Color.fromARGB(255, 51, 51, 51),
    ),
    primaryColor: const Color.fromARGB(255, 252, 100, 1),

    backgroundColor:
    const Color.fromARGB(255, 51, 51, 51),
    scaffoldBackgroundColor: const Color.fromARGB(255, 21, 21, 21),
    useMaterial3: true,
    textTheme: const TextTheme(

      /// В приложении должны использоваться только стили определенные ниже
      /// Используй их appThemeData.textTheme.*TextStyleName*
      displayLarge:
      TextStyle(fontSize: 57, color: Color.fromARGB(
          255, 241, 241, 241)),
      displayMedium:
      TextStyle(fontSize: 45, color: Color.fromARGB(
          255, 241, 241, 241)),
      displaySmall:
      TextStyle(fontSize: 36, color: Color.fromARGB(
          255, 241, 241, 241)),

      headlineLarge:
      TextStyle(fontSize: 32, color: Color.fromARGB(
          255, 241, 241, 241)),
      headlineMedium:
      TextStyle(fontSize: 28, color: Color.fromARGB(
          255, 241, 241, 241)),
      headlineSmall:
      TextStyle(fontSize: 24, color: Color.fromARGB(
          255, 241, 241, 241)),

      titleLarge: TextStyle(fontSize: 25, color: Color.fromARGB(
          255, 241, 241, 241)),
      titleMedium: TextStyle(fontSize: 17, color: Color.fromARGB(
          255, 241, 241, 241)),
      titleSmall:
      TextStyle(fontSize: 15, color: Color.fromARGB(
          255, 241, 241, 241)),

      labelLarge: TextStyle(fontSize: 14, color: Color.fromARGB(
          255, 241, 241, 241)),
      labelMedium: TextStyle(fontSize: 12, color: Color.fromARGB(
          255, 241, 241, 241)),
      labelSmall: TextStyle(fontSize: 11, color: Color.fromARGB(
          255, 241, 241, 241)),

      bodyLarge: TextStyle(fontSize: 23, color: Color.fromARGB(
          255, 241, 241, 241)),
      bodyMedium: TextStyle(fontSize: 20, color: Color.fromARGB(
          255, 241, 241, 241)),
      bodySmall: TextStyle(fontSize: 14, color: Color.fromARGB(
          255, 241, 241, 241)),
    ),
    colorScheme: const ColorScheme(
      shadow: Colors.black26,
      primary: Color.fromARGB(255, 161, 161, 161),
      secondary: Color.fromARGB(255, 224, 19, 19),
      brightness: Brightness.dark,
      onPrimary: Color.fromARGB(255, 3, 3, 3),
      onSecondary: Color.fromARGB(255, 225, 225, 225),
      background: Color.fromARGB(255, 51, 51, 51),
      error: Colors.red,
      onError: Colors.black,
      onBackground: Colors.black,
      surface: Color.fromARGB(255, 51, 51, 51),
      onSurface: Color.fromARGB(255, 252, 100, 1),
      tertiary: Color.fromARGB(255, 51, 51, 51),));

class AtbAdditionalColors {
  static Color primalTranslucent = const Color.fromARGB(228, 255, 105, 0);
  static Color planBorderElementTranslucent = const Color.fromARGB(
      155, 0, 104, 255);
  static Color debugTranslucent = const Color.fromARGB(116, 237, 0, 255);
  static Color lightGray = const Color.fromARGB(
      255, 245, 245, 245);
  static Color black10 = const Color.fromARGB(
      26, 0, 0, 0);
  static Color black7 = const Color.fromARGB(
      18, 0, 0, 0);
}