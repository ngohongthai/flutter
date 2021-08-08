import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answerText;
  final VoidCallback selectHandle;
  Answer(this.answerText, this.selectHandle);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18), primary: Colors.blue);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: ElevatedButton(
        onPressed: selectHandle,
        child: Text(answerText),
        style: style,
      ),
    );
  }
}
