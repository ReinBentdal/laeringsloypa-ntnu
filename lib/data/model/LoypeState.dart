import 'Loype.dart';
import 'Sted.dart';

class PersonStateModel {
  final bool oppgaveLost;
  final bool samtaleLest;
  final List<bool> hintBrukt;

  PersonStateModel({
    required this.oppgaveLost,
    required this.samtaleLest,
    required this.hintBrukt,
  });

  factory PersonStateModel.fromJson(Map<dynamic, dynamic> json) {
    return PersonStateModel(
      oppgaveLost: json['oppgave_løst'],
      samtaleLest: json['samtale_lest'],
      hintBrukt: (json['hint_brukt'] as List<dynamic>).cast<bool>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oppgave_løst': oppgaveLost,
      'samtale_lest': samtaleLest,
      'hint_brukt': hintBrukt,
    };
  }

  PersonStateModel copyWith({
    bool? oppgaveLost,
    bool? samtaleLest,
    List<bool>? hintBrukt,
  }) {
    return PersonStateModel(
      oppgaveLost: oppgaveLost ?? this.oppgaveLost,
      samtaleLest: samtaleLest ?? this.samtaleLest,
      hintBrukt: hintBrukt ?? this.hintBrukt,
    );
  }
}

class StedStateModel {
  final bool fullfort;
  final Map<String, PersonStateModel> personer;

  StedStateModel({required this.fullfort, required this.personer});

  factory StedStateModel.fromStedModel(StedsModel sted) {
    return StedStateModel(
      fullfort: false,
      personer: Map.fromEntries(
        sted.personer.map(
          (person) => MapEntry(
            person.id,
            PersonStateModel(
              oppgaveLost: false,
              samtaleLest: false,
              hintBrukt: person.oppgave.hint.map((_) => false).toList(),
            ),
          ),
        ),
      ),
    );
  }

  factory StedStateModel.fromJson(Map<dynamic, dynamic> json) {
    return StedStateModel(
      fullfort: json['fullført'],
      personer: (json['personer'] as Map<dynamic, dynamic>).cast<String, Map<dynamic, dynamic>>().map(
        (String key, Map<dynamic, dynamic> person) => MapEntry(
          key,
          PersonStateModel.fromJson(person),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullført': fullfort,
      'personer': personer.map((key, person) => MapEntry(key, person.toJson())),
    };
  }

  StedStateModel copyWith({
    bool? fullfort,
    Map<String, PersonStateModel>? personer,
  }) {
    return StedStateModel(
      fullfort: fullfort ?? this.fullfort,
      personer:
          personer != null ? (Map<String, PersonStateModel>.from(this.personer)..addAll(personer)) : this.personer,
    );
  }
}

class LoypeStateModel {
  final String loypeId;
  final String gruppeId;
  final bool gyldig;
  final Map<String, bool> ryggsekkgjenstanderSett; // id -> gjenstand sett
  final Map<String, StedStateModel> steder; // id -> sted

  LoypeStateModel({
    required this.loypeId,
    required this.gruppeId,
    required this.ryggsekkgjenstanderSett,
    required this.steder,
    this.gyldig = false,
  });

  factory LoypeStateModel.fromLoypeModel(String gruppeId, LoypeModel loype) {
    return LoypeStateModel(
      loypeId: loype.id,
      gruppeId: gruppeId,
      ryggsekkgjenstanderSett: Map.fromEntries(
        loype.ryggsekkStartinnhold.map(
          (gjenstand) => MapEntry(
            gjenstand.id,
            false,
          ),
        ),
      ),
      steder: Map.fromEntries(
        loype.steder.map(
          (sted) => MapEntry(
            sted.id,
            StedStateModel.fromStedModel(sted),
          ),
        ),
      ),
    );
  }

  factory LoypeStateModel.fromJson(Map<dynamic, dynamic> json) {
    return LoypeStateModel(
      loypeId: json['id'],
      gruppeId: json['gruppe_id'],
      ryggsekkgjenstanderSett: (json['ryggsekk'] as Map<dynamic, dynamic>).cast<String, bool>(),
      steder: (json['steder'] as Map<dynamic, dynamic>).cast<String, Map<dynamic, dynamic>>().map(
            (String key, Map<dynamic, dynamic> sted) => MapEntry(
              key,
              StedStateModel.fromJson(sted),
            ),
          ),
      gyldig: json['gyldig'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': loypeId,
      'gruppe_id': gruppeId,
      'ryggsekk': ryggsekkgjenstanderSett,
      'steder': steder.map((key, sted) => MapEntry(key, sted.toJson())),
      'gyldig': gyldig,
    };
  }

  LoypeStateModel copyWith({
    bool? gyldig,
    Map<String, bool>? ryggsekkgjenstanderSett,
    Map<String, StedStateModel>? steder,
  }) {
    final updatedRoute = LoypeStateModel(
      loypeId: loypeId,
      gruppeId: gruppeId,
      ryggsekkgjenstanderSett: ryggsekkgjenstanderSett != null
          ? (Map<String, bool>.from(this.ryggsekkgjenstanderSett)..addAll(ryggsekkgjenstanderSett))
          : this.ryggsekkgjenstanderSett,
      steder: steder != null ? (Map<String, StedStateModel>.from(this.steder)..addAll(steder)) : this.steder,
      gyldig: gyldig ?? this.gyldig,
    );
    return updatedRoute;
  }
}
