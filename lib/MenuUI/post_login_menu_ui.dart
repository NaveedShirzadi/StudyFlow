import 'package:flutter/material.dart';
import 'calander_menu_ui.dart';
import 'study_board_menu_ui.dart';
import '../study_mode/study_mode_page.dart';

class PostLoginMenuUI extends StatelessWidget {
  const PostLoginMenuUI({super.key});

  @override
  Widget build(BuildContext context) {
    const double bubbleWidth = 280;
    const double bubbleHeight = 50;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 158, 249),
              Color.fromARGB(255, 197, 227, 252),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: bubbleWidth,
                    height: bubbleHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CalendarMenuUi(),
                          ),
                        );
                      },
                      child: const Text(
                        'Calendar View',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: bubbleWidth,
                    height: bubbleHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudyModePage(),
                          ),
                        );
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
                  // Add AI Assistant action here
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


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostLoginMenuUI(),
    ),
  );
}