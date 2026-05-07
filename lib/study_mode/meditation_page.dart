import 'dart:async';
import 'package:flutter/material.dart';
import 'quote_page.dart';

class MeditationPage extends StatefulWidget {

  final int sessionMinutes;
  final String ambience;

  const MeditationPage({
    super.key,
    required this.sessionMinutes,
    required this.ambience,
  });

  @override
  State<MeditationPage> createState() =>
      _MeditationPageState();
}

class _MeditationPageState
    extends State<MeditationPage> {

  @override
  void initState() {

    super.initState();

    Timer(
      const Duration(seconds: 5),
() {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context) => QuotePage(
            sessionMinutes:
                widget.sessionMinutes,
            ambience: widget.ambience,
          ),
        ),
      );
    },
  );
      
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(30),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Container(

                width: 180,
                height: 180,

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: Colors.cyanAccent,
                    width: 4,
                  ),

                  boxShadow: [

                    BoxShadow(
                      color:
                          Colors.cyanAccent.withValues(alpha:0.7),
                      blurRadius: 35,
                      spreadRadius: 8,
                    ),
                  ],
                ),

                child: const Center(

                  child: Icon(
                    Icons.rocket_launch,
                    size: 90,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                "Take a deep breath.",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Relax your mind.\nPrepare to focus.",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "LOCKING IN...",

                style: TextStyle(
                  color: Colors.cyanAccent,
                  letterSpacing: 4,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}