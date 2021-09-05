class RyggsekkGjenstandModel {
  bool sett = false; // TODO: fjerne
  final String ikon;
  final String navn;
  final String beskrivelse;
  final String? ekstraRessurs;
  final String? tilpassetKnapptekst;

  RyggsekkGjenstandModel({
    required this.navn,
    required this.beskrivelse,
    required this.ikon,
    this.ekstraRessurs,
    this.tilpassetKnapptekst,
  });

  factory RyggsekkGjenstandModel.fromJson(Map<String, dynamic> json) {
    return RyggsekkGjenstandModel(
      navn: json['navn'],
      beskrivelse: json['beskrivelse'],
      ikon: json['ikon'],
      ekstraRessurs: json['ekstra_ressurs'] ?? null,
      tilpassetKnapptekst: json['tilpasset_knapp_tekst'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {'navn': navn, 'beskrivelse': beskrivelse, 'ikon': ikon};

    if (ekstraRessurs != null)
      json.addAll({
        'ekstra_ressurs': ekstraRessurs!,
      });

    if (tilpassetKnapptekst != null)
      json.addAll({
        'tilpasset_knapp_tekst': tilpassetKnapptekst!,
      });

    return json;
  }
}
