import 'dart:async';
import 'package:rxdart/rxdart.dart';

///The BLOC class for the timer
class TimerBloc {
  ///The Stopwatch object for running the timer
  final Stopwatch _sWatch = Stopwatch();

  ///Creating a BehaviourSubject of type String for the Stopwatch display
  BehaviorSubject<String> _subjectDisplay;

  ///Creating a BehaviourSubject of type bool for the IsRunning variable
  BehaviorSubject<bool> _subjectIsRunning;

  ///The initial String value for the Stopwatch display
  String initialDisplay = '00:00';

  ///The initial bool value for the IsRunning variable
  bool initialIsRunning = false;

  ///The class builder
  ///Takes in the local initialDisplay and initialIsRunning to seed the
  ///subject behaviours
  TimerBloc({this.initialDisplay, this.initialIsRunning}) {
    _subjectDisplay = BehaviorSubject<String>.seeded(this.initialDisplay);
    _subjectIsRunning = BehaviorSubject<bool>.seeded(this.initialIsRunning);
  }

  ///A Stream for the Stopwatch String value
  Stream<String> get timerObservable => _subjectDisplay.stream;

  ///A Stream for the IsRunning bool value
  Stream<bool> get isRunningObservable => _subjectIsRunning.stream;

  ///Start the timer
  ///
  ///If the timer already has a value, it continues where it left off. Otherwise,
  ///it starts counting from 00:00
  void startTimer() {
    _subjectIsRunning.value = true;
    _sWatch.start();
    _startTimer();
  }

  ///Runs the Stopwatch every second
  void _startTimer() {
    Timer(Duration(seconds: 1), _keepRunning);
  }

  ///Keeps the Stopwatch running and updates the Stopwatch display BehaviourSubject
  void _keepRunning() {
    //Stop the timer from overflowing, max value should be 99:99
    if (_sWatch.elapsed.inMinutes >= 100) {
      pauseTimer();
      return;
    }
    if (_sWatch.isRunning) {
      _startTimer();
    }
    _subjectDisplay.sink.add(_formatStopWatch(_sWatch));
  }

  ///Formats the StopWatch elapsed time into the 00:00 format
  String _formatStopWatch(Stopwatch _swatch) {
    final String _inMinutes =
        (_swatch.elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final String _inSeconds =
        (_swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return "$_inMinutes:$_inSeconds";
  }

  ///Pause the timer and stop on the current display from being changed
  void pauseTimer() {
    _subjectIsRunning.value = false;
    _sWatch.stop();
  }

  ///Reset the timer display and the Stopwatch object
  void resetTimer() {
    _subjectIsRunning.value = false;
    _subjectDisplay.sink.add('00:00');
    _sWatch.reset();
    _sWatch.stop();
  }

  ///Resumed the timer and continue updating the Stopwach display
  void resumeTimer() {
    _subjectIsRunning.value = true;
    _sWatch.start();
    _startTimer();
  }

  ///Dispose of the BehaviourSubjects
  void dispose() {
    _subjectDisplay.close();
    _subjectIsRunning.close();
  }
}
