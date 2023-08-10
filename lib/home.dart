import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  double _percent = 0.0;
  int _roundsCompleted = 0;
  int _minutes = 25;
  int _seconds = 0;
  bool _isBreak = false;
  bool _isActive = false;
  late Timer _timer;

  void _startTimer() {
    setState(() {
      _isActive = true;
    });
    double secPercent = (1 / (_minutes * 60));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_minutes == 0 && _seconds == 0) {
        _timer.cancel();
        if (_isBreak) {
          if (_roundsCompleted < 4) {
            setState(() {
              _isBreak = false;
              _minutes = 25;
              _seconds = 0;
              _roundsCompleted++;
              _percent = 0.0;
            });
            _startTimer();
          } else {
            setState(() {
              _isActive = false;
              _roundsCompleted = 0;
            });
          }
        } else {
          setState(() {
            _isBreak = true;
            _minutes = 10;
            _seconds = 0;
            _percent = 0.0;
          });
          _startTimer();
        }
      } else {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
            _percent += secPercent;
          } else {
            _minutes--;
            _seconds = 59;
          }
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: _isBreak
            ? const LinearGradient(
                colors: [
                  Color(0xff008cf7),
                  Color(0xff6fc1ff),
                ],
                begin: FractionalOffset(0.5, 1),
              )
            : const LinearGradient(
                colors: [
                  Color(0xffbb2700),
                  Color(0xffff8666),
                ],
                begin: FractionalOffset(0.5, 1),
              ),
      ),
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 100),
          CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            radius: 170.0,
            percent: _percent,
            animation: true,
            animateFromLastPercent: true,
            lineWidth: 20.0,
            progressColor: Colors.white,
            header: Column(
              children: [
                const Text(
                  'Pomodoro Timer',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  _isBreak ? 'Break' : 'Round ${_roundsCompleted + 1}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 45),
              ],
            ),
            center: Text(
              '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 70),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isActive ? _stopTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor:
                          _isBreak ? Color(0xff0995ff) : Color(0xffee3100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _isActive ? 'Stop' : 'Start',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _stopTimer();
                      setState(() {
                        _isBreak = false;
                        _minutes = 25;
                        _seconds = 0;
                        _roundsCompleted = 0;
                        _percent = 0.0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor:
                          _isBreak ? Color(0xff0995ff) : Color(0xffee3100),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
