import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final randomProvider =
    Provider((ref) => Random(DateTime.now().millisecondsSinceEpoch));
