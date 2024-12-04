import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_2/modules/home/home_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          bodySmall: TextStyle(color: const Color(0xff424d82)),
          bodyLarge: TextStyle(color: const Color(0xff424d82)),
          bodyMedium: TextStyle(color: const Color(0xff424d82)),
          displayLarge: TextStyle(color: const Color(0xff424d82)),
          displayMedium: TextStyle(color: const Color(0xff424d82)),
          displaySmall: TextStyle(color: const Color(0xff424d82)),
          headlineLarge: TextStyle(color: const Color(0xff424d82)),
          headlineMedium: TextStyle(color: const Color(0xff424d82)),
          headlineSmall: TextStyle(color: const Color(0xff424d82)),
          labelLarge: TextStyle(color: const Color(0xff424d82)),
          labelMedium: TextStyle(color: const Color(0xff424d82)),
          labelSmall: TextStyle(color: const Color(0xff424d82)),
          titleLarge: TextStyle(color: const Color(0xff424d82)),
          titleMedium: TextStyle(color: const Color(0xff424d82)),
          titleSmall: TextStyle(color: const Color(0xff424d82)),
        ),
      ),
    );
  }
}
