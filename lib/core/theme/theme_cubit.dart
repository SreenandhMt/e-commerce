import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/hive_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final index = HiveService.getThemeModeIndex();
    emit(ThemeMode.values[index]);
  }

  void toggleTheme(BuildContext context) {
    final currentThemeMode = state;
    ThemeMode nextMode;

    if (currentThemeMode == ThemeMode.system) {
      final platformBrightness = MediaQuery.platformBrightnessOf(context);
      nextMode = platformBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    } else {
      nextMode = currentThemeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }

    HiveService.saveThemeMode(nextMode.index);
    emit(nextMode);
  }
}
