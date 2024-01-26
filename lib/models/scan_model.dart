import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

/*
 * Aquesta classe es la que s'encarrega de crear els objectes ScanModel amb els seus atributs. Cada ScanModel conte un id, un tipus i un valor.
 * El tipus es un String que pot ser 'http' o 'geo' segons si el valor conte 'http' o no. Finalment tenim una serie de funcions per poder tractar i convertir
 * dades JSON a objectes ScanModel i viceversa. També tenim una funció que retorna un LatLng a partir del valor del scan.
 * 
 */
class ScanModel {
  int? id;
  String? tipus;
  String valor;

  ScanModel({
    this.id,
    this.tipus,
    required this.valor,
  }) {
    if (valor.contains('http')) {
      tipus = 'http';
    } else {
      tipus = 'geo';
    }
  }

  LatLng getLatLng() {
    final latLng = valor.substring(4).split(',');
    final latitude = double.parse(latLng[0]);
    final longitude = double.parse(latLng[1]);

    return LatLng(latitude, longitude);
  }

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipus: json["tipus"],
        valor: json["valor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tipus": tipus,
        "valor": valor,
      };
}
