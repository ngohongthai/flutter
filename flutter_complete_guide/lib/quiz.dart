import 'package:flutter/material.dart';
import 'answer.dart';
import 'question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final VoidCallback answerQuestion;
  final int questionIndex;

  Quiz(
      {required this.questions,
      required this.questionIndex,
      required this.answerQuestion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(questions[questionIndex]['questionText'] as String),
        ...(questions[questionIndex]['answer'] as List<String>).map((answer) {
          return Answer(answer, answerQuestion);
        }).toList()
      ],
    );
  }
}
