import 'package:flutter/material.dart';
import 'package:flutter_kasir/models/response_data_list.dart';
import 'package:flutter_kasir/services/tokoService.dart';
import 'package:flutter_kasir/models/TokoS.dart';
import 'package:flutter_kasir/widgets/alert.dart';
import 'package:flutter_kasir/widgets/bottom_nav.dart';
import 'package:flutter_kasir/views/TambahBarangView.dart';

class Tokoview extends StatefulWidget {
  const Tokoview({super.key});

  @override
  State<Tokoview> createState() => _TokoviewState();
}

class _TokoviewState extends State<Tokoview> {
  Tokoservice barangB = Tokoservice();
  List<BarangModel> produk = [];

  Future<void> getBarang() async {
    ResponseDataList res = await barangB.getBarang();
    List<BarangModel> data = [];
    if (res.data != null) {
      data = List<BarangModel>.from(res.data!);
    }

    if (data.isEmpty) {
      data.addAll([
        BarangModel(
          id: 1,
          barang: "Kecap",
          harga: 20000,
          overview: "ini kecap",
          image: "doksli/kecap.png", 
        ),
        BarangModel(
          id: 2,
          barang: "Sambal",
          harga: 15000,
          overview: "ini sambal pedas",
          image: "doksli/sambal.png", 
        ),
        BarangModel(
          id: 3,
          barang: "Minyak Goreng",
          harga: 25000,
          overview: "minyak goreng 1L",
          image: "doksli/minyak.png", 
        ),
      ]);
    }
    setState(() {
      produk = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barang"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tambahbarangview(
                    title: "Tambah Barang",
                    item: null,
                  ),
                ),
              );
              getBarang();
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: produk.isNotEmpty
          ? ListView.builder(
              itemCount: produk.length,
              itemBuilder: (context, index) {
                final barang = produk[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), 
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), 
                      child: barang.image != null && barang.image!.startsWith('assets/')
                          ? Image.asset(
                              barang.image!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              barang.image ?? "https://picsum.photos/200/300",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Icon(Icons.broken_image),
                            ),
                    ),
                    title: Text(barang.barang ?? '-'),
                    subtitle:
                        Text('Rp${barang.harga?.toStringAsFixed(0) ?? "0"}'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "Update",
                          child: Text("Update"),
                        ),
                        PopupMenuItem(
                          value: "Hapus",
                          child: Text("Hapus"),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == "Update") {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Tambahbarangview(
                                title: "Update Barang",
                                item: barang,
                              ),
                            ),
                          );
                          getBarang();
                        } else if (value == "Hapus") {
                          var results = await AlertMessage().showAlert(
                            context,
                            "Apakah Anda yakin ingin menghapus?",
                            false,
                          );
                          if (results != null &&
                              results.containsKey('status') &&
                              results['status'] == true) {
                            var res =
                                await barangB.hapusBarang(context, barang.id);
                            if (res.status == true) {
                              AlertMessage()
                                  .showAlert(context, res.message, true);
                              getBarang();
                            } else {
                              AlertMessage()
                                  .showAlert(context, res.message, false);
                            }
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            )
          : Center(child: Text("erorr")),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
