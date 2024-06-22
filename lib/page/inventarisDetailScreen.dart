import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/model/inventaris_model.dart';

import '../service/db_service.dart';

class DetailInventaris extends StatefulWidget {
  const DetailInventaris(
      {super.key, this.inventaris, required this.updateInventarisList});

  final InventarisModel? inventaris;
  final Function updateInventarisList;

  @override
  State<DetailInventaris> createState() => _DetailInventarisState();
}

class _DetailInventarisState extends State<DetailInventaris> {
  final _formKey = GlobalKey<FormState>();
  String _namaBarang = '';
  double _harga = 0;
  int _jumlah = 0;


  @override
  void initState() {
    super.initState();
    if (widget.inventaris != null) {
      _namaBarang = widget.inventaris!.namaBarang;
      _harga = widget.inventaris!.harga;
      _jumlah = widget.inventaris!.jumlah;
    }
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.inventaris == null) {
        InventarisModel newInventaris = InventarisModel(
          namaBarang: _namaBarang,
          harga: _harga,
          jumlah: _jumlah,
        );
        DBHelper().postInventaris(newInventaris);
      } else {
        InventarisModel updatedInventaris = InventarisModel(
          id: widget.inventaris!.id,
          namaBarang: _namaBarang,
          harga: _harga,
          jumlah: _jumlah,
        );
        DBHelper().updateInventaris(updatedInventaris);
      }
      widget.updateInventarisList();
      Navigator.pop(context);
    }
  }

  void reset() {
    _formKey.currentState!.reset();
    setState(() {
      _namaBarang = '';
      _harga = 0;
      _jumlah = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.inventaris == null ? 'Tambah Barang' : 'Edit Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                
                initialValue: _namaBarang,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                ),
                validator: (input) =>
                    input!.trim().isEmpty ? 'Masukkan Nama Barang' : null,
                onSaved: (input) => _namaBarang = input!,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _harga.toString(),
                decoration: const InputDecoration(
                  labelText: 'Harga',
                ),
                validator: (input) =>
                    input!.trim().isEmpty ? 'Masukkan Harga' : null,
                onSaved: (input) => _harga = double.parse(input!),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _jumlah.toString(),
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                ),
                validator: (input) =>
                    input!.trim().isEmpty ? 'Masukkan Jumlah' : null,
                onSaved: (input) => _jumlah = int.parse(input!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: reset,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
