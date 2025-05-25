import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_kasir/models/TokoS.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_kasir/widgets/alert.dart';
import 'package:flutter_kasir/services/tokoService.dart';

class Tambahbarangview extends StatefulWidget {
  final String title;
  final BarangModel? item; // <-- Perbaiki di sini!
  const Tambahbarangview({super.key, required this.title, this.item});

  @override
  State<Tambahbarangview> createState() => _TambahMovieViewState();
}

class _TambahMovieViewState extends State<Tambahbarangview> {
  Tokoservice barang = Tokoservice();
  final formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController overView = TextEditingController();
  File? selectedImage;
  bool? isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(img!.path);
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.item);
    if (widget.item != null) {
      title.text = widget.item!.barang!;
      harga.text = widget.item!.barang!.toString();
      overView.text = widget.item! as String;
      overView.text;
      selectedImage = null;
    } else {
      title.clear();
      harga.clear();
      overView.clear();
      selectedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: title,
                    decoration: InputDecoration(label: Text("Title")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: harga,
                    decoration: InputDecoration(label: Text("Vote Average")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: overView,
                    decoration: InputDecoration(label: Text("OverView")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'harus diisi';
                      } else {
                        return null;
                      }
                    }),
                TextButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Select Picture")),
                selectedImage != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(selectedImage!),
                      )
                    : isLoading == true
                        ? CircularProgressIndicator()
                        : Center(child: Text("Please Get the Images")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var data = {
                          "title": title.text,
                          "voteaverage": harga.text,
                          "overview": overView.text,
                        };
                        print(data);
                        print(selectedImage);
                        var result;
                        if (widget.item != null) {
                          result = await barang.insertGambar(
                              data, selectedImage, widget.item!.barang);
                        } else {
                          result = await barang.insertGambar(
                              data, selectedImage, null);
                        }

                        if (result.status == true) {
                          AlertMessage()
                              .showAlert(context, result.message, true);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/toko');
                        } else {
                          AlertMessage()
                              .showAlert(context, result.message, false);
                        }
                      }
                    },
                    child: Text("Simpan"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
