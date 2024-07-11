class Measure {
  int heartRate;
  int spo2Rate;
  int validHR;
  int validSP02;

  Measure(
      {required this.heartRate,
      required this.spo2Rate,
      required this.validHR,
      required this.validSP02});

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
      heartRate: json['heartRate'],
      spo2Rate: json['spo2Rate'],
      validHR: json['validHR'],
      validSP02: json['validSP02'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'spo2Rate': spo2Rate,
      'validHR': validHR,
      'validSP02': validSP02,
    };
  }
}
