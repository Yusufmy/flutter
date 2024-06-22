class InventarisModel {
  final int? id;
  final String namaBarang;
  final double harga;
  final int jumlah;

  InventarisModel({
    this.id,
    required this.namaBarang,
    required this.harga,
    required this.jumlah,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_barang': id,
      'nama_barang': namaBarang,
      'harga': harga,
      'jumlah': jumlah,
    };
  }

  factory InventarisModel.fromMap(Map<String, dynamic> map) {
    return InventarisModel(
      id: map['id_barang'],
      namaBarang: map['nama_barang'],
      harga: map['harga'],
      jumlah: map['jumlah'],
    );
  }
}
