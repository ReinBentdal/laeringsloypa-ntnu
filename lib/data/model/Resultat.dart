import 'package:cloud_firestore/cloud_firestore.dart';

class ResultatModel {
  final String navn;
  final Duration tid;
  final String loypeId;
  final String gruppeId;
  final DateTime tidsstempel;

  ResultatModel({
    required this.navn,
    required this.tid,
    required this.gruppeId,
    required this.loypeId,
    required this.tidsstempel,
  });

  factory ResultatModel.fromJson(Map<String, dynamic> json) {
    return ResultatModel(
      navn: json['navn'],
      tid: Duration(seconds: json['tid']),
      gruppeId: json['gruppe_id'],
      loypeId: json['løype_id'],
      tidsstempel: (json['tidsstempel'] as Timestamp).toDate(),
    );
  }
}
