import 'package:flutter/material.dart';
import 'meditation_page.dart';

class FocusSetupPage extends StatefulWidget {
  const FocusSetupPage({super.key});

  @override
  State<FocusSetupPage> createState() => _FocusSetupPageState();
}

class _FocusSetupPageState extends State<FocusSetupPage> {

  int selectedMinutes = 25;

  String selectedAmbience = "Ocean Waves";

  final List<int> durations = [
    25,
    45,
    60,
    90,
  ];

  final List<String> ambienceOptions = [
    "Ocean Waves",
    "Rain",
    "Forest",
    "Fireplace",
    "Cafe",
    "No Sound",
  ];

  Widget buildDurationButton(int minutes) {

    bool isSelected = selectedMinutes == minutes;

    return GestureDetector(

      onTap: () {

        setState(() {
          selectedMinutes = minutes;
        });
      },

      child: Container(

        width: 80,
        height: 60,

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.cyanAccent
              : Colors.white12,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Colors.cyanAccent,
            width: 2,
          ),
        ),

        child: Center(

          child: Text(
            "${minutes}m",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,

              color: isSelected
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAmbienceButton(String ambience) {

    bool isSelected =
        selectedAmbience == ambience;

    return GestureDetector(

      onTap: () {

        setState(() {
          selectedAmbience = ambience;
        });
      },

      child: Container(

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.cyanAccent
              : Colors.white12,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Colors.cyanAccent,
            width: 2,
          ),
        ),

        child: Text(
          ambience,

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,

            color: isSelected
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text(
          "Focus Setup",
        ),

        centerTitle: true,

        backgroundColor: Colors.transparent,

        elevation: 0,
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 20),

              const Center(

                child: Icon(
                  Icons.bolt,
                  color: Colors.cyanAccent,
                  size: 90,
                ),
              ),

              const SizedBox(height: 25),

              const Center(

                child: Text(
                  "LOCK IN",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                "Choose Duration",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Row(

                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,

                children:
                    durations.map(
                      (minutes) {

                        return buildDurationButton(
                          minutes,
                        );
                      },
                    ).toList(),
              ),

              const SizedBox(height: 55),

              const Text(
                "Choose Ambience",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Wrap(

                spacing: 15,
                runSpacing: 15,

                children:
                    ambienceOptions.map(
                      (ambience) {

                        return buildAmbienceButton(
                          ambience,
                        );
                      },
                    ).toList(),
              ),

              const SizedBox(height: 70),

              Center(

                child: ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.cyanAccent,

                    foregroundColor: Colors.black,

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 18,
                    ),

                    elevation: 12,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22),
                    ),
                  ),

                  onPressed: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                            MeditationPage(
                              sessionMinutes:
                                  selectedMinutes,
                              ambience:
                                  selectedAmbience,
                            ),
                      ),
                    );
                  },

                  icon: const Icon(Icons.play_arrow),

                  label: const Text(

                    "Begin Focus Session",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}