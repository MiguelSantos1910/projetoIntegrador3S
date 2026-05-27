import 'dart:convert';
import 'package:http/http.dart' as http;

class BombaService {
  final String url = 'http://localhost:3000/api/esp';

  Future<void> ligaBombas() async {
    final response = await http.post(
      Uri.parse('$url/ativar-bomba'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'ligarBomba': true,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Falha ao ligar bomba');
    }
  }

  Future<void> desligaBombas() async {
    final response = await http.post(
      Uri.parse('$url/desativar-bomba'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'desligarBomba': true,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Falha ao desligar bomba');
    }
  }
}