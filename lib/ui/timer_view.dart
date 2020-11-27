import 'package:flutter/material.dart';
import 'package:rxdart_timer/blocs/timer_bloc.dart';

class TimerView extends StatefulWidget {
  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  //Create a new instance of the timer bloc for the stateful widget
  TimerBloc _timerBloc = TimerBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///Stream builder to watch the timer observable stream from the BLOC
          StreamBuilder(
            stream: _timerBloc.timerObservable,
            builder: (context, snapshot) {
              ///Checking if the Stream has data
              ///
              ///For some reason, the seeded option isn't working in the BLOC
              if (snapshot.hasData) {
                return Text(snapshot.data);
              } else {
                return Text('00:00');
              }
            },
          ),
          const SizedBox(
            height: 40,
          ),

          ///The start button built using a StreamBuilder
          ///
          ///Checked if the timer is running and sets a seperate bool. The button then
          ///checks this bool and either allows the startTimer function to be ran or
          ///simple disabled the button
          StreamBuilder(
            stream: _timerBloc.isRunningObservable,
            builder: (context, snapshot) {
              bool _running = snapshot.hasData ? snapshot.data : false;
              return FlatButton(
                color: Colors.green,
                onPressed: _running ? null : _timerBloc.startTimer,
                child: Text('Start'),
              );
            },
          ),

          ///A row for containing the StreamBuilder for the Pause button and a
          ///regular Reset button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///Using a StreamBuilder to build the Pause button
              ///
              ///I build another bool, similar to the strart button, to check whether the
              ///button should be enabled.
              StreamBuilder(
                stream: _timerBloc.isRunningObservable,
                builder: (context, snapshot) {
                  bool _running = snapshot.hasData ? snapshot.data : false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.red[600],
                        onPressed: _running ? _timerBloc.pauseTimer : null,
                        child: Text('Pause'),
                      ),
                    ],
                  );
                },
              ),

              ///Seperating the Pause and Stop button by 30 pixels
              const SizedBox(
                width: 30,
              ),

              ///Reset button, always enabled
              FlatButton(
                color: Colors.yellow[700],
                onPressed: _timerBloc.resetTimer,
                child: Text('Reset'),
              ),
            ],
          )
        ],
      ),
    );
  }

  ///Disposes of the timerBloc
  @override
  void dispose() {
    _timerBloc.dispose();
    super.dispose();
  }
}
