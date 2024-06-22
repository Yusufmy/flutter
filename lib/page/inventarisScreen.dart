import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/inventarisDetailScreen.dart';
import 'package:flutter_application_1/page/model/inventaris_model.dart';

import '../service/db_service.dart';

class InventarisScreen extends StatefulWidget {
  const InventarisScreen({super.key});

  @override
  State<InventarisScreen> createState() => _InventarisScreenState();
}

class _InventarisScreenState extends State<InventarisScreen> {
  late Future<List<InventarisModel>> _inventarisList;

  @override
  void initState() {
    _updateInventaris();
    super.initState();
  }

  @override
  _updateInventaris() {
    setState(() {
      _inventarisList = DBHelper().getInventaris();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris'),
      ),
      body: FutureBuilder(
        future: _inventarisList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return SnackBar(
              content: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<InventarisModel> inventarisList =
                snapshot.data as List<InventarisModel>;
            return ListView.builder(
              itemCount: inventarisList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 18, right: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(inventarisList[index].namaBarang),
                            subtitle: Text(
                                'Harga: ${inventarisList[index].harga} | Jumlah: ${inventarisList[index].jumlah}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailInventaris(
                                    inventaris: inventarisList[index],
                                    updateInventarisList: _updateInventaris,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            DBHelper()
                                .deleteInventaris(inventarisList[index].id!);
                            _updateInventaris();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailInventaris(
                  updateInventarisList: _updateInventaris,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
