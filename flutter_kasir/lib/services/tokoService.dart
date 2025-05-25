import 'dart:convert';
import 'package:flutter_kasir/models/TokoS.dart';
import 'package:flutter_kasir/models/response_data_list.dart';
import 'package:flutter_kasir/models/response_data_map.dart';
import 'package:flutter_kasir/models/user_login.dart';
import 'package:flutter_kasir/services/url.dart' as url;
import 'package:http/http.dart' as http;

class Tokoservice {
  Future<ResponseDataList> getBarang() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    var uri = Uri.parse('${url.BaseUrl}/admin/getmovie');
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };

    try {
      var getBarang = await http.get(uri, headers: headers);
      if (getBarang.statusCode == 200) {
        var data = json.decode(getBarang.body);
        if (data["status"] == true) {
          List<BarangModel> barang = [];
          if (data["data"] != null) {
            barang = List<BarangModel>.from(
              data["data"].map((r) => BarangModel.fromJson(r)),
            );
          }
          return ResponseDataList(
            status: true,
            message: 'Success load data',
            data: barang,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: 'Failed load data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Gagal load data dengan code error ${getBarang.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: "Exception: $e",
      );
    }
  }

  Future<ResponseDataMap> insertGambar(request, image, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataMap(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };

    var respons;
    if (id == null) {
      respons = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/insertmovie"),
      );
    } else {
      respons = http.MultipartRequest(
        'POST',
        Uri.parse("${url.BaseUrl}/admin/updatemovie/$id"),
      );
    }

    if (image != null) {
      respons.files.add(http.MultipartFile(
        'posterpath',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ));
    }

    respons.headers.addAll(headers);
    respons.fields['title'] = request["title"];
    respons.fields['voteaverage'] = request["voteaverage"];
    respons.fields['overview'] = request["overview"];

    try {
      var res = await respons.send();
      var result = await http.Response.fromStream(res);

      if (res.statusCode == 200) {
        var data = json.decode(result.body);
        if (data["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: 'Success insert / update data',
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: 'Failed insert / update data',
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Gagal insert/update dengan code error ${res.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: "Exception: $e",
      );
    }
  }

  Future<ResponseDataList> hapusBarang(context, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    var uri = Uri.parse('${url.BaseUrl}/admin/hapusmovie/$id');

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
    };

    try {
      var hapusBarang = await http.delete(uri, headers: headers);

      if (hapusBarang.statusCode == 200) {
        var result = json.decode(hapusBarang.body);
        if (result["status"] == true) {
          return ResponseDataList(
            status: true,
            message: 'Success hapus data',
          );
        } else {
          return ResponseDataList(
            status: false,
            message: 'Failed hapus data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message:
              "Gagal hapus data dengan code error ${hapusBarang.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: "Exception: $e",
      );
    }
  }

  Future<ResponseDataList> getMBarangUser() async {
    var uri = Uri.parse('${url.BaseUrl}/user/getmovie');
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};

    try {
      var getBarng = await http.get(uri, headers: headers);

      if (getBarng.statusCode == 200) {
        var data = json.decode(getBarng.body);
        if (data["status"] == true) {
          List<BarangModel> movie = [];
          if (data["data"] != null) {
            movie = List<BarangModel>.from(
              data["data"].map((r) => BarangModel.fromJson(r)),
            );
          }
          return ResponseDataList(
            status: true,
            message: 'Success load data',
            data: movie,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: 'Failed load data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Gagal load data dengan code error ${getBarng.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: "Exception: $e",
      );
    }
  }
}
