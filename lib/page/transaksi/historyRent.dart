import 'package:flutter/material.dart';
import 'package:uts_3012310037/page/transaksi/formPayment.dart';
import '../../Db/db_helper.dart'; // Pastikan import ini benar
import 'detailRent.dart';

class Historyrent extends StatefulWidget {
  final int? sewaId;

  const Historyrent({super.key, this.sewaId});

  @override
  State<Historyrent> createState() => _HistoryrentState();
}

class _HistoryrentState extends State<Historyrent> {
  List<Map<String, dynamic>> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    final db = DBHelper();
    final data = await db.getAllSewa();
    
    setState(() {
      _riwayat = data;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    if (status == 'Aktif') return Colors.orange;
    if (status == 'Lunas') return Colors.green;
    if (status == 'Selesai') return Colors.green; // Ubah warna Selesai jadi hijau juga
    if (status == 'Dibatalkan') return Colors.red;
    return Colors.grey;
  }

  void _goToPayment(Map<String, dynamic> item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Formpayment(
          totalTagihan: "Rp ${item['total_biaya'] ?? item['total_harga']}", // Sesuaikan field total
          namaMobil: item['nama_mobil'] ?? 'Unknown Car',
        ),
      ),
    );

    if (result == true) {
      final db = DBHelper();
      await db.updateStatusPembayaran(item['id'], 'Selesai');

      await _loadData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status pembayaran diperbarui menjadi Selesai!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Riwayat Penyewaan",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _riwayat.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada riwayat penyewaan.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _riwayat.length,
                itemBuilder: (context, index) {
                  final item = _riwayat[index];
                  final String status = item['status'] ?? 'Unknown';
                  // Tombol Bayar hanya muncul jika status 'Aktif'
                  final bool isPayable = status == 'Aktif'; 

                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Detailrent(sewaId: item['id']),
                          ),
                        );
                        if (result == true) {
                          _loadData();
                        }
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item['gambar_mobil'] ?? 'assets/images/placeholder.jpg',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.car_rental),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nama_mobil'] ?? 'Mobil',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "Penyewa: ${item['nama_penyewa'] ?? '-'}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // Menggunakan total_biaya jika ada, fallback ke total_harga
                                      "Total: Rp ${item['total_biaya'] ?? item['total_harga']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${item['tanggal_mulai'] ?? '-'}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: _getStatusColor(status),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    // Tombol hanya muncul jika status masih Aktif
                                    if (isPayable) ...[
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          minimumSize: const Size(0, 30),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () => _goToPayment(item),
                                        child: const Text(
                                          "Bayar",
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}