// To parse this JSON data, do
//
//     final raraResponse = raraResponseFromMap(jsonString);

import 'dart:convert';

RaraResponse raraResponseFromMap(String str) =>
    RaraResponse.fromMap(json.decode(str));

String raraResponseToMap(RaraResponse data) => json.encode(data.toMap());

class RaraResponse {
  RaraResponse({
    required this.data,
  });

  List<Rara> data;

  // factory RaraResponse.empty() => [];

  factory RaraResponse.fromMap(Map<String, dynamic> json) => RaraResponse(
        data: json["data"] == null
            ? []
            : List<Rara>.from(json["data"].map((x) => Rara.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data":
            data == null ? [] : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Rara {
  Rara({
    required this.idLokasi,
    required this.kota,
    required this.namaLokasi,
    required this.latLokasi,
    required this.lonLokasi,
    required this.m3U8,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.weatherStatus,
  });

  int idLokasi;
  String kota;
  String namaLokasi;
  String latLokasi;
  String lonLokasi;
  String m3U8;
  String publishedAt;
  String createdAt;
  String updatedAt;
  String weatherStatus;

  factory Rara.empty() => Rara(
      idLokasi: 0,
      kota: '',
      namaLokasi: '',
      latLokasi: '',
      lonLokasi: '',
      m3U8: '',
      publishedAt: '',
      createdAt: '',
      updatedAt: '',
      weatherStatus: '');

  factory Rara.fromMap(Map<String, dynamic> json) => Rara(
        idLokasi: json["id_lokasi"] == null ? 0 : json["id_lokasi"],
        kota: json["kota"] == null ? "" : json["kota"],
        namaLokasi: json["nama_lokasi"] == null ? "" : json["nama_lokasi"],
        latLokasi: json["lat_lokasi"] == null ? "" : json["lat_lokasi"],
        lonLokasi: json["lon_lokasi"] == null ? "" : json["lon_lokasi"],
        m3U8: json["m3u8"] == null ? "" : json["m3u8"],
        publishedAt: json["published_at"] == null ? "" : json["published_at"],
        createdAt: json["created_at"] == null ? "" : json["created_at"],
        updatedAt: json["updated_at"] == null ? "" : json["updated_at"],
        weatherStatus:
            json["weather_status"] == null ? '' : json["weather_status"],
      );

  Map<String, dynamic> toMap() => {
        "id_lokasi": idLokasi,
        "kota": kota,
        "nama_lokasi": namaLokasi,
        "lat_lokasi": latLokasi,
        "lon_lokasi": lonLokasi,
        "m3u8": m3U8,
        "published_at": publishedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "weather_status": weatherStatus,
      };
}
