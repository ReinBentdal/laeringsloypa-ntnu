import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider =
    StateNotifierProvider<TimerController, int>((ref) => TimerController());

class TimerController extends StateNotifier<int> {
  TimerController() : super(0);
  StreamSubscription? _timerStream;

  bool get active => !(_timerStream?.isPaused ?? true);

  void start() {
    this._timerStream?.cancel();
    this._timerStream = Stream.periodic(Duration(seconds: 1)).listen((_) {
      this.state++;
    });
  }

  void stopp() {
    this._timerStream?.cancel();
  }

  void tilbakestill() => this.state = 0;

  void sett(DateTime start) {
    final now = DateTime.now();
    this.state = (now.millisecondsSinceEpoch - start.millisecondsSinceEpoch)~/1000;
  } 

  Duration get tid => Duration(seconds: this.state);
}
