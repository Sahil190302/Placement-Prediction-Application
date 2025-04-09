import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PlacementPredictionScreen extends StatefulWidget {
  @override
  _PlacementPredictionScreenState createState() => _PlacementPredictionScreenState();
}

class _PlacementPredictionScreenState extends State<PlacementPredictionScreen> {
  final TextEditingController cgpaController = TextEditingController();
  final TextEditingController projectsController = TextEditingController();
  final TextEditingController internshipsController = TextEditingController();
  final TextEditingController certificationsController = TextEditingController();
  final TextEditingController aptitudeController = TextEditingController();
  final TextEditingController softSkillController = TextEditingController();
  final TextEditingController technicalTestController = TextEditingController();
  final TextEditingController programQueController = TextEditingController();

  String result = "Enter details and press Predict";
  String suggestion = "";
  String? pdfUrl;
  bool isDownloading = false;

  Future<void> predictPlacement() async {
    final url = Uri.parse("http://localhost:5000/predict");

    Map<String, dynamic> requestBody = {
      "features": [
        double.tryParse(cgpaController.text) ?? 0.0,
        int.tryParse(projectsController.text) ?? 0,
        int.tryParse(internshipsController.text) ?? 0,
        int.tryParse(certificationsController.text) ?? 0,
        double.tryParse(aptitudeController.text) ?? 0.0,
        double.tryParse(softSkillController.text) ?? 0.0,
        double.tryParse(technicalTestController.text) ?? 0.0,
        programQueController.text.isNotEmpty ? int.tryParse(programQueController.text) ?? 0 : null
      ]
    };

    requestBody["features"].removeWhere((element) => element == null);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          final prediction = responseData["placement_prediction"];
          final probability = (responseData["probability"] * 100).toStringAsFixed(2);
          pdfUrl = responseData["pdf_report"];

          if (prediction == 1) {
            result = "🎉 Congratulations! You are likely to be placed.\nProbability: $probability%";
            suggestion = "";

            double aptitude = double.tryParse(aptitudeController.text) ?? 0.0;
            double technical = double.tryParse(technicalTestController.text) ?? 0.0;

            if (aptitude < 80) suggestion += "🧠 Consider improving your aptitude skills.\n";
            if (technical < 80) suggestion += "💻 Work on your technical test performance.";
          } else {
            result = "😔 You might not get placed. Keep improving!\nProbability: $probability%";
            suggestion = "💡 Improve technical skills, gain experience, and boost soft skills.";
          }
        });
      } else {
        setState(() {
          result = "Error: ${response.statusCode}";
          suggestion = "Please check your API or input data.";
        });
      }
    } catch (e) {
      setState(() {
        result = "Failed to connect to API: $e";
        suggestion = "Ensure the API is running and reachable.";
      });
    }
  }

  Future<void> downloadPDFReport() async {
    if (pdfUrl == null) return;

    setState(() {
      isDownloading = true;
    });

    try {
      final url = Uri.parse("http://localhost:5000/$pdfUrl");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/placement_report.pdf";

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ PDF downloaded successfully")));
        await OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Failed to download PDF.")));
      }
    } catch (e) {
      print("Download error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() {
      isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placement Prediction"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildTextFields(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: predictPlacement,
                  child: Text("Predict Placement"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  result,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              if (suggestion.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    suggestion,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              if (pdfUrl != null)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: isDownloading ? null : downloadPDFReport,
                    icon: Icon(Icons.download),
                    label: Text(isDownloading ? "Downloading..." : "Download PDF Report"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      buildTextField("CGPA", cgpaController),
      buildTextField("Projects", projectsController),
      buildTextField("Internships", internshipsController),
      buildTextField("Certifications", certificationsController),
      buildTextField("Aptitude Test Score (out of 100)", aptitudeController),
      buildTextField("Soft Skill Score (out of 100)", softSkillController),
      buildTextField("Technical Test Score (out of 100)", technicalTestController),
      buildTextField("Programming Portal i.e Leetcode,GFG Total Questions (Optional)", programQueController),
    ];
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
