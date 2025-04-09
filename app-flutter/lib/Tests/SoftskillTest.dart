import 'dart:async';
import 'package:flutter/material.dart';

class SoftSkillsTestScreen extends StatefulWidget {
  @override
  _SoftSkillsTestScreenState createState() => _SoftSkillsTestScreenState();
}

class _SoftSkillsTestScreenState extends State<SoftSkillsTestScreen> {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(20, null);
  int _timeRemaining = 20 * 60; // 20 minutes in seconds
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Identify the correct sentence:',
      'options': [
        'She don’t like coffee.',
        'She doesn’t likes coffee.',
        'She doesn’t like coffee.',
        'She didn’t liked coffee.'
      ],
      'correctAnswer': 'She doesn’t like coffee.',
    },
    {
      'question': 'Choose the correct word to complete the sentence: The cat ____ on the sofa.',
      'options': ['sit', 'sits', 'sat', 'siting'],
      'correctAnswer': 'sits',
    },
    {
    'question': 'Which word is a conjunction?',
    'options': ['And', 'Quickly', 'Beautiful', 'Apple'],
    'correctAnswer': 'And',
    },
    {
      'question': 'Identify the subject in the sentence: "The cat chased the mouse."',
      'options': ['The cat', 'Chased', 'The mouse', 'Cat'],
      'correctAnswer': 'The cat'
    },
    {
      'question': 'What is the synonym of "Brave"?',
      'options': ['Cowardly', 'Fearless', 'Timid', 'Nervous'],
      'correctAnswer': 'Fearless',
    },
    {
      'question': 'Choose the correctly punctuated sentence.',
      'options': ['She said, "Hello, how are you?"', 'She said "Hello, how are you?"', 'She said, hello how are you?', 'She said Hello how are you?'],
      'correctAnswer': 'She said, "Hello, how are you?"',
    },
    {
      'question': 'Which of the following is a declarative sentence?',
      'options': ['Where is the library?', 'I love reading books.', 'Close the door, please.', 'What a beautiful day!'],
      'correctAnswer': 'I love reading books.',

    },
    {
      'question': 'Identify the correct form of the verb in the sentence: "She ____ to the market every day."',
      'options': ['Go', 'Goes', 'Going', 'Gone'],
      'correctAnswer': 'Goes',

    },
    {
      'question': 'Which sentence is grammatically correct?',
      'options': ['He have a lot of books.', 'She has a beautiful house.', 'They was going to school.', 'It were a sunny day.'],
      'correctAnswer': 'She has a beautiful house.',

    },
    {
      'question': 'Which sentence is in the past tense?',
      'options': ['I am reading a book.', 'She was at the park.', 'He will go to school.', 'They are playing football.'],
      'correctAnswer': 'She was at the park.',
    },
    {
      'question': 'Identify the synonym of “Happy”.',
      'options': ['Sad', 'Angry', 'Joyful', 'Fearful'],
      'correctAnswer': 'Joyful',
    },
    {
      'question': 'Which sentence is grammatically correct?',
      'options': [
        'Neither of the boys were present.',
        'Neither of the boys was present.',
        'Neither boys was present.',
        'Neither boys were present.'
      ],
      'correctAnswer': 'Neither of the boys was present.',
    },
    {
      'question': 'Identify the correct spelling:',
      'options': ['Recieve', 'Receive', 'Receeve', 'Recive'],
      'correctAnswer': 'Receive',
    },
    {
      'question': 'What is the antonym of “Generous”?',
      'options': ['Kind', 'Selfish', 'Polite', 'Helpful'],
      'correctAnswer': 'Selfish',
    },
    {
      'question': 'Select the correct plural form of “Child”.',
      'options': ['Childs', 'Childes', 'Children', 'Childrens'],
      'correctAnswer': 'Children',
    },
    {
      'question': 'Fill in the blank: She is ____ best student in the class.',
      'options': ['a', 'an', 'the', 'no article'],
      'correctAnswer': 'the',
    },
    {
      'question': 'What is the correct form of the verb: He ____ to the market yesterday.',
      'options': ['go', 'went', 'going', 'goes'],
      'correctAnswer': 'went',
    },
    {
      'question': 'Identify the correct sentence:',
      'options': [
        'I have went to the park.',
        'I had went to the park.',
        'I have gone to the park.',
        'I has gone to the park.'
      ],
      'correctAnswer': 'I have gone to the park.',
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
              Navigator.pop(context);
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
