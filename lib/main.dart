import 'package:flutter/material.dart';
import 'package:pomodoro_app/home.dart';

void main() {
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      debugShowCheckedModeBanner: false,
      home: PomodoroScreen(),
    );
  }
}
