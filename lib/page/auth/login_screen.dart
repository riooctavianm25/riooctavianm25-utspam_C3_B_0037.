import 'package:flutter/material.dart';
import 'package:uts_3012310037/page/auth/register_screen.dart';
import 'package:uts_3012310037/page/home/home_screen.dart';
import 'package:uts_3012310037/Db/db_helper.dart'; // Pastikan import ini benar

class LoginScreen extends StatefulWidget {
  // Kita tidak butuh parameter username/password lagi disini
  // karena kita akan cek langsung ke database.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtr = TextEditingController();
  final _passCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('asset/image/Akira.png'),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // INPUT USERNAME
                        TextFormField(
                          controller: _userCtr,
                          validator: (value) {
                            if (value!.isEmpty) return "Username tidak boleh kosong";
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Username",
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: "Masukkan username anda",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 20),

                        // INPUT PASSWORD
                        TextFormField(
                          controller: _passCtr,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return "Password tidak boleh kosong";
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: "Masukkan password anda",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // TOMBOL LOGIN (BAGIAN YANG DIPERBAIKI)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3A8DFF), Color(0xFF083A9D)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3A8DFF),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async { // Tambahkan async
                                if (_formKey.currentState!.validate()) {
                                  
                                  // 1. Panggil Database Helper
                                  final db = DBHelper();
                                  
                                  // 2. Cek data user di database
                                  var user = await db.login(_userCtr.text, _passCtr.text);

                                  // 3. Cek Hasilnya
                                  if (user != null) {
                                    // JIKA KETEMU (BERHASIL)
                                    if (!mounted) return;
                                    
                                    // Tampilkan pesan sukses sebentar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Login Berhasil!"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );

                                    // Pindah ke Home
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // Kirim nama asli dari database ke HomeScreen
                                        builder: (_) => HomeScreen(namaUser: user['nama'],userId: user['id'],),
                                      ),
                                    );
                                  } else {
                                    // JIKA TIDAK KETEMU (GAGAL)
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Username atau password salah!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Belum punya akun? Daftar di sini",
                            style: TextStyle(
                              color: Color.fromARGB(187, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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