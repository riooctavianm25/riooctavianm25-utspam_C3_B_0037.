import 'package:flutter/material.dart';

// --- IMPORT HALAMAN TUJUAN ---
// 1. Daftar Mobil (Tambah Sewa)
import 'package:uts_3012310037/page/home/car/carList_screen.dart';
import 'package:uts_3012310037/page/profile.dart';
// 2. Riwayat Sewa (History) - Pastikan path ini sesuai dengan file historyRent.dart Anda
import 'package:uts_3012310037/page/transaksi/historyRent.dart';
// 3. Login (Untuk Logout)
import 'package:uts_3012310037/page/auth/login_screen.dart';
// 4. Profil Pengguna (Sudah di-uncomment, pastikan file ini dibuat di Langkah 2)
// import 'package:uts_3012310037/page/home/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String namaUser;
  final int userId;

  const HomeScreen({super.key, required this.namaUser, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fungsi Logout: Kembali ke Login & Hapus histori navigasi back
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Ya, Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 240, 250),
              Color.fromARGB(255, 20, 20, 40),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                const SizedBox(height: 20),
                Text(
                  "Selamat datang,",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  widget.namaUser,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Selamat datang di Rental Mobil Akira",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 40),
                const Text(
                  "Menu Utama",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // --- MENU NAVIGATION ---

                // 1. TAMBAH SEWA
                _menuTile(
                  icon: Icons.add_circle_outline,
                  title: "Tambah Sewa",
                  subtitle: "Buat penyewaan baru",
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DaftarCar(userId: widget.userId,namaUser: widget.namaUser,)),
                    );
                  },
                ),

                // 2. RIWAYAT SEWA
                _menuTile(
                  icon: Icons.history,
                  title: "Riwayat Sewa",
                  subtitle: "Lihat catatan transaksi",
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      // Perbaikan: Tidak perlu mengirim sewaId saat membuka list
                      MaterialPageRoute(builder: (_) => const Historyrent(sewaId: null)),
                    );
                  },
                ),

                // 3. PROFIL PENGGUNA (Sudah Aktif)
                _menuTile(
                  icon: Icons.person_outline,
                  title: "Profil Pengguna",
                  subtitle: "Lihat detail akun Anda",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: widget.userId),
                      ),
                    );
                  },
                ),

                // 4. KELUAR
                _menuTile(
                  icon: Icons.logout_rounded,
                  title: "Keluar",
                  subtitle: "Kembali ke halaman login",
                  color: Colors.redAccent,
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey.shade400)
              ],
            ),
          ),
        ),
      ),
    );
  }
}