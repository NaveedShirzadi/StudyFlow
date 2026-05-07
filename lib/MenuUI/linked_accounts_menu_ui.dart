import 'package:flutter/material.dart';
import 'theme_manager.dart';

class LinkedAccountsMenuUi extends StatelessWidget {
  const LinkedAccountsMenuUi({super.key});

  static const double _buttonWidth = 280;
  static const double _buttonHeight = 55;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Linked Accounts'),
        centerTitle: true, backgroundColor: Colors.transparent, elevation: 0,
        iconTheme: IconThemeData(color: ThemeManager.contrastColor),
        titleTextStyle: TextStyle(color: ThemeManager.contrastColor, fontSize: 20),
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: _buttonWidth, height: _buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {}, icon: const Icon(Icons.school, size: 24),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  label: const Text('Canvas', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: _buttonWidth, height: _buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {}, icon: const Icon(Icons.auto_awesome, size: 24),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  label: const Text('Gemini', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}