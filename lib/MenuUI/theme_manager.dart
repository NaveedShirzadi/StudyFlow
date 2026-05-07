import 'package:flutter/material.dart';

class ThemeColors {
  final Color primary;
  final Color secondary;
  ThemeColors(this.primary, this.secondary);
}

class ThemeManager {
  // Default blue gradient colors
  static const Color defaultPrimary = Color.fromARGB(255, 47, 158, 249);
  static const Color defaultSecondary = Color.fromARGB(255, 197, 227, 252);

  // The Notifier that handles real-time updates
  static final ValueNotifier<ThemeColors> themeNotifier = ValueNotifier(
    ThemeColors(defaultPrimary, defaultSecondary),
  );

  // These getters make it easy for other files to read the current colors
  static Color get primaryColor => themeNotifier.value.primary;
  static Color get secondaryColor => themeNotifier.value.secondary;

  static void updateColors(Color color1, Color color2) {
    themeNotifier.value = ThemeColors(color1, color2);
  }

  static void resetToDefault() {
    themeNotifier.value = ThemeColors(defaultPrimary, defaultSecondary);
  }

  static Color get contrastColor {
    return primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, colors, childWidget) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.secondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: childWidget, // The Scaffold goes here
        );
      },
      child: child,
    );
  }
}