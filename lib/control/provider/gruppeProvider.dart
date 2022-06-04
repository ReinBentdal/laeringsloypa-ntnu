import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Gruppe.dart';

final gruppepinVerdiProvider = StateProvider<String>((ref) => '');

final gruppeIdProvider = StateProvider<String?>((ref) => null);

final gruppeStreamProvider = StreamProvider<GruppeModel>((ref) {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  final gruppe = FirebaseFirestore.instance.collection('grupper').doc(gruppeId).snapshots();
  return gruppe.map(
    (doc) => GruppeModel.fromJson(
      doc.id,
      doc.data()!,
    ),
  );
});

final gruppeProvider = FutureProvider.autoDispose<GruppeModel>((ref) async {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  final gruppe = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).get();
  return GruppeModel.fromJson(gruppe.id, gruppe.data()!);
});

final gruppeDeltakereProvider = StreamProvider<List<DeltakerModel>>((ref) {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  final res = FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').snapshots();
  return res.map((snapshot) => snapshot.docs.map((deltaker) {
        return DeltakerModel.fromJson(deltaker.id, deltaker.data());
      }).toList());
});

final erGruppespillProvider = FutureProvider<bool>((ref) async {
  final gruppeId = ref.watch(gruppeIdProvider).state;
  final deltakere = await FirebaseFirestore.instance.collection('grupper').doc(gruppeId).collection('deltakere').get();
  return deltakere.size != 1;
});
