import 'package:flutter/material.dart';

import 'calander_menu_ui.dart';
import '../study_mode/study_mode_page.dart';
import 'theme_manager.dart';

class PostLoginMenuUI extends StatefulWidget {
  const PostLoginMenuUI({super.key});

  @override
  State<PostLoginMenuUI> createState() => _PostLoginMenuUIState();
}

class _PostLoginMenuUIState extends State<PostLoginMenuUI> {
  static const double _bubbleWidth = 280;
  static const double _bubbleHeight = 50;

  void _openAiAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AiAssistantSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeColors>(
      valueListenable: ThemeManager.themeNotifier,
      builder: (context, theme, _) {
        final Color contrast = ThemeManager.contrastColor;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, theme.secondary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Menu',
                style: TextStyle(color: contrast),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: contrast),
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _bubbleWidth,
                        height: _bubbleHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CalendarMenuUi(),
                              ),
                            );

                            if (mounted) setState(() {});
                          },
                          child: const Text(
                            'Calendar & Schedule',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: _bubbleWidth,
                        height: _bubbleHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StudyModePage(),
                              ),
                            );

                            if (mounted) setState(() {});
                          },
                          child: const Text(
                            'Study Mode',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.primary.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    onPressed: _openAiAssistant,
                    child: const Icon(Icons.smart_toy),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}