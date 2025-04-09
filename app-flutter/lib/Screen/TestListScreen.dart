import 'package:flutter/material.dart';
import 'package:untitled/Tests/LogicalReasoning.dart';
import 'package:untitled/Tests/SoftskillTest.dart';
import 'package:untitled/Tests/VnVTest.dart';
import '../Tests/AptitudeTestScreen.dart';
import '../Tests/Technicalmcq.dart';

class TestListScreen extends StatelessWidget {
  final String category;

  TestListScreen({this.category = 'All'});

  final List<Map<String, dynamic>> allTests = [
    {
      'title': 'Test No.1 (Aptitude)',
      'description': '20 questions, 20 minutes',
      'screen': AptitudeTestScreen(),
      'category': 'Aptitude'
    },
    {
      'title': 'Test No.2 (Soft-Skill)',
      'description': '20 questions, 20 minutes',
      'screen': SoftSkillsTestScreen(),
      'category': 'Soft Skills'
    },
    {
      'title': 'Test No.3 (Non-Verbal+Verbal)',
      'description': '20 questions, 20 minutes',
      'screen': VerbalNonVerbalScreen(),
      'category': 'Aptitude'
    },
    {
      'title': 'Test No.4 (Logical Reasoning)',
      'description': '12 questions, 12 minutes',
      'screen': LogicalReasoningScreen(),
      'category': 'Aptitude'
    },
    {
      'title': 'Test No.5 (Technical Aptitude)',
      'description': '20 questions, 20 minutes',
      'screen': Technicalmcq(),
      'category': 'Programming'
    }
    // Add more tests here...
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTests = category == 'All'
        ? allTests
        : allTests.where((test) => test['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Tests'),
      ),
      body: filteredTests.isEmpty
          ? Center(child: Text('No tests available for $category'))
          : ListView.builder(
        itemCount: filteredTests.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(filteredTests[index]['title']),
              subtitle: Text(filteredTests[index]['description']),
              onTap: () {
                if (filteredTests[index]['screen'] != null) {
                  _showTestDetailsDialog(context, filteredTests[index]['screen']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('This test is not available yet.')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showTestDetailsDialog(BuildContext context, Widget screen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test Details'),
        content: Text('This test consists of 20 questions and must be completed in 20 minutes.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
            child: Text('Start Test'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
