import 'package:flutter/material.dart';

class StudyBoardMenuUI extends StatelessWidget {
  static const routeName = '/studyBoardMenu';

  const StudyBoardMenuUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Study Board Screen'),
      ),
    );
  }
}