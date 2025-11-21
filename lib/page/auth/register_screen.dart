import 'package:flutter/material.dart';
import 'package:uts_3012310037/Db/db_helper.dart';
import 'package:uts_3012310037/page/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtr = TextEditingController();
  final _nikCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _notelpCtr = TextEditingController();
  final _alamatCtr = TextEditingController();
  final _userCtr = TextEditingController();
  final _passCtr = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
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
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    "Daftar Akun Akira Rent",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(170, 0, 0, 0),
                    ),
                  ),

                  SizedBox(height: 25),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // NAMA
                        buildField(
                          controller: _namaCtr,
                          label: "Nama",
                          hint: "Masukkan nama anda",
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Nama tidak boleh kosong";
                            if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                              return "Nama hanya boleh huruf";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // NIK
                        buildField(
                          controller: _nikCtr,
                          label: "NIK",
                          keyboard: TextInputType.number,
                          hint: "Masukkan NIK anda",
                          validator: (value) {
                            if (value!.isEmpty) return "NIK tidak boleh kosong";
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return "NIK hanya boleh angka";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // EMAIL
                        buildField(
                          controller: _emailCtr,
                          label: "Email",
                          hint: "Masukkan email anda",
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Email tidak boleh kosong";
                            if (!value.endsWith("@gmail.com")) {
                              return "Email harus @gmail.com";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // NO TELP
                        buildField(
                          controller: _notelpCtr,
                          label: "Nomor Telepon",
                          hint: "Masukkan nomor telepon anda",
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return "Nomor telepon kosong";
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return "Nomor telepon hanya angka";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // ALAMAT
                        buildField(
                          controller: _alamatCtr,
                          label: "Alamat",
                          hint: "Masukkan alamat anda",
                          keyboard: TextInputType.streetAddress,
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Alamat tidak boleh kosong";
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // USERNAME
                        buildField(
                          controller: _userCtr,
                          label: "Username",
                          hint: "Masukkan username anda",
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Username tidak boleh kosong";
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // PASSWORD
                        TextFormField(
                          controller: _passCtr,
                          obscureText: isObscure,
                          validator: (value) {
                            if (value!.isEmpty)
                              return "Password tidak boleh kosong";
                            if (value.length < 8) {
                              return "Password minimal 8 karakter";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: "Masukkan password anda",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() => isObscure = !isObscure);
                              },
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),

                        SizedBox(height: 30),

                        // BUTTON REGISTER
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3A8DFF),
                              shadowColor: Colors.white38,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              // 1. Tambahkan 'async' di sini
                              if (_formKey.currentState!.validate()) {
                                try {
                                  // 2. Panggil DBHelper langsung (tidak perlu onPressed lagi)
                                  final db = DBHelper();

                                  await db.registerUser({
                                    "nama": _namaCtr.text,
                                    "nik": _nikCtr.text,
                                    "email": _emailCtr.text,
                                    "notelp": _notelpCtr.text,
                                    "alamat": _alamatCtr.text,
                                    "username": _userCtr.text,
                                    "password": _passCtr.text,
                                  });

                                  // 3. Tampilkan pesan sukses
                                  if (!mounted)
                                    return; // Cek apakah layar masih aktif sebelum pakai context
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Registrasi berhasil! Silakan login.",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // 4. Pindah ke halaman Login
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  // 5. Tangani jika error (misal username sudah ada)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal daftar: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Sudah punya akun? Login di sini",
                            style: TextStyle(
                              color: Colors.white70,
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

  // REUSABLE FIELD (sama seperti Login)
  Widget buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String?) validator,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) => validator(value),
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
