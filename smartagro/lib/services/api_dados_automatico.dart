import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/esp.dart';

class EspService {
  Future<Esp> carregarDados() async {
    final url = Uri.parse('http://localhost:3000/dados-app');
    final response = await http.get(url);

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar os dados. Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> dados =
        jsonDecode(response.body) as Map<String, dynamic>;

    final temperatura =
        (dados['temperature'] as num).toDouble();

    final umidade =
        (dados['humidity'] as num).toDouble();

    final luminosidade =
        (dados['uvIndex'] as num).toDouble();

    return Esp(
      temperatura: temperatura,
      umidade: umidade,
      luminosidade: luminosidade,
    );
  }
}