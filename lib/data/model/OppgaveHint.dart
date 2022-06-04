class OppgaveHintModel {
  final String hint;

  // bool brukt;

  OppgaveHintModel({
    required this.hint,
    // this.brukt = false,
  });

  factory OppgaveHintModel.fromJson(Map<String, dynamic> json) {
    return OppgaveHintModel(hint: json['hint']);
  }

  Map<String, dynamic> toJson() {
    return {
      'hint': hint,
    };
  }
}
