import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Loype.dart';

final loypeIdProvider = StateProvider<String?>((ref) => null);

final valgtLoypeProvider = FutureProvider<LoypeModel?>((ref) async {
  final loypeId = ref.watch(loypeIdProvider).state;

  if (loypeId == null) return null;

  final loypeData =
      await FirebaseFirestore.instance.collection('løyper').doc(loypeId).get();

  if (loypeData.exists == false) return null;

  return LoypeModel.fromJson(loypeData.data()!);
});

final loypeDataFetchCountProvider = StateProvider((ref) => 0);
