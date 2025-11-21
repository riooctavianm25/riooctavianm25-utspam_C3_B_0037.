import 'package:flutter/material.dart';
import 'package:uts_3012310037/Db/model/mobil.dart';
import 'package:uts_3012310037/page/home/car/rentForm_Screen.dart'; 

class DaftarCar extends StatelessWidget {
  final List<Mobil> dummycar = [
Mobil(
    nama: "Rolls-Royce Phantom",
    jenis: "Ultra Luxury Sedan",
    gambar: "asset/image/RollsRoycePhantom.jpg",
    harga: 55000000,
  ),
  Mobil(
    nama: "Rolls-Royce Cullinan",
    jenis: "Luxury SUV",
    gambar: "asset/image/rr_cullinan.jpg",
    harga: 50000000,
  ),
  Mobil(
    nama: "Bentley Continental GT",
    jenis: "Grand Tourer",
    gambar: "asset/image/bentley_gt.jpg",
    harga: 28000000,
  ),
  Mobil(
    nama: "Bentley Bentayga",
    jenis: "Luxury SUV",
    gambar: "asset/image/bentley_bentayga.jpg",
    harga: 27000000,
  ),

  Mobil(
    nama: "Lamborghini Aventador",
    jenis: "Supercar",
    gambar: "asset/image/aventador.jpg",
    harga: 35000000,
  ),
  Mobil(
    nama: "Lamborghini Urus",
    jenis: "Super SUV",
    gambar: "asset/image/urus.jpg",
    harga: 28000000,
  ),
  Mobil(
    nama: "Ferrari 488 GTB",
    jenis: "Supercar",
    gambar: "asset/image/ferrari488.jpg",
    harga: 32000000,
  ),
  Mobil(
    nama: "Ferrari F8 Tributo",
    jenis: "Supercar",
    gambar: "asset/image/ferrari_f8.jpg",
    harga: 34000000,
  ),

  Mobil(
    nama: "McLaren 720S",
    jenis: "Supercar",
    gambar: "asset/image/mclaren720s.jpg",
    harga: 33000000,
  ),
  Mobil(
    nama: "Aston Martin DB11",
    jenis: "Grand Tourer",
    gambar: "asset/image/aston_db11.jpg",
    harga: 30000000,
  ),
  Mobil(
    nama: "Porsche 911 Carrera",
    jenis: "Sports Car",
    gambar: "asset/image/porsche_911.jpg",
    harga: 10000000,
  ),
  Mobil(
    nama: "Audi R8 V10",
    jenis: "Supercar",
    gambar: "asset/image/audi_r8.jpg",
    harga: 13000000,
  ),

  Mobil(
    nama: "Mercedes-Maybach S-Class",
    jenis: "Luxury Sedan",
    gambar: "asset/image/maybach_sclass.jpg",
    harga: 20000000,
  ),
  Mobil(
    nama: "Mercedes-Benz G63 AMG",
    jenis: "Luxury SUV",
    gambar: "asset/image/g63_amg.jpg",
    harga: 18000000,
  ),
  Mobil(
    nama: "Range Rover Autobiography",
    jenis: "Luxury SUV",
    gambar: "asset/image/rangerover_auto.jpg",
    harga: 15000000,
  ),
  Mobil(
    nama: "Lexus LX 600",
    jenis: "Luxury SUV",
    gambar: "asset/image/lexus_lx600.jpg",
    harga: 14000000,
  ),
  Mobil(
    nama: "Cadillac Escalade",
    jenis: "Full-size SUV",
    gambar: "asset/image/escalade.jpg",
    harga: 12000000,
  ),

  Mobil(
    nama: "Lexus LM 350",
    jenis: "Luxury MPV",
    gambar: "asset/image/lexus_lm350.jpg",
    harga: 8000000,
  ),
  Mobil(
    nama: "Porsche Taycan Turbo",
    jenis: "Electric Sport",
    gambar: "asset/image/taycan.jpg",
    harga: 12000000,
  ),
  Mobil(
    nama: "BMW i7",
    jenis: "Electric Luxury Sedan",
    gambar: "asset/image/bmw_i7.jpg",
    harga: 11000000,
  ),
  ];

  final String namaUser;
  final int userId;

  DaftarCar({super.key,required this.namaUser,required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Mobil", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), 
        backgroundColor: Colors.transparent,
        elevation: 0, 
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 1, 1, 1)), 
      ),
      extendBodyBehindAppBar: true,
      body: Container(
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
          child: ListView.builder(
            itemCount: dummycar.length,
            itemBuilder: (context, index) {
              final car = dummycar[index];

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.white.withOpacity(0.9), 
                child: InkWell(
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

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.nama,
                                style: const TextStyle(
                                  fontSize: 17, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
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
                              Navigator.push(
                              context,
                              MaterialPageRoute(
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