import 'dart:async';
import 'package:flutter/material.dart';

class LogicalReasoningScreen extends StatefulWidget {
  @override
  _LogicalReasoningScreenState createState() => _LogicalReasoningScreenState();
}

class _LogicalReasoningScreenState extends State<LogicalReasoningScreen> {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(12, null);
  int _timeRemaining = 12 * 60; // 12 minutes in seconds
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Raju said, “That girl playing carrom over there is the younger of the two daughters of my father’s wife.” Who is Raju referring to?',
      'options': ['His sister', 'His cousin', 'His niece', 'His friend'],
      'correctAnswer': 'His sister',
    },
    {
      'question': 'Suppose the first 2 statements are true. Is the final conclusion true? Statements: All writers are poets. Some novelists are writers. Conclusion: Some novelists are poets.',
      'options': ['True', 'False'],
      'correctAnswer': 'True',
    },
    {
      'question': 'How many 3-letter words can be formed from the word CARTON without repetition?',
      'options': ['120', '60', '90', '30'],
      'correctAnswer': '60',
    },
    {
      'question': 'Today is Monday. After 61 days, what day will it be?',
      'options': ['Friday', 'Saturday', 'Sunday', 'Monday'],
      'correctAnswer': 'Saturday',
    },
    {
      'question': 'At a conference, 12 members shook hands with each other before & after the meeting. How many total number of hand shakes occurred?',
      'options': ['132', '144', '120', '110'],
      'correctAnswer': '132',
    },
    {
      'question': 'A student has to obtain 33% of the total marks to pass. He obtained 124 marks and failed by 40 marks. Find the total marks.',
      'options': ['400', '500', '450', '600'],
      'correctAnswer': '500',
    },
    {
      'question': 'Museum is related to Curator in the same way as Prison is related to…?',
      'options': ['Warden', 'Jailor', 'Guard', 'Prisoner'],
      'correctAnswer': 'Jailor',
    },
    {
      'question': '1 : 1 : : 25 : ?',
      'options': ['525', '625', '725', '425'],
      'correctAnswer': '625',
    },
    {
      'question': 'Ramesh said, “That boy playing cricket is the younger of the two brothers of my wife’s mother.” What is Ramesh’s relation to that boy?',
      'options': ['Uncle', 'Father', 'Brother', 'Cousin'],
      'correctAnswer': 'Uncle',
    },
    {
      'question': 'Statement: Some writers are not poets. Some poets are philosophers. Conclusion 1: Some writers are not philosophers. True or False?',
      'options': ['True', 'False'],
      'correctAnswer': 'True',
    },
    {
      'question': 'In a kilogram, there are 5 packets of Equal weight. Each packet can make any 4 notebooks of 180 pages each. What is the maximum number of 300-page notebooks that can be made from 3 kg of the same type of paper?',
      'options': ['18', '21', '24', '27'],
      'correctAnswer': '27',
    },
    {
      'question': 'Aman starts walking from a point A towards East. After walking a distance of 8 km, he turns left and walks 6 km. How far is he from the starting point?',
      'options': ['8 km', '10 km', '12 km', '14 km'],
      'correctAnswer': '10 km',
    },

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
        title: Text('Logical Reasoning Test'),
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