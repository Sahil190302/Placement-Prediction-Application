import 'dart:async';

import 'package:flutter/material.dart';

class VerbalNonVerbalScreen extends StatefulWidget {
  @override
  _VerbalNonVerbalScreenState createState() => _VerbalNonVerbalScreenState();
}

class _VerbalNonVerbalScreenState extends State<VerbalNonVerbalScreen> {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(20, null); // Track selected answers
  int _timeRemaining = 20 * 60; // 20 minutes in seconds
  late Timer _timer;

  // Soft Skills Questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Synonym of Abundant',
      'options': ['Scarce', 'Plentiful', 'Rare', 'Limited'],
      'correctAnswer': 'Plentiful',
    },
    {
      'question': 'Antonym of Permanent Solution',
      'options': ['Temporary', 'Stable', 'Endless', 'Perpetual'],
      'correctAnswer': 'Temporary',
    },
    {
      'question': 'The earth is at present in great danger because of ________ pollution which is going on at an incredible rapid pace.',
      'options': ['Colossal', 'Minor', 'Negligible', 'Minimal'],
      'correctAnswer': 'Colossal',
    },
    {
      'question': 'Correct the sentence: "She prefers coffee other than tea"',
      'options': ['She prefers coffee than tea', 'She prefers coffee over tea', 'She prefers coffee to tea', 'She prefers coffee with tea'],
      'correctAnswer': 'She prefers coffee to tea',
    },
    {
      'question': 'Circle the correct spelling:',
      'options': ['Recieve', 'Receive', 'Recive', 'Receeve'],
      'correctAnswer': 'Receive',
    },
    {
      'question': 'At one point, it looked as if an area of agreement would _______ specially over the issue of productivity-linked wages.',
      'options': ['dissolve', 'emerge', 'disappear', 'extend'],
      'correctAnswer': 'emerge',
    },
    {
      'question': 'She knew everything better than anybody else, and it was an affront to her ________ vanity that you should disagree with her.',
      'options': ['overstrung', 'calm', 'modest', 'serene'],
      'correctAnswer': 'overstrung',
    },
    {
      'question': 'What is the meaning of the idiom "A Herculean task"?',
      'options': ['An impossible task', 'A trivial task', 'A massive task', 'An extremely difficult task requiring tremendous effort'],
      'correctAnswer': 'An extremely difficult task requiring tremendous effort',
    },
    {
      'question': 'Spot the error in the sentence: "I am working in this company for 2010."',
      'options': ['"in" should be "since"', '"for" should be "since"', '"am" should be "have been"', 'No error'],
      'correctAnswer': '"for" should be "since"',
    },
    {
      'question': 'One word substitution for "A place for keeping birds"',
      'options': ['Zoo', 'Aviary', 'Kennel', 'Stable'],
      'correctAnswer': 'Aviary',
    },
    {
      "question": "Find the missing number in the series: 2, 6, 18, ?, 162",
      "options": ["36", "54", "72", "90"],
      "correctAnswer": "54"
    },
    {
      "question": "Identify the odd one out: Hut, Tent, Caravan, Bungalow, Cottage",
      "options": ["Hut", "Tent", "Caravan", "Bungalow"],
      "correctAnswer": "Caravan"
    },
    {
      "question": "Continue the pattern: AQCQEQGQ_",
      "options": ["HQKQ", "IQKQ", "JQKQ", "KQKQ"],
      "correctAnswer": "IQKQ"
    },
    {
      "question": "Which comes next in the sequence? 1, 4, 9, 16, ?",
      "options": ["20", "22", "25", "30"],
      "correctAnswer": "25"
    },
    {
      "question": "If + means ÷, – means x, ÷ means + and x means -, then 8÷2+4×3-6=?",
      "options": ["20", "22", "24", "26"],
      "correctAnswer": "26"
    },
    {
      "question": "Gravity is related to pull in the same way as magnetism is related to ________",
      "options": ["Repulsion", "Attraction", "Force", "Magnet"],
      "correctAnswer": "Attraction"
    },
    {
      "question": "What comes next… 8, 28, 116, 584?",
      "options": ["2084", "2584", "3508", "4008"],
      "correctAnswer": "3508"
    },
    {
      "question": "12 is related to 36 in the same way 17 is related to ?",
      "options": ["34", "51", "68", "85"],
      "correctAnswer": "51"
    },
    {
      "question": "Book : Cover :: Painting : ?",
      "options": ["Canvas", "Frame", "Art", "Exhibit"],
      "correctAnswer": "Frame"
    },
    {
      "question": "A clock is set right at 7 am. What was the correct time when the clock shows 5 pm on the same day?",
      "options": ["12 noon", "1 pm", "2 pm", "3 pm"],
      "correctAnswer": "12 noon"
    }
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
        title: Text('Soft Skills Test'),
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