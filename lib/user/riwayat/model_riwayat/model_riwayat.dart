// ignore_for_file: prefer_if_null_operators

class ModelRiwayat {
  List<String>? kodeGejala;
  List<String>? namaGejala;
  String? hasilDiagnosa;
  String? pengendalian;
  String? detailPenyakit;
  List<dynamic>? kemungkinanLain;
  String? gambar;
  ModelRiwayat({
    this.kodeGejala,
    this.namaGejala,
    this.hasilDiagnosa,
    this.pengendalian,
    this.detailPenyakit,
    this.kemungkinanLain,
    this.gambar,
  });
  @override
  String toString() {
    return 'Diagnosa{kdGejala: $kodeGejala, nmGejala: $namaGejala, hasilDiagnosa: $hasilDiagnosa, pengendalian: $pengendalian, detailPenyakit: $detailPenyakit, kemungkinanLain: $kemungkinanLain, gambar: $gambar}';
  }

  factory ModelRiwayat.fromJson(Map<String, dynamic> json) {
    return ModelRiwayat(
      kodeGejala: List<String>.from(json['kodeGejala']),
      namaGejala: List<String>.from(json['namaGejala']),
      hasilDiagnosa: json['hasilDiagnosa'],
      pengendalian: json['pengendalian'],
      detailPenyakit: json['detailPenyakit'],
      kemungkinanLain: List<dynamic>.from(json['kemungkinanLain']),
      gambar: json['gambar'],
    );
  }
}
