import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider =
    StateNotifierProvider<TimerController, int>((ref) => TimerController());

class TimerController extends StateNotifier<int> {
  TimerController() : super(0);
  StreamSubscription? _timerStream;

  void startTimer() {
    this._timerStream?.cancel();
    this._timerStream = Stream.periodic(Duration(seconds: 1)).listen((_) {
      this.state++;
    });
  }

  void stoppTimer() {
    this._timerStream?.cancel();
  }

  void tilbakestill() => this.state = 0;

  Duration get tid => Duration(seconds: this.state);
}
