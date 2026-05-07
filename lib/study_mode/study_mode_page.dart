import 'dart:math';
import 'package:flutter/material.dart';

class StudyModePage extends StatefulWidget {
  const StudyModePage({super.key});

  @override
  State<StudyModePage> createState() => _StudyModePageState();
}

class _StudyModePageState extends State<StudyModePage> {

  final List<String> quotes = [
    "Stay focused.",
    "Small progress is still progress.",
    "Discipline beats motivation.",
    "One session at a time.",
    "Success starts with consistency.",
    "Your future self will thank you.",
    "Focus now, relax later.",
  ];

  late String randomQuote;

  @override
  void initState() {
    super.initState();

    randomQuote = quotes[
      Random().nextInt(quotes.length)
    ];
  }

  Widget buildButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {

    return SizedBox(

      width: 250,
      height: 105,

      child: ElevatedButton(

        style: ElevatedButton.styleFrom(

          backgroundColor: const Color(0xFFEAEAEA),

          foregroundColor: Colors.black,

          elevation: 8,

          shadowColor: Colors.black38,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),

        onPressed: onTap,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),

          child: Row(

            children: [

              Container(

                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFF4A90E2),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFBFE9FF),

      appBar: AppBar(

        title: const Text(
          "Study Mode",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),

        centerTitle: true,

        backgroundColor: Colors.transparent,

        elevation: 0,
      ),

      body: Center(

        child: Container(

          width: 340,
          height: 720,

          decoration: BoxDecoration(

            gradient: const LinearGradient(

              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              colors: [
                Color(0xFF7FC8F8),
                Color(0xFF5AA9E6),
              ],
            ),

            borderRadius: BorderRadius.circular(55),

            boxShadow: [

              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Padding(

            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 30,
            ),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [

                Column(

                  children: [

                    const Icon(
                      Icons.menu_book_rounded,
                      size: 70,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "LOCK IN",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(

                        color: Colors.white.withOpacity(0.18),

                        borderRadius: BorderRadius.circular(25),
                      ),

                      child: Text(
                        randomQuote,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                buildButton(
                  title: "Timer",
                  subtitle: "Pomodoro focus sessions",
                  icon: Icons.timer,

                  onTap: () {
                    // Timer page later
                  },
                ),

                buildButton(
                  title: "Lock In Mode",
                  subtitle: "Minimize distractions",
                  icon: Icons.lock,

                  onTap: () {
                    // Lock In page later
                  },
                ),

                buildButton(
                  title: "Progress Display",
                  subtitle: "Track study performance",
                  icon: Icons.bar_chart,

                  onTap: () {
                    // Progress page later
                  },
                ),

                buildButton(
                  title: "Motivation",
                  subtitle: "Generate a new quote",
                  icon: Icons.auto_awesome,

                  onTap: () {

                    setState(() {

                      randomQuote = quotes[
                        Random().nextInt(quotes.length)
                      ];

                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}