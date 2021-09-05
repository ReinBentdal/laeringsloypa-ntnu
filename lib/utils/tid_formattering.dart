// const tidIntervall = [1, 5, 10, 20, 30, 45, 60, 90, 120, 160, 240];

enum TidFormat { Utskreven, Digital }

String formaterTid(Duration tid, {TidFormat format = TidFormat.Utskreven}) {
  final int timer = tid.inHours;
  final int minutter = tid.inMinutes.remainder(60);
  final int sekunder = tid.inSeconds.remainder(60);

  switch (format) {
    case TidFormat.Utskreven:
      if (timer == 0) {
        return '${minutter.toString()} minutt${minutter > 1 ? 'er' : ''}';
      } else if (minutter == 0) {
        return '${timer.toString()} time${timer > 1 ? 'r' : ''}';
      }
      return '${timer.toString()} time${timer > 1 ? 'r' : ''} og ${minutter.toString()} minutt${minutter > 1 ? 'er' : ''}';

    case TidFormat.Digital:
      String minutterString = minutter.toString();
      if (minutterString.length == 1) minutterString = '0' + minutterString;

      String sekunderString = sekunder.toString();
      if (sekunderString.length == 1) sekunderString = '0' + sekunderString;
      return '$timer:$minutterString:$sekunderString';
  }
}
