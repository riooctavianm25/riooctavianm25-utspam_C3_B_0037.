class Mobil {
  final String nama;
  final String jenis;
  final String gambar;
  final int harga;

  Mobil({
    required this.nama,
    required this.jenis,
    required this.gambar,
    required this.harga,
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "jenis": jenis,
        "gambar": gambar,
        "harga": harga,
      };

  factory Mobil.fromJson(Map<String, dynamic> json) => Mobil(
        nama: json['nama'],
        jenis: json['jenis'],
        gambar: json['gambar'],
        harga: json['harga'],
      );
}
