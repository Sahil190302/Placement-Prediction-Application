import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResumeAnalyzerScreen extends StatefulWidget {
  @override
  _ResumeAnalyzerScreenState createState() => _ResumeAnalyzerScreenState();
}

class _ResumeAnalyzerScreenState extends State<ResumeAnalyzerScreen> with SingleTickerProviderStateMixin {
  String? analysisResult;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool showResultCard = false;

  Future<void> pickAndUploadResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
      withData: kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      try {
        setState(() {
          isLoading = true;
          analysisResult = null;
          showResultCard = false;
        });

        final url = Uri.parse("http://localhost:5000/resume-analyzer");

        var request = http.MultipartRequest('POST', url);

        if (kIsWeb) {
          Uint8List? fileBytes = file.bytes;
          if (fileBytes == null) throw Exception("File bytes are null");

          request.files.add(http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: file.name,
          ));
        } else {
          if (file.path == null) throw Exception("File path is null");

          request.files.add(await http.MultipartFile.fromPath(
            'file',
            file.path!,
          ));
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          final data = json.decode(responseBody);

          final double atsScore = (data['ats_score'] ?? 0).toDouble();
          final List<dynamic> matched = data['matched_keywords'] ?? [];
          final List<dynamic> missing = data['missing_keywords'] ?? [];

          String feedback = "📊 ATS Score: ${atsScore.toStringAsFixed(1)}%\n\n";
          feedback += "✅ Matched Keywords: ${matched.join(', ')}\n\n";
          if (missing.isEmpty) {
            feedback += "🎉 Great! No major missing keywords found.\n";
          } else {
            feedback += "💡 Suggestions:\n";
            for (var keyword in missing) {
              feedback += "• Add or improve on: $keyword\n";
            }
          }

          setState(() {
            analysisResult = feedback;
            showResultCard = true;
          });

          await Future.delayed(Duration(milliseconds: 100));
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          throw Exception("Server responded with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
        setState(() {
          analysisResult = "❌ An error occurred while analyzing the resume.";
          showResultCard = true;
        });
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FA),
      appBar: AppBar(
        title: const Text("Resume Analyzer"),
        backgroundColor: Colors.deepPurpleAccent.shade200,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.assignment_ind_rounded, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Upload Your Resume",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "AI-powered resume analysis with suggestions for improvement.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),

            // Upload Button
            GestureDetector(
              onTap: pickAndUploadResume,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_file_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Choose Resume File",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Loading Indicator
            if (isLoading)
              Column(
                children: const [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 10),
                  Text("Analyzing your resume...", style: TextStyle(color: Colors.black54)),
                ],
              ),

            // Analysis Result Card
            AnimatedOpacity(
              opacity: showResultCard ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: analysisResult != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          "Analysis Result",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      analysisResult!,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
