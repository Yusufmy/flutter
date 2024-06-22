import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../page/model/inventaris_model.dart';

class DBHelper {
  //DBHelper yang digunkana untuk seluruh aplikasi
  static final DBHelper _instance = DBHelper._intenal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._intenal(); //konstruktor privat yang digunakan untuk membuat instance tunggal.


  ///Menginisialisasi database
  Future<Database> get database async {
    ///Jika sudah diinisialisasi maka akan mengembalikan instance database
    if (_database != null) {
      return _database!;
    }

    ///Jika belum diinisialisasi maka akan membuat database baru
    _database = await _initDatabse();
    return _database!;
  }

  ///Membuat database baru dan tabel inventaris
  Future<Database> _initDatabse() async {
    return openDatabase(
      join(await getDatabasesPath(), 'inventaris.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE inventaris(id_barang INTEGER PRIMARY KEY, nama_barang TEXT, harga REAL, jumlah INTEGER)',
        );
      },
      version: 1,
    );
  }

  
  ///Mengirimkan data inventaris
  Future<void> postInventaris(InventarisModel inventaris) async {
    final db = await database;
    await db.insert(
      'inventaris',
      inventaris.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  ///Mengambil data inventaris
  Future<List<InventarisModel>> getInventaris() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('inventaris');
    return List.generate(maps.length, (i) {
      return InventarisModel(
        id: maps[i]['id_barang'],
        namaBarang: maps[i]['nama_barang'],
        harga: maps[i]['harga'],
        jumlah: maps[i]['jumlah'],
      );
    });
  }

  ///update data inventaris
  Future<void> updateInventaris(InventarisModel inventaris) async {
    final db = await database;
    await db.update(
      'inventaris',
      inventaris.toMap(),
      where: 'id_barang = ?',
      whereArgs: [inventaris.id],
    );
  }

  Future<void> deleteInventaris(int id) async {
    final db = await database;
    await db.delete(
      'inventaris',
      where: 'id_barang = ?',
      whereArgs: [id],
    );
  }
}
