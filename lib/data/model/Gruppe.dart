import 'package:cloud_firestore/cloud_firestore.dart';

enum GruppeStatus { Venter, Startet, Avsluttet }

class GruppeModel {
  final String docId;
  final String loypeId;
  final GruppeStatus status;
  final String gruppenavn;
  final String pin;
  final DateTime? startTid;
  final DateTime? sluttTid;
  final bool gyldig;
  final int hintBrukt;

  GruppeModel({
    required this.docId,
    required this.loypeId,
    required this.status,
    required this.gruppenavn,
    required this.pin,
    required this.startTid,
    required this.sluttTid,
    required this.gyldig,
    required this.hintBrukt,
  });

  factory GruppeModel.fromJson(Map<String, dynamic> json) {
    late GruppeStatus status;

    switch (json['status']) {
      case 'venter':
        status = GruppeStatus.Venter;
        break;
      case 'startet':
        status = GruppeStatus.Startet;
        break;
      case 'avsluttet':
        status = GruppeStatus.Avsluttet;
        break;
      default:
        status = GruppeStatus.Avsluttet;
    }

    return GruppeModel(
      docId: json['doc_id'],
      loypeId: json['løype_id'],
      gruppenavn: json['gruppenavn'],
      status: status,
      pin: json['pin'],
      startTid: json['start_tid'] != null
          ? (json['start_tid'] as Timestamp).toDate()
          : null,
      sluttTid: json['slutt_tid'] != null
          ? (json['slutt_tid'] as Timestamp).toDate()
          : null,
      gyldig: json['gyldig'],
      hintBrukt: json['hint_brukt'],
    );
  }
}

class DeltakerModel {
  final String id;
  final String navn;

  DeltakerModel({required this.id, required this.navn});

  factory DeltakerModel.fromJson(Map<String, dynamic> json) {
    return DeltakerModel(
      id: json['doc_id'],
      navn: json['brukernavn'],
    );
  }
}
