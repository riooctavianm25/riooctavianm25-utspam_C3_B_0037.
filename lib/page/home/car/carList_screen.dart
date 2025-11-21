// lib/page/carList_screen.dart

import 'package:flutter/material.dart';
import 'package:uts_3012310037/Db/model/mobil.dart';
// Pastikan path ini mengarah ke file rentForm_Screen.dart kamu
import 'package:uts_3012310037/page/home/car/rentForm_Screen.dart'; 

class DaftarCar extends StatelessWidget {
  // List mobil didefinisikan tanpa 'const' agar tidak error
  final List<Mobil> dummycar = [
    Mobil(
        nama: "Toyota Avanza",
        jenis: "MPV",
        gambar: "asset/image/avanza.jpg",
        harga: 250000),
    Mobil(
        nama: "Porsche 911 GT3",
        jenis: "Sport",
        gambar: "asset/image/porsche.jpg",
        harga: 2000000),
    Mobil(
        nama: "Mitsubishi Pajero",
        jenis: "SUV",
        gambar: "asset/image/pajero.jpg",
        harga: 450000),
  ];

  final String namaUser;
  final int userId;

  // Hapus 'const' pada constructor ini juga
  DaftarCar({super.key,required this.namaUser,required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PENYESUAIAN APPBAR AGAR GRADIENT TERLIHAT ---
      appBar: AppBar(
        title: const Text("Pilih Mobil", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), // Judul putih
        backgroundColor: Colors.transparent, // Latar belakang transparan
        elevation: 0, // Tanpa shadow
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 1, 1, 1)), // Tombol back jadi putih
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
          child: ListView.builder(
            itemCount: dummycar.length,
            itemBuilder: (context, index) {
              final car = dummycar[index];

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                // Card perlu warna agar tidak "bolong" dan kontras dengan gradient
                color: Colors.white.withOpacity(0.9), // Sedikit transparan putih
                child: InkWell(
                  // Opsi 1: Klik Card juga bisa pindah (Opsional)
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormSewaScreen(mobil: car,userId: userId,namaUser: namaUser),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Gambar Mobil
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            car.gambar, 
                            width: 90, 
                            height: 70, 
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stack) => const Icon(Icons.car_rental, size: 70, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 15),
                        
                        // Detail Info Mobil
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.nama,
                                style: const TextStyle(
                                  fontSize: 17, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // Ubah warna teks agar terlihat
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${car.jenis} • Rp ${car.harga.toString()}/hari",
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: Colors.grey[700]
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- TOMBOL SEWA ---
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          ),
                          child: const Text("Sewa", style: TextStyle(fontSize: 15)),
                          onPressed: () {
                              // NAVIGASI KE FORM SEWA
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Membuka rentForm_Screen.dart (Class FormSewaScreen)
                                builder: (context) => FormSewaScreen(mobil: car,userId: userId,namaUser: namaUser,),
                              ),
                            );
                          },
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