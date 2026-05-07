import 'dart:async';
import 'package:flutter/material.dart';
import 'lockin_page.dart';

class CountdownPage extends StatefulWidget {

  final int sessionMinutes;
  final String ambience;

  const CountdownPage({
    super.key,
    required this.sessionMinutes,
    required this.ambience,
  });

  @override
  State<CountdownPage> createState() =>
      _CountdownPageState();
}

class _CountdownPageState
    extends State<CountdownPage> {

  int countdown = 3;

  @override
  void initState() {

    super.initState();

    Timer.periodic(

      const Duration(seconds: 1),

      (timer) {

        if (countdown > 1) {

          setState(() {
            countdown--;
          });

        } else {

          timer.cancel();

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (context) => LockInPage(
                sessionMinutes:
                    widget.sessionMinutes,
                ambience: widget.ambience,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(
              countdown.toString(),

              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 150,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "LOCKING IN...",

              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}