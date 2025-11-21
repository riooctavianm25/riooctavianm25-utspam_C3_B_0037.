import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa tambahkan intl di pubspec.yaml jika belum
import 'package:uts_3012310037/Db/db_helper.dart';
import 'package:uts_3012310037/Db/model/mobil.dart';
import 'package:uts_3012310037/page/home/home_screen.dart';


class FormSewaScreen extends StatefulWidget {
  final Mobil mobil; // Data mobil yang dipilih dari halaman sebelumnya
  final int userId;
  final String namaUser;

  const FormSewaScreen({super.key, required this.mobil, required this.namaUser, required this.userId});

  @override
  State<FormSewaScreen> createState() => _FormSewaScreenState();
}

class _FormSewaScreenState extends State<FormSewaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller
  final _namaPenyewaCtr = TextEditingController();
  final _lamaSewaCtr = TextEditingController();
  final _tanggalCtr = TextEditingController();

  int _totalBiaya = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _namaPenyewaCtr.text = widget.namaUser; // Otomatis mengisi nama penyewa
  }

  // Fungsi Update Total Harga secara Realtime
  void _hitungTotal() {
    if (_lamaSewaCtr.text.isNotEmpty) {
      int lama = int.tryParse(_lamaSewaCtr.text) ?? 0;
      setState(() {
        _totalBiaya = lama * widget.mobil.harga;
      });
    } else {
      setState(() {
        _totalBiaya = 0;
      });
    }
  }

  // Fungsi Pilih Tanggal
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        // Format tanggal agar mudah dibaca (perlu import 'package:intl/intl.dart')
        _tanggalCtr.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Fungsi Submit Transaksi
  void _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan untuk tanggal
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon pilih tanggal mulai sewa")),
        );
        return;
      }

      // 1. Simpan ke Database
      final db = DBHelper();
      await db.tambahSewa({
        "nama_mobil": widget.mobil.nama,
        "gambar_mobil": widget.mobil.gambar,
        "harga_per_hari": widget.mobil.harga,
        "nama_penyewa": _namaPenyewaCtr.text,
        "lama_sewa": int.parse(_lamaSewaCtr.text),
        "tanggal_mulai": _tanggalCtr.text,
        "total_biaya": _totalBiaya,
        "status": "Aktif"
      });

      if (!mounted) return;

      // 2. Feedback User
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaksi Berhasil Disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      // 3. Navigasi (Sesuai soal: Ganti halaman aktif ke Riwayat/Home)
      // Kita kembali ke HomeScreen dulu (karena biasanya Riwayat ada di menu Home)
      // Atau jika sudah buat halaman RiwayatSewa, arahkan kesana.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(namaUser: _namaPenyewaCtr.text,userId: widget.userId)), // Asumsi kembali ke home
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PENYESUAIAN APPBAR AGAR GRADIENT TERLIHAT ---
      appBar: AppBar(
        title: const Text("Formulir Penyewaan", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), // Judul putih
        backgroundColor: Colors.transparent, // Latar belakang transparan
        elevation: 0, // Tanpa shadow
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)), // Tombol back jadi putih
      ),
      extendBodyBehindAppBar: true, // Membuat body meluas ke belakang appbar
      // --- PENAMBAHAN TEMA GRADIENT PADA BODY ---
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Putih di atas
              Color.fromARGB(255, 12, 12, 12),     // Hitam di bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
          ),
        ),
        // Pastikan kontennya di dalam SafeArea agar tidak tertutup status bar
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. MENAMPILKAN MOBIL YANG DIPILIH ---
                  // Card untuk informasi mobil agar kontras dengan gradient
                  Card(
                    color: Colors.white.withOpacity(0.9), // Putih transparan
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              widget.mobil.gambar,
                              width: 100,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stack) => const Icon(Icons.car_rental, size: 60, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mobil.nama,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Warna teks hitam
                              ),
                              Text(
                                "Rp ${widget.mobil.harga} / hari",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // --- 2. INPUT NAMA PENYEWA ---
                  TextFormField(
                    controller: _namaPenyewaCtr,
                    decoration: const InputDecoration(
                      labelText: "Nama Penyewa",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      filled: true, // Mengisi latar belakang
                      fillColor: Colors.white, // Latar belakang putih
                    ),
                    validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 20),

                  // --- 3. INPUT LAMA SEWA (HARI) ---
                  TextFormField(
                    controller: _lamaSewaCtr,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Lama Sewa (Hari)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer),
                      suffixText: "Hari",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => _hitungTotal(), // Otomatis hitung saat diketik
                    validator: (val) {
                      if (val!.isEmpty) return "Lama sewa wajib diisi";
                      if (int.tryParse(val) == null || int.parse(val) <= 0) {
                        return "Angka harus positif";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // --- 4. INPUT TANGGAL MULAI ---
                  TextFormField(
                    controller: _tanggalCtr,
                    readOnly: true, // Tidak bisa diketik manual
                    onTap: _selectDate, // Muncul kalender saat diklik
                    decoration: const InputDecoration(
                      labelText: "Tanggal Mulai Sewa",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) => val!.isEmpty ? "Tanggal wajib dipilih" : null,
                  ),
                  
                  const SizedBox(height: 30),

                  // --- 5. TAMPILAN TOTAL BIAYA ---
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Latar putih transparan
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300), // Border abu-abu terang
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Biaya:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), // Teks hitam
                        ),
                        Text(
                          "Rp $_totalBiaya",
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.blueAccent // Tetap biru accent untuk penekanan
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- TOMBOL SIMPAN ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Tombol hitam
                        foregroundColor: Colors.white, // Teks putih
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _simpanTransaksi,
                      child: const Text("KONFIRMASI SEWA", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}