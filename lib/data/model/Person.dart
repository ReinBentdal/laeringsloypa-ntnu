import 'package:loypa/data/model/Oppgave.dart';

class PersonModel {
  final String id;
  final String navn;
  final PersonSamtaleModel? samtale;
  final String bilde;
  final OppgaveModel oppgave;

  PersonModel({
    required this.id,
    required this.navn,
    this.samtale,
    required this.bilde,
    required this.oppgave,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      navn: json['navn'],
      bilde: json['bilde'],
      samtale: json['samtale'] != null
          ? PersonSamtaleModel.fromJson(json['samtale'])
          : null,
      oppgave: OppgaveModel.fromJson(json['oppgave']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'navn': navn,
      'bilde': bilde,
      'oppgave': oppgave.toJson(),
    };

    if (samtale != null)
      json.addAll(
        {'samtale': samtale!.toJson()},
      );

    return json;
  }
}

class PersonSamtaleModel {
  final String tittel;
  final List<String> dialog;

  PersonSamtaleModel({
    required this.tittel,
    required this.dialog,
    // this.lest = false,
  });

  factory PersonSamtaleModel.fromJson(Map<String, dynamic> json) {
    return PersonSamtaleModel(
      tittel: json['tittel'],
      dialog: json['dialog'].map<String>((dialog) {
        return dialog.toString();
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tittel': tittel,
      'dialog': dialog,
    };
  }
}
