import 'package:loypa/data/model/Reisebok.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/data/model/Sted.dart';

class LoypeModel {
  final List<StedsModel> steder;
  final ReisebokaModel reiseboka;
  final List<RyggsekkGjenstandModel> ryggsekkStartinnhold;
  final String loypenavn;

  LoypeModel(
      {required this.steder,
      required this.reiseboka,
      required this.ryggsekkStartinnhold,
      required this.loypenavn});

  factory LoypeModel.fromJson(Map<String, dynamic> json) {
    return LoypeModel(
      steder: json['steder']
          .map<StedsModel>((sted) => StedsModel.fromJson(sted))
          .toList(),
      reiseboka: ReisebokaModel.fromJson(json['reiseboka']),
      ryggsekkStartinnhold: json['ryggsekk_startinnhold']
          .map<RyggsekkGjenstandModel>((gjenstand) {
        return RyggsekkGjenstandModel.fromJson(gjenstand);
      }).toList(),
      loypenavn: json['løypenavn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steder': steder.map((sted) => sted.toJson()).toList(),
      'reiseboka': reiseboka.toJson(),
      'ryggsekk_startinnhold':
          ryggsekkStartinnhold.map((gjenstand) => gjenstand.toJson()).toList(),
      'løypenavn': loypenavn,
    };
  }
}

class LoypeInfoModel {
  final String navn;
  final String id;
  final Duration estimertTid;
  final String startlokasjon;

  LoypeInfoModel({
    required this.navn,
    required this.id,
    required this.estimertTid,
    required this.startlokasjon,
  });

  factory LoypeInfoModel.fromJson(Map<String, dynamic> json) {
    return LoypeInfoModel(
      navn: json['løypenavn'],
      id: json['løype_id'],
      estimertTid: Duration(minutes: json['estimert_tid']),
      startlokasjon: json['startlokasjon'],
    );
  }
}
