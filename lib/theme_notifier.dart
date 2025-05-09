import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  Brightness _brightness = Brightness.dark;

  Brightness get brightness => _brightness;

  void toggleBrightness() {
    _brightness = _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    notifyListeners();
  }
}