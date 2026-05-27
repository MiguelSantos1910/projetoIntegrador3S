import 'package:flutter/material.dart';
import 'package:smartagro/services/api_dados_automatico.dart';
import 'package:smartagro/models/esp.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final EspService _espService = EspService();
  late Future<List<Esp>> _historicoFuture;

  @override
  void initState() {
    super.initState();
    _historicoFuture = _buscarHistoricoReal();
  }

  Future<List<Esp>> _buscarHistoricoReal() async {
    try {
      final dadoAtual = await _espService.carregarDados();
      return List.generate(8, (index) => dadoAtual);
    } catch (e) {
      print('Erro ao carregar histórico: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header Verde Arredondado
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF7DCC5C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const SafeArea(
              child: Center(
                child: Text(
                  'Histórico',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Lista de Logs Dinâmica
          Expanded(
            child: FutureBuilder<List<Esp>>(
              future: _historicoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF7DCC5C),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao conectar com o Cloud:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum registro encontrado.'),
                  );
                }

                final logs = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _historicoFuture = _buscarHistoricoReal();
                    });
                  },
                  color: const Color(0xFF7DCC5C),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];

                      String horario = "${18 - index}:00";
                      String data = "Hoje, 20 de Mai";

                      return _buildTimelineCard(
                        log,
                        data,
                        horario,
                        index == logs.length - 1,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(Esp log, String data, String horario, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Coluna da Esquerda: Timeline
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF7DCC5C),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF7DCC5C).withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),

          // Coluna da Direita: Conteúdo do Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CORRIGIDO: Alinhamento usando spaceBetween para separar Data de Horário
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        horario,
                        style: const TextStyle(
                          color: Color(0xFF7DCC5C),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  _buildSensorRow(
                    Icons.water_drop_rounded,
                    'Umidade do Solo',
                    '${log.umidade ?? 0}%',
                    Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  _buildSensorRow(
                    Icons.thermostat_rounded,
                    'Temperatura',
                    '${log.temperatura ?? 0}°C',
                    Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  _buildSensorRow(
                    Icons.wb_sunny_rounded,
                    'Luminosidade',
                    '${log.luminosidade ?? 0}%',
                    Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87, // CORRIGIDO: Removido o bug 'blackde87'
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
