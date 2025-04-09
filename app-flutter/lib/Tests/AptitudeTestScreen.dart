import 'dart:async';

import 'package:flutter/material.dart';

class AptitudeTestScreen extends StatefulWidget {
  @override
  _AptitudeTestScreenState createState() => _AptitudeTestScreenState();
}

class _AptitudeTestScreenState extends State<AptitudeTestScreen> {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(20, null); // Track selected answers
  int _timeRemaining = 20 * 60; // 20 minutes in seconds
  late Timer _timer;

  // Sample questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'A shopkeeper sells an item for \$200 at a profit of 20%. What is the cost price?',
      'options': ['\$160', '\$180', '\$200', '\$220'],
      'correctAnswer': '\$160',
    },
    {
      'question': 'A boat travels 10 km upstream in 2 hours and 15 km downstream in 1 hour. What is the speed of the boat in still water?',
      'options': ['5 km/h', '10 km/h', '15 km/h', '20 km/h'],
      'correctAnswer': '10 km/h',
    },
    {
      'question': 'If a car travels 240 km in 4 hours, what is its speed?',
      'options': ['40 km/h', '60 km/h', '80 km/h', '100 km/h'],
      'correctAnswer': '60 km/h',
    },
    {
      "question": "If the cost price of an item is Rs. 200 and it is sold at a profit of 20%, what is the selling price?",
      "options": ["Rs. 220", "Rs. 240", "Rs. 260", "Rs. 280"],
      "correctAnswer": "Rs. 240"
    },
    {
      "question": "A train running at 90 km/h crosses a pole in 10 seconds. What is the length of the train?",
      "options": ["150 m", "250 m", "300 m", "500 m"],
      "correctAnswer": "250 m"
    },
    {
      "question": "The sum of two numbers is 20, and their difference is 4. What is the larger number?",
      "options": ["10", "12", "14", "16"],
      "correctAnswer": "12"
    },
    {
      "question": "A clock shows 3:15. What is the angle between the hour and minute hands?",
      "options": ["0°", "7.5°", "30°", "37.5°"],
      "correctAnswer": "7.5°"
    },
    {
      "question": "A man is 5 times as old as his son. If the sum of their ages is 36, what is the son's age?",
      "options": ["5 years", "6 years", "7 years", "8 years"],
      "correctAnswer": "6 years"
    },
    {
      "question": "If the height of a tree is 20 m and its shadow is 10 m, what is the angle of elevation of the sun?",
      "options": ["30°", "45°", "60°", "90°"],
      "correctAnswer": "60°"
    },
    {
      "question": "Rearrange the letters 'RPOFIT' to form a meaningful word.",
      "options": ["PORTFI", "PROFIT", "POTRFI", "TROFIP"],
      "correctAnswer": "PROFIT"
    },
    {
      "question": "A shopkeeper gives a 10% discount on an item marked at Rs. 500. What is the selling price?",
      "options": ["Rs. 400", "Rs. 450", "Rs. 460", "Rs. 475"],
      "correctAnswer": "Rs. 450"
    },
    {
      "question": "Find the value of x: 3x - 7 = 11.",
      "options": ["4", "5", "6", "7"],
      "correctAnswer": "6"
    },
    {
      "question": "A car moves at 60 km/h for 3 hours. How far does it travel?",
      "options": ["120 km", "150 km", "180 km", "200 km"],
      "correctAnswer": "180 km"
    },
    {
      "question": "What is the gain percent if an item bought for Rs. 800 is sold for Rs. 1000?",
      "options": ["20%", "25%", "30%", "35%"],
      "correctAnswer": "25%"
    },
    {
      "question": "A train of length 150 m crosses a bridge of 300 m in 20 seconds. What is its speed?",
      "options": ["45 km/h", "65 km/h", "80 km/h", "90 km/h"],
      "correctAnswer": "80 km/h"
    },
    {
      "question": "Find the next number in the series: 2, 6, 12, 20, ___?",
      "options": ["28", "30", "32", "36"],
      "correctAnswer": "30"
    },
    {
      "question": "The time taken by a clock’s minute hand to move from 2:00 to 2:45 is?",
      "options": ["180°", "270°", "90°", "225°"],
      "correctAnswer": "270°"
    },
    {
      "question": "If a father is 3 times as old as his son and the sum of their ages is 48, how old is the son?",
      "options": ["10 years", "12 years", "14 years", "16 years"],
      "correctAnswer": "12 years"
    },
    {
      "question": "The height of a building is 50 m, and its shadow is 25 m. What is the angle of elevation of the sun?",
      "options": ["30°", "45°", "60°", "90°"],
      "correctAnswer": "45°"
    },
    {
      "question": "Rearrange the letters 'LODCE' to form a meaningful word.",
      "options": ["COLED", "CLODE", "DECLO", "CLODE"],
      "correctAnswer": "CLODE"
    }
    // Add 17 more questions here...
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer.cancel();
        _submitTest();
      }
    });
  }

  void _submitTest() {
    _timer.cancel();
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test Submitted'),
        content: Text('You scored $correctAnswers out of ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to the home screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aptitude Test'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _selectedAnswers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _selectedAnswers[_currentQuestionIndex] = value;
                  });
                },
              );
            }).toList(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0
                      ? () {
                    setState(() {
                      _currentQuestionIndex--;
                    });
                  }
                      : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _currentQuestionIndex < _questions.length - 1
                      ? () {
                    setState(() {
                      _currentQuestionIndex++;
                    });
                  }
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTest,
              child: Text('Submit Test'),
            ),
          ],
        ),
      ),
    );
  }
}