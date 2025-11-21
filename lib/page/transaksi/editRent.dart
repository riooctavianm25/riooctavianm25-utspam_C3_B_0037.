import 'package:flutter/material.dart';
import '../../Db/db_helper.dart';
import 'package:intl/intl.dart';

class Editrent extends StatefulWidget {
  final Map<String, dynamic> sewaData;

  const Editrent({super.key, required this.sewaData});

  @override
  State<Editrent> createState() => _EditrentState();
}

class _EditrentState extends State<Editrent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaPenyewaCtr;
  late TextEditingController _lamaSewaCtr;
  late TextEditingController _tanggalCtr;

  late int _sewaId;
  late int _hargaPerHari;
  int _totalBiaya = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _sewaId = widget.sewaData['id'];
    _hargaPerHari = widget.sewaData['harga_per_hari'];
    _namaPenyewaCtr = TextEditingController(
      text: widget.sewaData['nama_penyewa'],
    );
    _lamaSewaCtr = TextEditingController(
      text: widget.sewaData['lama_sewa'].toString(),
    );
    _tanggalCtr = TextEditingController(text: widget.sewaData['tanggal_mulai']);

    try {
      _selectedDate = DateFormat(
        'yyyy-MM-dd',
      ).parse(widget.sewaData['tanggal_mulai']);
    } catch (e) {
      _selectedDate = DateTime.now();
    }

    _hitungTotal();
  }

  @override
  void dispose() {
    _namaPenyewaCtr.dispose();
    _lamaSewaCtr.dispose();
    _tanggalCtr.dispose();
    super.dispose();
  }

  void _hitungTotal() {
    if (_lamaSewaCtr.text.isNotEmpty) {
      int lama = int.tryParse(_lamaSewaCtr.text) ?? 0;
      setState(() {
        _totalBiaya = lama * _hargaPerHari;
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalCtr.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _simpanPerubahan() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon pilih tanggal mulai sewa")),
        );
        return;
      }

      final db = DBHelper();
      await db.updateSewa(_sewaId, {
        "nama_penyewa": _namaPenyewaCtr.text,
        "lama_sewa": int.parse(_lamaSewaCtr.text),
        "tanggal_mulai": _tanggalCtr.text,
        "total_biaya": _totalBiaya,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Perubahan berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Edit Pesanan",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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

          SizedBox(
            height: screenHeight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobil: ${widget.sewaData['nama_mobil']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Harga per Hari: Rp $_hargaPerHari",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const Divider(height: 30, thickness: 1.5),

                      TextFormField(
                        controller: _namaPenyewaCtr,
                        decoration: const InputDecoration(
                          labelText: "Nama Penyewa",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (val) =>
                            val!.isEmpty ? "Nama wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

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
                          if (int.tryParse(val) == null ||
                              int.parse(val) <= 0) {
                            return "Angka harus positif";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

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
                        validator: (val) =>
                            val!.isEmpty ? "Tanggal wajib dipilih" : null,
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Biaya:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rp $_totalBiaya",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
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
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _simpanPerubahan,
                          child: const Text(
                            "SIMPAN PERUBAHAN",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
