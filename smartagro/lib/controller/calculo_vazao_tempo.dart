import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataController {
  String obterDataFormatada() {
    final dataAtual = DateTime.now();
    return DateFormat('dd/MM/yyyy HH:mm').format(dataAtual);
  }
}

class CalculoController {
  // Controllers dos campos de texto
  final TextEditingController vazaoController = TextEditingController();
  final TextEditingController tempoController = TextEditingController();
  final TextEditingController potenciaController = TextEditingController();
  final TextEditingController horasController = TextEditingController();

  // Método que realiza os cálculos e retorna um Map
  Map<String, double> calcular() {
    final double vazao =
        double.tryParse(vazaoController.text.replaceAll(',', '.')) ?? 0;

    final double tempo =
        double.tryParse(tempoController.text.replaceAll(',', '.')) ?? 0;

    final double potencia =
        double.tryParse(potenciaController.text.replaceAll(',', '.')) ?? 0;

    final double horas =
        double.tryParse(horasController.text.replaceAll(',', '.')) ?? 0;

    // Consumo de água
    final double consumoAgua = vazao * tempo;

    // Consumo de energia (kWh)
    final double consumoEnergia = (potencia * horas) / 1000;

    return {
      'consumoAgua': consumoAgua,
      'consumoEnergia': consumoEnergia,
    };
  }

  // Libera os controllers quando não forem mais usados
  void dispose() {
    vazaoController.dispose();
    tempoController.dispose();
    potenciaController.dispose();
    horasController.dispose();
  }
}