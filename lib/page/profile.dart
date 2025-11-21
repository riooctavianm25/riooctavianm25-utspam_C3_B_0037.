import 'package:flutter/material.dart';
import 'package:uts_3012310037/Db/db_helper.dart'; // Pastikan import DBHelper benar
import 'package:uts_3012310037/page/auth/login_screen.dart'; // Untuk tombol logout

class ProfileScreen extends StatefulWidget {
  final int userId; 

  // Kita butuh userId untuk mencari data registrasi di database
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _userFuture;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi di Database untuk ambil data user berdasarkan ID
    _userFuture = DBHelper().getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PENYESUAIAN APPBAR AGAR GRADIENT TERLIHAT ---
      appBar: AppBar(
        title: const Text("Profil Saya", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), // Judul putih
        backgroundColor: Colors.transparent, // Latar belakang transparan
        foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Warna ikon kembali/lainnya menjadi putih
        elevation: 0, // Tanpa shadow
      ),
      extendBodyBehindAppBar: true, // Membuat body meluas ke belakang appbar
      // --- PENAMBAHAN TEMA GRADIENT PADA BODY ---
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
        // Pastikan kontennya di dalam SafeArea agar tidak tertutup status bar
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _userFuture,
            builder: (context, snapshot) {
              // 1. Tampilan Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white)); // Loading putih
              }

              // 2. Jika User Tidak Ditemukan
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text("Data user tidak ditemukan", style: TextStyle(color: Colors.white))); // Teks putih
              }

              // 3. Ambil Data dari Snapshot (Data Registrasi)
              final user = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // --- Bagian Foto & Nama ---
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white54, // Avatar putih transparan
                            child: Icon(Icons.person, size: 60, color: Colors.black87), // Ikon hitam
                          ),
                          const SizedBox(height: 15),
                          Text(
                            user['nama'] ?? "Tanpa Nama",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)), // Teks putih
                          ),
                          Text(
                            "@${user['username']}",
                            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)), // Teks abu-abu
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // --- Bagian Detail Data (Card) ---
                    Card(
                      elevation: 4, // Elevation sedikit lebih tinggi
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: Colors.white.withOpacity(0.95), // Card putih transparan
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            _itemProfil(Icons.badge, "NIK", user['nik']),
                            const Divider(),
                            _itemProfil(Icons.email, "Email", user['email']),
                            const Divider(),
                            _itemProfil(Icons.phone, "No. Telepon", user['notelp']),
                            const Divider(),
                            _itemProfil(Icons.location_on, "Alamat", user['alamat']),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- Tombol Logout ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700], // Warna merah yang lebih gelap
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text("Keluar Akun", style: TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                           // Logika Logout
                           Navigator.pushAndRemoveUntil(
                             context,
                             MaterialPageRoute(builder: (_) => const LoginScreen()),
                             (route) => false,
                           );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget kecil biar kodingan rapi
  // Penyesuaian warna agar kontras dengan latar gradient
  Widget _itemProfil(IconData icon, String label, String? value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1), // Tetap ada sentuhan biru muda
          shape: BoxShape.circle
        ),
        child: Icon(icon, color: Colors.blueAccent), // Ikon biru
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)), // Label abu-abu
      subtitle: Text(
        value ?? "-", 
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87) // Nilai hitam
      ),
    );
  }
}