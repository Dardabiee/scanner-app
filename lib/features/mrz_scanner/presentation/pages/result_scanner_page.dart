import 'package:flutter/material.dart';

class ResultScannerPage extends StatelessWidget {
  final String text;

  const ResultScannerPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Text(text),
        ),
    );
  }
}