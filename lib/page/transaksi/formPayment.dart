import 'package:flutter/material.dart';

class Formpayment extends StatefulWidget {
  final String totalTagihan;
  final String namaMobil;

  const Formpayment({
    super.key, 
    required this.totalTagihan, 
    required this.namaMobil
  });

  @override
  State<Formpayment> createState() => _FormpaymentState();
}

class _FormpaymentState extends State<Formpayment> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _mobilCtr;
  late TextEditingController _totalCtr;
  final TextEditingController _namaCtr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();

  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _mobilCtr = TextEditingController(text: widget.namaMobil);
    _totalCtr = TextEditingController(text: widget.totalTagihan);
  }

  void _prosesBayar() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text("Pembayaran Berhasil"),
            content: Text("Pembayaran untuk ${widget.namaMobil} sebesar ${widget.totalTagihan} telah diterima."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); 
                  Navigator.of(context).pop(true); 
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _namaCtr.dispose();
    _emailCtr.dispose();
    _totalCtr.dispose();
    _mobilCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Form Pembayaran", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 254, 255),
              Color.fromARGB(255, 45, 40, 90),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Konfirmasi Pembayaran",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                           TextFormField(
                            controller: _mobilCtr,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "Unit Sewa",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.car_rental),
                              filled: true,
                              fillColor: Color(0xFFF0F0F0),
                            ),
                          ),
                          const SizedBox(height: 20),
                           TextFormField(
                            controller: _totalCtr,
                            readOnly: true,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                            decoration: const InputDecoration(
                              labelText: "Total Tagihan",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.monetization_on),
                              filled: true,
                              fillColor: Color(0xFFF0F0F0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _namaCtr,
                            decoration: const InputDecoration(
                              labelText: "Nama Pengirim",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Nama wajib diisi';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailCtr,
                            decoration: const InputDecoration(
                              labelText: "Email Konfirmasi",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Email wajib diisi';
                              if (!value.contains('@gmail.com')) return 'Email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Metode Pembayaran",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.payment),
                            ),
                            items: const [
                              DropdownMenuItem(value: "Transfer", child: Text("Transfer Bank (BCA)")),
                              DropdownMenuItem(value: "E-Wallet", child: Text("E-Wallet (Gopay/OVO)")),
                              DropdownMenuItem(value: "CC", child: Text("Kartu Kredit")),
                            ],
                            onChanged: (val) {},
                            value: "Transfer",
                          ),
                          const SizedBox(height: 30),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 24, 21, 51),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _isLoading ? null : _prosesBayar,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("BAYAR SEKARANG", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
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