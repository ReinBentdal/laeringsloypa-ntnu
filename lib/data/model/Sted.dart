import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loypa/data/model/Person.dart';

class StedsModel {
  final List<PersonModel> personer;
  final List<LatLng> kartmarkering;
  final String stedsnavn;
  final String stedsbeskrivelse;
  StedsModel({
    required this.personer,
    required this.stedsnavn,
    required this.kartmarkering,
    required this.stedsbeskrivelse,
  });

  factory StedsModel.fromJson(Map<String, dynamic> json) {
    return StedsModel(
      stedsnavn: json['stedsnavn'],
      stedsbeskrivelse: json['stedsbeskrivelse'],
      personer: json['personer']
          .map<PersonModel>((person) => PersonModel.fromJson(person))
          .toList(),
      kartmarkering: json['kartmarkering']
          .map<LatLng>((loc) => LatLng(loc.latitude, loc.longitude))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stedsnavn': stedsnavn,
      'stedsbeskrivelse': stedsbeskrivelse,
      'personer': personer.map((person) => person.toJson()).toList(),
      'kartmarkering': kartmarkering
          .map((markering) => GeoPoint(markering.latitude, markering.longitude))
          .toList(),
    };
  }
}
