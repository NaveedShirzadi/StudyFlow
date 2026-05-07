import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockInPage extends StatefulWidget {

  final int sessionMinutes;
  final String ambience;

  const LockInPage({
    super.key,
    required this.sessionMinutes,
    required this.ambience,
  });

  @override
  State<LockInPage> createState() => _LockInPageState();
}

class _LockInPageState extends State<LockInPage> {

  late int seconds;

  Timer? timer;

  bool isBreak = false;
  bool isPaused = false;

  final int studyTime = 1500;
  final int breakTime = 300;

  @override
  void initState() {

    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    seconds = widget.sessionMinutes * 60;

    startTimer();
  }

  @override
  void dispose() {

    timer?.cancel();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

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

              startTimer();
            }
          });
        }
      },
    );
  }

  void pauseTimer() {

    timer?.cancel();

    setState(() {
      isPaused = true;
    });
  }

  void resumeTimer() {

    startTimer();

    setState(() {
      isPaused = false;
    });
  }

  void resetTimer() {

    timer?.cancel();

    setState(() {

      seconds = widget.sessionMinutes * 60;
      isBreak = false;
      isPaused = false;
    });

    startTimer();
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

      body: Stack(

        children: [

          Container(

            decoration: const BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  Color(0xFF000000),
                  Color(0xFF071A2E),
                  Color(0xFF001F3F),
                ],
              ),
            ),
          ),

          Center(

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(

                  width: 260,
                  height: 260,

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.cyanAccent,
                      width: 5,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color:
                            Colors.cyanAccent.withValues(alpha: 0.8),
                        blurRadius: 35,
                        spreadRadius: 8,
                      ),
                    ],
                  ),

                  child: Center(

                    child: Text(
                      formatTime(seconds),

                      style: const TextStyle(
                        fontSize: 62,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                Text(
                  isBreak
                      ? "BREAK MODE"
                      : "LOCK IN",

                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  isBreak
                      ? "Recover. Breathe. Reset."
                      : "No distractions. Just focus.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 60),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.cyanAccent,

                        foregroundColor:
                            Colors.black,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),

                        elevation: 10,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                      ),

                      onPressed: resetTimer,

                      icon: const Icon(
                        Icons.restart_alt,
                      ),

                      label: const Text(
                        "Restart",

                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.white12,

                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                      ),

                      onPressed: () {

                        if (isPaused) {

                          resumeTimer();

                        } else {

                          pauseTimer();
                        }
                      },

                      icon: Icon(
                        isPaused
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),

                      label: Text(
                        isPaused
                            ? "Resume"
                            : "Pause",
                      ),
                    ),

                    const SizedBox(width: 20),

                    ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.white12,

                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                      ),

                      onPressed: () {

                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.logout,
                      ),

                      label: const Text(
                        "Exit",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}