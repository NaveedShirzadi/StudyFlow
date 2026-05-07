import 'package:flutter/material.dart';
import 'calander_menu_ui.dart';
import 'study_board_menu_ui.dart';
import 'theme_manager.dart';

class PostLoginMenuUI extends StatefulWidget {
  const PostLoginMenuUI({super.key});

  @override
  State<PostLoginMenuUI> createState() => _PostLoginMenuUIState();
}

class _PostLoginMenuUIState extends State<PostLoginMenuUI> {
  static const double _bubbleWidth = 280;
  static const double _bubbleHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Menu',
          style: TextStyle(color: ThemeManager.contrastColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundWrapper(
        child: Stack(
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
                        // Refreshes contrast colors if coming back from calendar/settings
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
                            builder: (context) => const StudyBoardMenuUI(),
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) => const AiAssistantSheet(),
                  );
                },
                child: const Icon(Icons.smart_toy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
