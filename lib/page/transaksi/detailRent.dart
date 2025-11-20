import 'package:flutter/material.dart';
import '../../Db/db_helper.dart';
import 'editRent.dart'; // Pastikan path ini benar

class Detailrent extends StatefulWidget {
  final int sewaId;

  const Detailrent({super.key, required this.sewaId});

  @override
  State<Detailrent> createState() => _DetailrentState();
}

class _DetailrentState extends State<Detailrent> {
  Map<String, dynamic>? _sewaDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSewaDetail();
  }

  Future<void> _loadSewaDetail() async {
    setState(() => _isLoading = true);
    final db = DBHelper();
    final detail = await db.getSewaById(widget.sewaId);
    
    if (!mounted) return;
    setState(() {
      _sewaDetail = detail;
      _isLoading = false;
    });
  }

  Future<void> _batalkanSewa() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin membatalkan penyewaan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Tidak")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Ya", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final db = DBHelper();
      await db.updateSewaStatus(widget.sewaId, "Dibatalkan");
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Status berhasil diubah menjadi Dibatalkan"), backgroundColor: Colors.red),
      );
      _loadSewaDetail(); 
    }
  }

  void _toEditPage() async {
    if (_sewaDetail == null) return;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Editrent(sewaData: _sewaDetail!)),
    );

    if (result == true) {
      _loadSewaDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dibuat transparan agar gradien terlihat menyatu
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Detail Transaksi", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Container(
        // --- MENERAPKAN DESAIN GRADIEN ---
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 12, 12, 12),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
          ),
        ),
        // ---------------------------------
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _sewaDetail == null
                ? const Center(child: Text("Data tidak ditemukan", style: TextStyle(color: Colors.white)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 20), // Tambah padding atas karena AppBar transparan
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Mobil
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              _sewaDetail!['gambar_mobil'] ?? 'assets/images/placeholder.jpg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stack) => Container(
                                height: 200, 
                                width: double.infinity,
                                color: Colors.grey[300], 
                                child: const Icon(Icons.car_rental, size: 80, color: Colors.grey)
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Card Putih untuk membungkus detail agar tulisan terbaca jelas di atas background gelap
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _infoRow("Mobil", _sewaDetail!['nama_mobil'] ?? '-'),
                              _infoRow("Penyewa", _sewaDetail!['nama_penyewa'] ?? '-'),
                              _infoRow("Lama Sewa", "${_sewaDetail!['lama_sewa'] ?? 0} Hari"),
                              _infoRow("Tgl Mulai", _sewaDetail!['tanggal_mulai'] ?? '-'),
                              const Divider(),
                              _infoRow("Total Biaya", "Rp ${_sewaDetail!['total_biaya'] ?? 0}", isBold: true, color: Colors.blue),
                              _infoRow("Status", _sewaDetail!['status'] ?? 'Unknown', isBold: true, color: _getStatusColor(_sewaDetail!['status'] ?? 'Unknown')),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Tombol Aksi
                        if (_sewaDetail!['status'] == 'Aktif') ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text("Edit Pesanan", style: TextStyle(color: Colors.white, fontSize: 16)),
                              onPressed: _toEditPage,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              icon: const Icon(Icons.cancel, color: Colors.white),
                              label: const Text("Batalkan Sewa", style: TextStyle(color: Colors.white, fontSize: 16)),
                              onPressed: _batalkanSewa,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.arrow_back, color: Colors.black87),
                            label: const Text("Kembali", style: TextStyle(color: Colors.black87, fontSize: 16)),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Aktif') return Colors.green;
    if (status == 'Dibatalkan') return Colors.red;
    if (status == 'Selesai') return Colors.blue;
    return Colors.grey;
  }
}