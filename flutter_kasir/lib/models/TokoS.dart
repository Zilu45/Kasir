import 'package:flutter_kasir/services/url.dart' as url;

class BarangModel {
  int? id;
  String? barang;
  double? harga;
  String? overview;
  String? image;
  BarangModel({
    required this.id,
    required this.barang,
    this.harga,
    this.overview,
    required this.image,
  });
  BarangModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    barang = parsedJson["barang"];
    harga = double.tryParse(parsedJson["harga"].toString()) ?? 0;
    overview = parsedJson["overview"];
    image = parsedJson["posterpath"] != null
        ? "${url.BaseUrlTanpaAPi}/${parsedJson["posterpath"]}"
        : "https://picsum.photos/200/300";
  }
}
