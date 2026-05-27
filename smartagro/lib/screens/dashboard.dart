import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // IMPORTADO: Pacote de gráficos
import 'package:smartagro/services/api_dados_automatico.dart';
import 'package:smartagro/models/esp.dart';
import 'package:smartagro/controller/nivel_agua.dart';
import 'package:smartagro/screens/calculoVazaoAgua.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final EspService controller = EspService();
  final NivelAguaController controllerAgua = NivelAguaController();

  // Controller do PageView
  final PageController pageController = PageController();

  Esp? esp;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> carregarDados() async {
    try {
      final dados = await controller.carregarDados();

      setState(() {
        esp = dados;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');

      setState(() {
        carregando = false;
      });
    }
  }

  // Navega para a tela de cálculo
  void abrirCalculo() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (esp == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar dados.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        children: [
          // PÁGINA 1 - DASHBOARD
          SafeArea(
            child: Column(
              children: [
                // Header Verde
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7DCC5C),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, Thainara!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sua plantação está saudável.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                // Conteúdo Principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monitoramento em Tempo Real',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Grid de Sensores
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2,
                          children: [
                            _buildInfoCard(
                              'Umidade Solo',
                              '${esp!.umidade ?? 0}%',
                              Icons.water_drop,
                              Colors.blue,
                            ),
                            _buildInfoCard(
                              'Temperatura',
                              '${esp!.temperatura ?? 0}°C',
                              Icons.thermostat,
                              Colors.orange,
                            ),
                            _buildInfoCard(
                              'Luminosidade',
                              '${esp!.luminosidade ?? 0}%',
                              Icons.wb_sunny,
                              Colors.amber,
                            ),
                            _buildInfoCard(
                              'Nível Reserv.',
                              controllerAgua.VerificarNivelAgua(),
                              Icons.waves,
                              Colors.cyan,
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'Desempenho Semanal (Umidade do Solo %)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // IMPLEMENTADO: Card do gráfico Real com fl_chart
                        Container(
                          width: double.infinity,
                          height: 220,
                          padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      const style = TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      );
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text(
                                            'Seg',
                                            style: style,
                                          );
                                        case 1:
                                          return const Text(
                                            'Ter',
                                            style: style,
                                          );
                                        case 2:
                                          return const Text(
                                            'Qua',
                                            style: style,
                                          );
                                        case 3:
                                          return const Text(
                                            'Qui',
                                            style: style,
                                          );
                                        case 4:
                                          return const Text(
                                            'Sex',
                                            style: style,
                                          );
                                        case 5:
                                          return const Text(
                                            'Sáb',
                                            style: style,
                                          );
                                        case 6:
                                          return const Text(
                                            'Dom',
                                            style: style,
                                          );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 20,
                                    reservedSize: 35,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 100,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 65), // Segunda: 65%
                                    const FlSpot(1, 70), // Terça: 70%
                                    const FlSpot(2, 60), // Quarta: 60%
                                    FlSpot(
                                      3,
                                      (esp!.umidade ?? 50).toDouble(),
                                    ), // Quinta (Pega o valor atual do ESP!)
                                    const FlSpot(4, 75), // Sexta: 75%
                                    const FlSpot(5, 80), // Sábado: 80%
                                    const FlSpot(6, 68), // Domingo: 68%
                                  ],
                                  isCurved: true,
                                  color: const Color(
                                    0xFF7DCC5C,
                                  ), // Verde do seu app
                                  barWidth: 4,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: const Color(0xFF7DCC5C).withOpacity(
                                      0.15,
                                    ), // Efeito sombreado abaixo da linha
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Botão para abrir a tela de cálculo
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: abrirCalculo,
                            icon: const Icon(
                              Icons.calculate,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Abrir Cálculo de Consumo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7DCC5C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Center(
                          child: Text(
                            'Você também pode deslizar para a esquerda.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PÁGINA 2 - CÁLCULO DE VAZÃO
          const VazaoAguaPageBody(),
        ],
      ),
    );
  }

  // AJUSTADO: Widget para os cards com correções de overflow interno usando Expanded
  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
