import 'package:flutter/material.dart';
import 'package:smartagro/services/api_dados_automatico.dart'; // Import do seu serviço
import 'package:smartagro/models/esp.dart'; // Import do seu modelo

class AlertasPage extends StatefulWidget {
  const AlertasPage({super.key});

  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  final EspService _espService = EspService();
  late Future<Esp> _dadosFuture;

  @override
  void initState() {
    super.initState();
    _dadosFuture = _espService.carregarDados();
  }

  // Função interna para classificar os dados reais do ESP e fabricar a lista de alertas
  List<Widget> _gerarAlertasManuais(Esp log) {
    List<Widget> listaDeAlertas = [];

    // 1. Regra para Umidade do Solo
    final umidade = log.umidade ?? 0;
    if (umidade < 30) {
      listaDeAlertas.add(
        _buildAlertCard(
          "Crítico: Umidade do Solo",
          "A umidade atual está em $umidade%. Nível muito baixo, acione a irrigação!",
          Icons.warning_amber_rounded,
          Colors.red,
          "Agora",
        ),
      );
    } else if (umidade < 50) {
      listaDeAlertas.add(
        _buildAlertCard(
          "Atenção: Solo Secando",
          "A umidade caiu para $umidade%. Monitore as próximas horas.",
          Icons.info_outline,
          Colors.orange,
          "Pouco tempo atrás",
        ),
      );
    }

    // 2. Regra para Temperatura
    final temp = log.temperatura ?? 0.0;
    if (temp > 35.0) {
      listaDeAlertas.add(
        _buildAlertCard(
          "Crítico: Temperatura Alta",
          "A estufa atingiu ${temp.toStringAsFixed(1)}°C. Perigo de estresse térmico.",
          Icons.thermostat_rounded,
          Colors.red,
          "Agora",
        ),
      );
    } else if (temp > 30.0) {
      listaDeAlertas.add(
        _buildAlertCard(
          "Atenção: Temperatura",
          "Temperatura da estufa atingiu ${temp.toStringAsFixed(1)}°C. Verifique a ventilação.",
          Icons.thermostat,
          Colors.orange,
          "15 min atrás",
        ),
      );
    }

    // 3. Alertas fixos de sistema (caso queira manter exemplos estruturais)
    final luz = log.luminosidade ?? 0;
    if (luz == 0) {
      listaDeAlertas.add(
        _buildAlertCard(
          "Informativo: Modo Noturno",
          "Sensor de luminosidade registrou 0%. Sistema operando em modo de repouso.",
          Icons.nightlight_round,
          Colors.blue,
          "1 hora atrás",
        ),
      );
    }

    // Se tudo estiver perfeito com o sensor e nenhum alerta for gerado pelas regras anteriores
    if (listaDeAlertas.isEmpty) {
      listaDeAlertas.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: const Color(0xFF7DCC5C),
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Nenhum alerta pendente.\nSua plantação está segura!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return listaDeAlertas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0), // Fundo cinza padrão do seu app
      body: Column(
        children: [
          // 1. Header Verde Arredondado
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
                  'Central de Alertas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 2. Renderização assíncrona baseada na sua API Cloud
          Expanded(
            child: FutureBuilder<Esp>(
              future: _dadosFuture,
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
                      'Erro ao buscar alertas em tempo real:\n${snapshot.error}',
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Sem conexão com o sensor IoT.'),
                  );
                }

                final dadosDoSensorReal = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _dadosFuture = _espService.carregarDados();
                    });
                  },
                  color: const Color(0xFF7DCC5C),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: _gerarAlertasManuais(dadosDoSensorReal),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar os cards de alerta sem quebras visuais
  Widget _buildAlertCard(
    String title,
    String message,
    IconData icon,
    Color color,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),

          // Uso correto do Expanded para conter os textos e impedir o Right Overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SOLUÇÃO DO OVERFLOW: O título agora está envelopado por um Expanded interno
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow
                            .ellipsis, // Bota reticências (...) se o título for gigantesco
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
