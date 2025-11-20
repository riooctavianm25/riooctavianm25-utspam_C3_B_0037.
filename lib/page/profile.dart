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
      backgroundColor: Colors.grey[100], // Warna background agak abu biar kontras
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userFuture,
        builder: (context, snapshot) {
          // 1. Tampilan Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Jika User Tidak Ditemukan
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data user tidak ditemukan"));
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
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user['nama'] ?? "Tanpa Nama",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "@${user['username']}",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // --- Bagian Detail Data (Card) ---
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      backgroundColor: Colors.redAccent,
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
    );
  }

  // Widget kecil biar kodingan rapi
  Widget _itemProfil(IconData icon, String label, String? value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle
        ),
        child: Icon(icon, color: Colors.blueAccent),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(
        value ?? "-", 
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)
      ),
    );
  }
}