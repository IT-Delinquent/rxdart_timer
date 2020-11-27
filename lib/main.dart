import 'package:flutter/material.dart';
import 'package:rxdart_timer/ui/timer_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.8,
              fontSizeDelta: 2.0,
            ),
      ),

      ///launch the timer view with the stopwatch display
      ///and the three buttons
      home: TimerView(),
    );
  }
}
