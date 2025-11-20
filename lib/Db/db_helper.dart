import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // 1. Singleton Pattern (Agar koneksi database stabil)
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "akirarent.db");

    return await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) async {
        // Buat Tabel Users (Gunakan IF NOT EXISTS)
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            nik TEXT,
            email TEXT,
            notelp TEXT,
            alamat TEXT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');

        // Buat Tabel Sewa (Gunakan IF NOT EXISTS)
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sewa (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_mobil TEXT,
            gambar_mobil TEXT,
            harga_per_hari INTEGER,
            nama_penyewa TEXT,
            lama_sewa INTEGER,
            tanggal_mulai TEXT,
            total_biaya INTEGER,
            status TEXT DEFAULT 'Aktif' 
          )
        ''');
      },
      // FUNGSI UPDATE DATABASE OTOMATIS
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Gunakan IF NOT EXISTS juga di sini untuk keamanan ekstra
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sewa (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nama_mobil TEXT,
              gambar_mobil TEXT,
              harga_per_hari INTEGER,
              nama_penyewa TEXT,
              lama_sewa INTEGER,
              tanggal_mulai TEXT,
              total_biaya INTEGER,
              status TEXT DEFAULT 'Aktif' 
            )
          ''');
        }
      },
    );
  }

  // --- FUNGSI USER (REGISTER & LOGIN) ---
  Future<int> registerUser(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("users", data);
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      "users",
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // --- FUNGSI TRANSAKSI SEWA ---
  
  // 1. Tambah Sewa
  Future<int> tambahSewa(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("sewa", data);
  }

  // 2. Ambil Semua Riwayat
  Future<List<Map<String, dynamic>>> getAllSewa() async {
    final db = await database;
    return await db.query("sewa", orderBy: "id DESC");
  }

  // 3. Ambil Detail Sewa per ID
  Future<Map<String, dynamic>?> getSewaById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      "sewa",
      where: "id = ?",
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // 4. Update Data Sewa
  Future<int> updateSewa(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      "sewa",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // 5. Update Status Sewa
  Future<int> updateSewaStatus(int id, String newStatus) async {
    final db = await database;
    return await db.update(
      "sewa",
      {'status': newStatus},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}