// To parse this JSON data, do
//
//     final cars = carsFromMap(jsonString);

import 'dart:convert';

Cars carsFromMap(String str) => Cars.fromMap(json.decode(str));

String carsToMap(Cars data) => json.encode(data.toMap());

class Cars {
  Cars({
    required this.carsName,
    required this.country,
    required this.kYear,
    required this.model,
  });

  final String carsName;
  final String country;
  final int kYear;
  final List<Model> model;

  factory Cars.fromMap(Map<String, dynamic> json) => Cars(
    carsName: json["cars_name"],
    country: json["country"],
    kYear: json["k_year"],
    model: List<Model>.from(json["model"].map((x) => Model.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "cars_name": carsName,
    "country": country,
    "k_year": kYear,
    "model": List<dynamic>.from(model.map((x) => x.toMap())),
  };
}

class Model {
  Model({
    required this.modelAdi,
    required this.fiyat,
    required this.benzinli,
  });

  final String modelAdi;
  final int fiyat;
  final bool benzinli;

  factory Model.fromMap(Map<String, dynamic> json) => Model(
    modelAdi: json["model_adi"],
    fiyat: json["fiyat"],
    benzinli: json["benzinli"],
  );

  Map<String, dynamic> toMap() => {
    "model_adi": modelAdi,
    "fiyat": fiyat,
    "benzinli": benzinli,
  };
}
