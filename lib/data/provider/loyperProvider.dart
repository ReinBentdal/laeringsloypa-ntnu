import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Loype.dart';
import 'package:loypa/config/globals.dart' as globals;

final loypeinfoProvider = FutureProvider.family<LoypeInfoModel?, String?>((ref, loypeId) async {
  final loype = await FirebaseFirestore.instance.collection('løyper_oversikt').doc(loypeId).get();

  if (loype.exists)
    return LoypeInfoModel.fromJson(loype.data()!
      ..addAll({
        'løype_id': loype.id,
      }));

  return null;
});

final loyperStreamProvider = StreamProvider<List<LoypeInfoModel>>((ref) {
  ref.watch(loyperFetchCountProvider.notifier).inc();

  final data = globals.beta
      ? FirebaseFirestore.instance.collection('løyper_oversikt').snapshots()
      : FirebaseFirestore.instance.collection('løyper_oversikt').where('public', isEqualTo: true).snapshots();

  return data.map((snapshot) {
    return snapshot.docs.map<LoypeInfoModel>((doc) {
      return LoypeInfoModel.fromJson(doc.data()
        ..addAll({
          'løype_id': doc.id,
        }));
    }).toList();
  });
});

final loyperFetchCountProvider =
    StateNotifierProvider<LoyperFetchCountController, int>((ref) => LoyperFetchCountController());

class LoyperFetchCountController extends StateNotifier<int> {
  LoyperFetchCountController() : super(0);

  void inc() {
    state++;
    print('Løyper fetch count: $state');
  }
}
