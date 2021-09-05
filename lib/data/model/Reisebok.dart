class ReisebokaModel {
  final List<ReisebokBokmerkeModel> bokmerker;

  ReisebokaModel({required this.bokmerker});

  factory ReisebokaModel.fromJson(Map<String, dynamic> json) {
    return ReisebokaModel(
      bokmerker: json['bokmerker'].map<ReisebokBokmerkeModel>((bokmerke) {
        return ReisebokBokmerkeModel.fromJson(bokmerke);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bokmerker': bokmerker.map((bokmerke) => bokmerke.toJson()).toList(),
    };
  }
}

class ReisebokBokmerkeModel {
  final String markdownInnhold;
  final String ikon;
  final String tittel;

  ReisebokBokmerkeModel({
    required this.markdownInnhold,
    required this.ikon,
    required this.tittel,
  });

  factory ReisebokBokmerkeModel.fromJson(Map<String, dynamic> json) {
    return ReisebokBokmerkeModel(
      tittel: json['tittel'],
      ikon: json['ikon'],
      markdownInnhold: json['innhold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tittel': tittel,
      'ikon': ikon,
      'innhold': markdownInnhold,
    };
  }
}
