import 'dart:convert';
import 'package:flutter_kasir/models/response_data_map.dart';
import 'package:flutter_kasir/models/user_login.dart';
import 'package:flutter_kasir/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  Future registerUser(data) async {
    var uri = Uri.parse("${url.BaseUrl}/auth/register");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
            status: true, message: "Sukses ditambakan", data: data);
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += '${data["message"][key][0]}\n';
        }
        ResponseDataMap response =
            ResponseDataMap(status: false, message: message);
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${register.statusCode}");
      return response;
    }
  }

  Future loginUser(data) async {
  var uri = Uri.parse("${url.BaseUrl}/auth/login");
  var login = await http.post(uri, body: data);

  if (login.statusCode == 200) {
    var data = json.decode(login.body);
    if (data["status"] == true) {
      UserLogin userLogin = UserLogin(
          status: data["status"],
          token: data["token"],
          message: data["message"],
          id: data["user"]["id"],
          nama_user: data["user"]["nama_user"],
          email: data["user"]["email"],
          role: data["user"]["role"]);
      await userLogin.prefs();
      ResponseDataMap response = ResponseDataMap(
          status: true, message: "Sukses login user", data: data);
      return response;
    } else {
      ResponseDataMap response =
          ResponseDataMap(status: false, message: 'Email dan password salah');
      return response;
    }
  } else {
    ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "gagal menambah user dengan code error ${login.statusCode}");
    return response;
  }
}
}


