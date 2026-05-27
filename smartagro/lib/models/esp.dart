class Esp {
  final int? id;
  final double? latitude;
  final double? longitude;
  final double? temperatura;
  final double? umidade;
  final double? luminosidade;

  Esp({
    this.id,
    this.latitude,
    this.longitude,
    this.temperatura,
    this.umidade,
    this.luminosidade,
  });

  // Converte JSON da API para objeto Dart
  factory Esp.fromJson(Map<String, dynamic> json) {
    return Esp(
      id: json['id'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      temperatura: (json['temperatura'] as num?)?.toDouble(),
      umidade: (json['umidade'] as num?)?.toDouble(),
      luminosidade: (json['luminosidade'] as num?)?.toDouble(),
    );
  }

  // Converte objeto Dart para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'temperatura': temperatura,
      'umidade': umidade,
      'luminosidade': luminosidade,
    };
  }
}