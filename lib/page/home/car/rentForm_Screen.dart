import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uts_3012310037/Db/db_helper.dart';
import 'package:uts_3012310037/Db/model/mobil.dart';
import 'package:uts_3012310037/page/home/home_screen.dart';

class FormSewaScreen extends StatefulWidget {
  final Mobil mobil;
  final int userId;
  final String namaUser;

  const FormSewaScreen({
    super.key, 
    required this.mobil, 
    required this.namaUser, 
    required this.userId
  });

  @override
  State<FormSewaScreen> createState() => _FormSewaScreenState();
}

class _FormSewaScreenState extends State<FormSewaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaPenyewaCtr = TextEditingController();
  final _lamaSewaCtr = TextEditingController();
  final _tanggalCtr = TextEditingController();

  int _totalBiaya = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _namaPenyewaCtr.text = widget.namaUser;
  }

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
        _tanggalCtr.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon pilih tanggal mulai sewa")),
        );
        return;
      }

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaksi Berhasil Disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(namaUser: _namaPenyewaCtr.text, userId: widget.userId)),
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Formulir Penyewaan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 24, 21, 51),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
              ),
            ),
          ),

          // 2. Konten Scrollable
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. INFO MOBIL ---
                    Card(
                      color: Colors.white.withOpacity(0.9),
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
                            Expanded( // Tambahkan Expanded agar teks tidak overflow horizontal
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.mobil.nama,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                  Text(
                                    "Rp ${widget.mobil.harga} / hari",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    TextFormField(
                      controller: _namaPenyewaCtr,
                      decoration: const InputDecoration(
                        labelText: "Nama Penyewa",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 20),

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
                      onChanged: (value) => _hitungTotal(),
                      validator: (val) {
                        if (val!.isEmpty) return "Lama sewa wajib diisi";
                        if (int.tryParse(val) == null || int.parse(val) <= 0) {
                          return "Angka harus positif";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _tanggalCtr,
                      readOnly: true,
                      onTap: _selectDate,
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

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Biaya:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            "Rp $_totalBiaya",
                            style: const TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.blueAccent
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
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
        ],
      ),
    );
  }
}