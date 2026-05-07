import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

class PdfAiSummaryPage extends StatefulWidget {
  final Uint8List fileBytes; 
  final String fileName; 

  const PdfAiSummaryPage({
    super.key,
    required this.fileBytes, 
    required this.fileName,
  });

  @override
  State<PdfAiSummaryPage> createState() => _PdfAiSummaryPageState();
}

class _PdfAiSummaryPageState extends State<PdfAiSummaryPage> {
  String _result = '';
  String _fileName = '';
  bool _isLoading = false;

  Future<void> _summarizePdf() async {
    setState(() {
      _isLoading = true;
      _result = '';
      _fileName = widget.fileName;
    });

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
        );

      final prompt = TextPart("""
Read this PDF and give me:

1. A clear summary
2. The main topics
3. Important deadlines or dates if any
4. Action items for a student
5. A short study/review checklist

Format the answer neatly.
""");

      final pdfPart = InlineDataPart(
        'application/pdf',
        widget.fileBytes,
      );

      final response = await model.generateContent([
        Content.multi([prompt, pdfPart])
      ]);

      setState(() {
        _result = response.text ?? 'No summary generated.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error summarizing PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF AI Summarizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _summarizePdf,
              child: const Text('Summarize Pdf'),
            ),

            const SizedBox(height: 12),

            if (_fileName.isNotEmpty)
              Text(
                'File: $_fileName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 16),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Text(
                        _result.isEmpty
                            ? 'Upload a PDF to generate a summary.'
                            : _result,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
