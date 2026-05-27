import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/esp.dart';

class EspService {
  Future<Esp> carregarDados() async {
    final url = Uri.parse(
      'http://localhost:3000/api/esp/ler-dados',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Sua API retorna uma lista de registros.
      final ultimo = data[0];

      final temperatura =
          (ultimo['temperatura'] as num).toDouble();

      final umidade =
          (ultimo['umidade'] as num).toDouble();

      final luminosidade =
          (ultimo['luminosidade'] as num).toDouble();

      return Esp(
        temperatura: temperatura,
        umidade: umidade,
        luminosidade: luminosidade,
      );
    } else {
      throw Exception(
        'Erro ao obter dados: ${response.statusCode}',
      );
    }
  }
}