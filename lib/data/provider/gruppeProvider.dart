import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Gruppe.dart';

final gruppepinVerdiProvider = StateProvider<String>((ref) => '');

final gruppeIdProvider = StateProvider<String?>((ref) => null);

final grupperProvider =
    StreamProvider.family.autoDispose<List<GruppeModel>, String>((ref, pin) {
  final stream = FirebaseFirestore.instance
      .collection('grupper')
      .where('status', isEqualTo: 'venter')
      .where('pin', isEqualTo: pin)
      .limit(1)
      .snapshots();

  return stream.map((event) {
    return event.docs.map((doc) {
      return GruppeModel.fromJson(doc.data()..addAll({'doc_id': doc.id}));
    }).toList();
  });
});

final gruppeStreamProvider =
    StreamProvider.family<GruppeModel, String?>((ref, docId) {
  final gruppe =
      FirebaseFirestore.instance.collection('grupper').doc(docId).snapshots();
  return gruppe.map((doc) => GruppeModel.fromJson(doc.data()!
    ..addAll({
      'doc_id': doc.id,
    })));
});

final gruppeProvider =
    FutureProvider.autoDispose.family<GruppeModel, String?>((ref, docId) async {
  final gruppe =
      await FirebaseFirestore.instance.collection('grupper').doc(docId).get();
  return GruppeModel.fromJson(gruppe.data()!
    ..addAll({
      'doc_id': gruppe.id,
    }));
});

final gruppeDeltakereProvider =
    StreamProvider.family<List<DeltakerModel>, String>((ref, docId) {
  final res = FirebaseFirestore.instance
      .collection('grupper')
      .doc(docId)
      .collection('deltakere')
      .snapshots();
  return res.map((snapshot) => snapshot.docs.map((doc) {
        return DeltakerModel.fromJson(doc.data()
          ..addAll({
            'doc_id': doc.id,
          }));
      }).toList());
});

final erGruppeProvider = FutureProvider<bool>((ref) async {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  final deltakere = await FirebaseFirestore.instance
      .collection('grupper')
      .doc(gruppeId)
      .collection('deltakere')
      .get();
  return deltakere.size != 1;
});
