import 'package:flutter/material.dart';
import 'package:flutter_kasir/views/TambahBarangView.dart';
import 'package:flutter_kasir/views/Toko.dart';
import 'package:flutter_kasir/views/UserLogin.dart';
import 'package:flutter_kasir/views/home_User.dart';
import 'package:flutter_kasir/views/register_user_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/toko',
    routes: {
      '/':(context) => RegisterUserView(),
      '/login':(context) => LoginView(),
      '/home':(context) => DashboardView(),
      '/toko':(context) => Tokoview()
    
    }
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
