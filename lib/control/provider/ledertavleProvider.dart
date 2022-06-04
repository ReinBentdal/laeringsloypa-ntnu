import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loypa/data/model/Resultat.dart';

final ledertavleProvider = ChangeNotifierProvider.autoDispose
    .family<LedertavleController, String>(
        (ref, loypeId) => LedertavleController(loypeId));

class LedertavleController extends ChangeNotifier {
  LedertavleController(this.loypeId) : super();

  final String loypeId;
  bool _henter = false;
  bool flerTilgjengelig = true;
  List<DocumentSnapshot<Map<String, dynamic>>> resultater = [];

  static const limit = 20;

  Future<void> hentFler() async {
    if (flerTilgjengelig == false || _henter) return;

    this._henter = true;

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('ledertavle')
        .where('løype_id', isEqualTo: this.loypeId)
        .orderBy('tid', descending: false)
        .limit(limit);

    if (this.resultater.length != 0)
      query = query.startAfterDocument(this.resultater.last);

    final nyeResultater = await query.get();

    if (nyeResultater.size < limit) this.flerTilgjengelig = false;

    this.resultater.addAll(nyeResultater.docs);

    if (this.resultater.length >= 100) this.flerTilgjengelig = false;

    this._henter = false;

    this.notifyListeners();
  }

  List<ResultatModel> hentResultater() {
    return this
        .resultater
        .map((resultat) => ResultatModel.fromJson(resultat.data()!))
        .toList();
  }
}
