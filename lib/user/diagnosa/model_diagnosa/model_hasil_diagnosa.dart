// ignore_for_file: prefer_if_null_operators

class Diagnosa {
  List<String>? kdGejala;
  List<String>? nmGejala;
  String? hasilDiagnosa;
  String? pengendalian;
  String? detailPenyakit;
  List<dynamic>? kemungkinanLain;
  String? gambar;
  Diagnosa({
    this.kdGejala,
    this.nmGejala,
    this.hasilDiagnosa,
    this.pengendalian,
    this.detailPenyakit,
    this.kemungkinanLain,
    this.gambar,
  });
  @override
  String toString() {
    return 'Diagnosa{kdGejala: $kdGejala, nmGejala: $nmGejala, hasilDiagnosa: $hasilDiagnosa, pengendalian: $pengendalian, detailPenyakit: $detailPenyakit, kemungkinanLain: $kemungkinanLain, gambar: $gambar}';
  }

  factory Diagnosa.fromJson(Map<String, dynamic> json) {
    return Diagnosa(
      kdGejala: List<String>.from(json['kdGejala']),
      nmGejala: List<String>.from(json['nmGejala']),
      hasilDiagnosa: json['hasilDiagnosa'],
      pengendalian: json['pengendalian'],
      detailPenyakit: json['detailPenyakit'],
      kemungkinanLain: List<dynamic>.from(json['kemungkinanLain']),
      gambar: json['gambar'],
    );
  }
}
