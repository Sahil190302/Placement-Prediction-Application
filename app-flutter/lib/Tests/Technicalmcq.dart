import 'dart:async';
import 'package:flutter/material.dart';

class Technicalmcq extends StatefulWidget {
  @override
  _TechnicalmcqState createState() => _TechnicalmcqState();
}

class _TechnicalmcqState extends State<Technicalmcq> {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(20, null);
  int _timeRemaining = 20 * 60; // 20 minutes in seconds
  late Timer _timer;

  final List<Map<String, dynamic>> _questions = [
    {
      "questions": [
        {
          "question": "Which of the following is a characteristic of an efficient algorithm?",
          "options": [
            "Uses minimal CPU time",
            "Uses minimal memory",
            "Is easy to implement",
            "All of the above"
          ],
          "answer": "All of the above"
        },
        {
          "question": "The process of breaking a complex problem into smaller, more manageable parts is known as what?",
          "options": [
            "Decomposition",
            "Abstraction",
            "Encapsulation",
            "Inheritance"
          ],
          "answer": "Decomposition"
        },
        {
          "question": "What is the primary purpose of pseudocode?",
          "options": [
            "To document algorithms in natural language",
            "To compile and execute algorithms",
            "To debug code",
            "To optimize algorithms"
          ],
          "answer": "To document algorithms in natural language"
        },
        {
          "question": "In algorithm analysis, what does asymptotic complexity refer to?",
          "options": [
            "The complexity in the best case",
            "The complexity in the worst case",
            "The complexity in the average case",
            "The behavior of an algorithm as the input size grows"
          ],
          "answer": "The behavior of an algorithm as the input size grows"
        },
        {
          "question": "What will be the output of the following pseudocode if the input is 5? function factorial(n): if n == 1 return 1 else return n * factorial(n-1)",
          "options": [
            "5",
            "24",
            "120",
            "None of the above"
          ],
          "answer": "120"
        },
        {
          "question": "Consider the following algorithm for calculating the nth Fibonacci number: function fib(n): if n <= 1 return n else return fib(n-1) + fib(n-2). What is the time complexity of this algorithm?",
          "options": [
            "O(n)",
            "O(log n)",
            "O(n^2)",
            "O(2^n)"
          ],
          "answer": "O(2^n)"
        },
        {
          "question": "An algorithm supposed to calculate the sum of numbers from 1 to n returns a higher value than expected. What is the most likely mistake?",
          "options": [
            "Starting the loop from 0",
            "Not initializing the sum variable",
            "Adding n twice",
            "All of the above"
          ],
          "answer": "Adding n twice"
        },
        {
          "question": "Given an algorithm that always returns the first element in a sorted list instead of the smallest, what is likely the issue?",
          "options": [
            "The algorithm incorrectly assumes the first element is the smallest",
            "The list is not properly sorted",
            "A loop iterates incorrectly",
            "All of the above"
          ],
          "answer": "The algorithm incorrectly assumes the first element is the smallest"
        },
        {
          "question": "Which Big O notation represents constant time complexity?",
          "options": [
            "O(1)",
            "O(n)",
            "O(log n)",
            "O(n^2)"
          ],
          "answer": "O(1)"
        },
        {
          "question": "For a linear search in an unsorted array of n elements, what is the average case time complexity?",
          "options": [
            "O(1)",
            "O(n)",
            "O(log n)",
            "O(n^2)"
          ],
          "answer": "O(n)"
        },
        {
          "question": "What does the Big O notation O(n^2) signify about an algorithm's growth rate?",
          "options": [
            "Linear growth",
            "Quadratic growth",
            "Logarithmic growth",
            "Exponential growth"
          ],
          "answer": "Quadratic growth"
        },
        {
          "question": "In Big O notation, what does O(log n) typically represent?",
          "options": [
            "The time complexity of binary search",
            "The time complexity of linear search",
            "The space complexity of sorting algorithms",
            "The space complexity of hashing"
          ],
          "answer": "The time complexity of binary search"
        },
        {
          "question": "Which of the following best describes the time complexity of inserting an element into a binary search tree?",
          "options": [
            "O(1)",
            "O(log n)",
            "O(n)",
            "O(n log n)"
          ],
          "answer": "O(log n)"
        },
        {
          "question": "What is the worst-case time complexity of quicksort?",
          "options": [
            "O(n log n)",
            "O(n)",
            "O(n^2)",
            "O(log n)"
          ],
          "answer": "O(n^2)"
        },
        {
          "question": "How does the space complexity of an iterative solution compare to a recursive solution for the same problem?",
          "options": [
            "Iterative solutions always use more space",
            "Recursive solutions always use more space",
            "Depends on the specific problem",
            "They use the same amount of space"
          ],
          "answer": "Depends on the specific problem"
        },
        {
          "question": "What is the time complexity of the following code snippet? for i in range(n): print(i)",
          "options": [
            "O(1)",
            "O(n)",
            "O(log n)",
            "O(n^2)"
          ],
          "answer": "O(n)"
        }
      ]
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
        title: Text('Technical MCQ Test'),
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
