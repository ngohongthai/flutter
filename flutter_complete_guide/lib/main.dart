import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/quiz.dart';
import 'package:flutter_complete_guide/result.dart';

// void main() {
//   runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My first app",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // _ is private variable
  var _questionIndex = 0;
  // var _questions = [
  //   "What\'s your favorite color?",
  //   "What\'s your favorite animal?"
  // ];

  final _questions = [
    {
      'questionText': 'What\'s your favorite color?',
      'answer': ['Black', 'Red', 'Green', 'Blue']
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answer': ['Rabbit', 'Snake', 'Elephant', 'Lion']
    },
    {
      'questionText': 'What\'s your favorite frients?',
      'answer': ['Tan', 'Hue', 'Thu', 'Ngoan', 'Duong']
    }
  ];

  void updateQuestionIndex() {
    setState(() {
      //_questionIndex =
      //_questionIndex >= (_questions.length - 1) ? 0 : _questionIndex + 1;
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My First App"),
      ),
      body: _questionIndex < _questions.length
          ? Quiz(
              questions: this._questions,
              questionIndex: this._questionIndex,
              answerQuestion: updateQuestionIndex)
          : Result(),
    );
  }
}
