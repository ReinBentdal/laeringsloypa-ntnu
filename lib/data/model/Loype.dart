import 'package:loypa/data/model/Reisebok.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/data/model/Sted.dart';

class LoypeModel {
  final String id;
  final List<StedsModel> steder;
  final ReisebokaModel reiseboka;
  final List<RyggsekkGjenstandModel> ryggsekkStartinnhold;
  final String loypenavn;

  LoypeModel({
    required this.id,
    required this.steder,
    required this.reiseboka,
    required this.ryggsekkStartinnhold,
    required this.loypenavn,
  });

  factory LoypeModel.fromJson(String id, Map<String, dynamic> json) {
    return LoypeModel(
      id: id,
      steder: json['steder'].map<StedsModel>((sted) => StedsModel.fromJson(sted)).toList(),
      reiseboka: ReisebokaModel.fromJson(json['reiseboka']),
      ryggsekkStartinnhold: json['ryggsekk_startinnhold'].map<RyggsekkGjenstandModel>((gjenstand) {
        return RyggsekkGjenstandModel.fromJson(gjenstand);
      }).toList(),
      loypenavn: json['løypenavn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steder': steder.map((sted) => sted.toJson()).toList(),
      'reiseboka': reiseboka.toJson(),
      'ryggsekk_startinnhold': ryggsekkStartinnhold.map((gjenstand) => gjenstand.toJson()).toList(),
      'løypenavn': loypenavn,
    };
  }
}

class LoypeInfoModel {
  final String id;
  final String navn;
  final Duration estimertTid;
  final String startlokasjon;
  final bool public;

  LoypeInfoModel({
    required this.id,
    required this.navn,
    required this.estimertTid,
    required this.startlokasjon,
    required this.public,
  });

  factory LoypeInfoModel.fromJson(Map<String, dynamic> json) {
    return LoypeInfoModel(
      id: json['løype_id'],
      navn: json['løypenavn'],
      estimertTid: Duration(minutes: json['estimert_tid']),
      startlokasjon: json['startlokasjon'],
      public: json['public'],
    );
  }
}
