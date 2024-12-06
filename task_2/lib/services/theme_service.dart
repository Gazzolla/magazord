import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'theme_service.g.dart';

class ThemeService = _ThemeServiceBase with _$ThemeService;

abstract class _ThemeServiceBase with Store {
  ThemeData lightTheme = ThemeData.light().copyWith(cardColor: Colors.white);
  ThemeData darkTheme = ThemeData.dark().copyWith(cardColor: const Color(0xFF16324A));

  @observable
  bool isDarkTheme = false;

  @action
  void toggleTheme() => isDarkTheme = !isDarkTheme;

  @action
  void setTheme(bool value) => isDarkTheme = value;
}
