import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  int seconds = 1500;

  Timer? timer;

  bool isRunning = false;
  bool isBreak = false;

  final int studyTime = 1500;
  final int breakTime = 300;

  void startTimer() {

    timer = Timer.periodic(
      const Duration(seconds: 1),

      (timer) {

        if (seconds > 0) {

          setState(() {
            seconds--;
          });

        } else {

          timer.cancel();

          setState(() {

            if (!isBreak) {

              isBreak = true;
              seconds = breakTime;

              startTimer();

            } else {

              isBreak = false;
              seconds = studyTime;
            }
          });
        }
      },
    );

    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {

    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {

    timer?.cancel();

    setState(() {

      seconds = studyTime;
      isRunning = false;
      isBreak = false;
    });
  }

  String formatTime(int totalSeconds) {

    int minutes = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;

    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: Text(
          isBreak ? "BREAK MODE" : "LOCK IN",
        ),

        centerTitle: true,

        backgroundColor: Colors.transparent,

        elevation: 0,

        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              isBreak
                  ? Icons.nightlight_round
                  : Icons.bolt,

              size: 90,

              color: Colors.cyanAccent,
            ),

            const SizedBox(height: 25),

            Text(
              isBreak ? "BREAK" : "FOCUS",

              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),

            const SizedBox(height: 50),

            Container(

              width: 270,
              height: 270,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color: Colors.black,

                border: Border.all(
                  color: Colors.cyanAccent,
                  width: 5,
                ),

                boxShadow: [

                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha:0.7),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),

              child: Center(

                child: Text(
                  formatTime(seconds),

                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.cyanAccent,

                    foregroundColor: Colors.black,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),

                    elevation: 10,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  onPressed:
                      isRunning
                          ? pauseTimer
                          : startTimer,

                  icon: Icon(
                    isRunning
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),

                  label: Text(
                    isRunning
                        ? "Pause"
                        : "Start",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 25),

                ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.white12,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                  ),

                  onPressed: resetTimer,

                  icon: const Icon(Icons.restart_alt),

                  label: const Text(
                    "Reset",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              "NO DISTRACTIONS. JUST FOCUS.",

              style: TextStyle(
                color: Colors.white54,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}