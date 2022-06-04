import 'package:loypa/data/model/OppgaveHint.dart';
import 'package:loypa/data/model/Ryggsekk.dart';
import 'package:loypa/data/type/InputType.dart';

enum OppgaveType {
  tekst,
  markdownTekst,
  heltall,
  desimal,
  pinkode,
  gjomtTekst,
}

class OppgaveModel {
  final String oppgavetekst;
  final String? oppgaveKnappTekst;
  final BaseInputType typespesifikk;
  final String riktigSvar;
  final List<RyggsekkGjenstandModel>? belonning;
  final List<OppgaveHintModel> hint;
  final int rekkefolge;

  // bool oppgaveLost;

  OppgaveModel({
    required this.oppgavetekst,
    required this.riktigSvar,
    required this.typespesifikk,
    required this.hint,
    required this.rekkefolge,
    this.oppgaveKnappTekst,
    this.belonning,
    // this.oppgaveLost = false,
  });

  factory OppgaveModel.fromJson(Map<String, dynamic> json) {
    final typeSpesifikk = () {
      final spesifikk = json['typespesifikk'];
      switch (json['type']) {
        case 'markdown':
          return MarkdownTekstInputType(innhold: spesifikk['innhold']);
        case 'heltall':
          return HeltallInputType(enhet: spesifikk['enhet']);
        case 'desimal':
          return DesimalInputType(enhet: spesifikk['enhet']);
        case 'pinkode':
          return PinkodeInputType(
            antall: spesifikk['antall'],
            antallPerFelt: spesifikk['antall_per_felt'],
            hintTekst: spesifikk['hint_tekst'] != null
                ? spesifikk['hint_tekst']
                    .map<String>((hint) => hint.toString())
                    .toList()
                : null,
          );
        case 'sjult':
          return GjomtTekstInputType(
            tekst: spesifikk['tekst']
                .map<String>((tekst) => tekst.toString())
                .toList(),
            hintTekst: spesifikk['hint_tekst'] != null
                ? spesifikk['hint_tekst'].map<String>((hint) => hint).toList()
                : null,
          );
        default:
          return TekstInputType();
      }
    };

    return OppgaveModel(
      oppgavetekst: json['oppgavetekst'],
      riktigSvar: json['riktig_svar'],
      oppgaveKnappTekst: json['oppgave_knapp_tekst'] ?? null,
      typespesifikk: typeSpesifikk(),
      hint: json['hint'].map<OppgaveHintModel>((hint) {
        return OppgaveHintModel(hint: hint);
      }).toList(),
      belonning: json['belønning'] != null
          ? json['belønning'].map<RyggsekkGjenstandModel>((belonning) {
              return RyggsekkGjenstandModel.fromJson(belonning);
            }).toList()
          : null,
      rekkefolge: json['rekkefølge'],
    );
  }

  Map<String, dynamic> toJson() {
    String type = typespesifikk.map(
      tekstInput: () => 'tekst',
      heltallInput: (_) => 'heltall',
      desimalInput: (_) => 'desimal',
      pinkodeInput: (_) => 'pinkode',
      gjomtTekst: (_) => 'sjult',
      markdownTekstInput: (_) => 'markdown',
    );
    final Map<String, dynamic>? spesifikk = typespesifikk.map(
      tekstInput: () => null,
      heltallInput: (heltall) => {
        'enhet': heltall.enhet,
      },
      desimalInput: (desimal) => {
        'enhet': desimal.enhet,
      },
      pinkodeInput: (pinkode) {
        final json = <String, dynamic>{
          'antall': pinkode.antall,
          'antall_per_felt': pinkode.antallPerFelt,
        };
        if (pinkode.hintTekst != null)
          json.addAll({'hint_tekst': pinkode.hintTekst});
        return json;
      },
      gjomtTekst: (gjomt) {
        final json = <String, dynamic>{
          'tekst': gjomt.tekst,
        };
        if (gjomt.hintTekst != null)
          json.addAll({'hint_tekst': gjomt.hintTekst});
        return json;
      },
      markdownTekstInput: (markdown) => {
        'innhold': markdown.innhold,
      },
    );

    final json = <String, dynamic>{
      'oppgavetekst': oppgavetekst,
      'riktig_svar': riktigSvar,
      'type': type,
      'hint': hint.map<String>((hint) => hint.hint).toList(),
      'rekkefølge': rekkefolge,
    };

    if (spesifikk != null)
      json.addAll({
        'typespesifikk': spesifikk,
      });

    if (oppgaveKnappTekst != null)
      json.addAll({
        'oppgave_knapp_tekst': oppgaveKnappTekst,
      });

    if (belonning != null)
      json.addAll({
        'belønning': belonning!.map((belonning) => belonning.toJson()).toList(),
      });

    return json;
  }
}
