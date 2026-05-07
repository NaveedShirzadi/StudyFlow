import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'countdown_page.dart';


class QuotePage extends StatefulWidget {

  final int sessionMinutes;
  final String ambience;

  const QuotePage({
    super.key,
    required this.sessionMinutes,
    required this.ambience,
  });

  @override
  State<QuotePage> createState() =>
      _QuotePageState();
}

class _QuotePageState
    extends State<QuotePage> {

  final List<String> quotes = [

    "\"The successful warrior is the average man, with laser-like focus.\"\n— Bruce Lee",

    "\"Success is the sum of small efforts repeated daily.\"\n— Robert Collier",

    "\"Discipline is choosing between what you want now and what you want most.\"\n— Abraham Lincoln",

    "\"Your future is created by what you do today.\"\n— Robert Kiyosaki",

    "\"Focus on being productive instead of busy.\"\n— Tim Ferriss",
  ];

  late String selectedQuote;

  @override
  void initState() {

    super.initState();

    selectedQuote =
        quotes[Random().nextInt(quotes.length)];

    Timer(
      const Duration(seconds: 5),

      () {
         Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (context) => CountdownPage(
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

          padding: const EdgeInsets.all(35),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.auto_awesome,
                color: Colors.cyanAccent,
                size: 90,
              ),

              const SizedBox(height: 45),

              Text(
                selectedQuote,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.7,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "LOCKING IN...",

                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}