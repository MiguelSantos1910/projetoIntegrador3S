import 'package:flutter/material.dart';
import '../components/warning_card.dart';
import '../services/api_bomba.dart';

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  final BombaService apiBomba = BombaService();

  // Estados dos atuadores
  bool irrigacao = false;
  bool iluminacao = false;
  bool ventilacao = false;
  bool nutrientes = false;

  // Variáveis para travar o switch enquanto a requisição HTTP acontece
  bool _carregandoIrrigacao = false;
  bool _carregandoIluminacao = false;
  bool _carregandoVentilacao = false;
  bool _carregandoNutrientes = false;

  late Future<void> _buscarEstadoInicialFuture;

  @override
  void initState() {
    super.initState();
    // Busca o estado atual dos relés diretamente do Cloud ao iniciar a tela
    _buscarEstadoInicialFuture = _carregarEstadosDoBack();
  }

  Future<void> _carregarEstadosDoBack() async {
    try {
      // NOTA: Caso seu BombaService retorne um modelo ou Map com o estado de todos os relés,
      // decodifique-o aqui dentro. Exemplo hipotético:
      // final status = await apiBomba.buscarStatusAtuadores();

      setState(() {
        // Exemplo de preenchimento vindo do backend. Ajuste conforme suas propriedades reais:
        irrigacao = false;
        iluminacao = true;
        ventilacao = false;
        nutrientes = false;
      });
    } catch (e) {
      print("Erro ao sincronizar estados iniciais: $e");
    }
  }

  // Função genérica para enviar comandos aos outros atuadores (Iluminação, Ventilação, etc.)
  Future<void> _alternarAtuador({
    required String equipamento,
    required bool novoValor,
    required Function(bool) atualizarEstado,
    required Function(bool) setConversorLoading,
  }) async {
    setConversorLoading(true);
    try {
      // Substitua pelos métodos correspondentes dentro do seu api_bomba.dart
      if (novoValor) {
        // await apiBomba.ligarEquipamento(equipamento);
      } else {
        // await apiBomba.desligarEquipamento(equipamento);
      }

      setState(() {
        atualizarEstado(novoValor);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao comunicar comando para $equipamento: $e"),
        ),
      );
    } finally {
      setConversorLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Column(
        children: [
          // Header Verde Arredondado
          Container(
            width: double.infinity,
            height: 100,
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
                  'Controle de Atuadores',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Renderização do painel de controle pós-sincronização de rede
          Expanded(
            child: FutureBuilder<void>(
              future: _buscarEstadoInicialFuture,
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

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 1. BOMBA DE IRRIGAÇÃO (Controle seguro via WarningCard)
                    _buildControlCard(
                      "Bomba de Irrigação",
                      "Status: ${irrigacao ? 'Ligada' : 'Desligada'}",
                      Icons.water_drop,
                      irrigacao,
                      _carregandoIrrigacao,
                      (val) async {
                        if (val) {
                          final response = await showDialog<bool>(
                            context: context,
                            builder: (_) => WarningCard(apiBomba: apiBomba),
                          );

                          if (response == true) {
                            setState(() => irrigacao = true);
                          }
                        } else {
                          setState(() => _carregandoIrrigacao = true);
                          try {
                            await apiBomba.desligaBombas(); // Chamada HTTP Real
                            setState(() => irrigacao = false);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Falha ao desligar a bomba: $e"),
                              ),
                            );
                          } finally {
                            setState(() => _carregandoIrrigacao = false);
                          }
                        }
                      },
                    ),

                    // 2. ILUMINAÇÃO ESTUFA
                    _buildControlCard(
                      "Iluminação Estufa",
                      "Status: ${iluminacao ? 'Ligada' : 'Desligada'}",
                      Icons.lightbulb,
                      iluminacao,
                      _carregandoIluminacao,
                      (val) async {
                        await _alternarAtuador(
                          equipamento: "iluminacao",
                          novoValor: val,
                          atualizarEstado: (v) => iluminacao = v,
                          setConversorLoading: (l) =>
                              setState(() => _carregandoIluminacao = l),
                        );
                      },
                    ),

                    // 3. VENTILAÇÃO
                    _buildControlCard(
                      "Ventilação",
                      "Status: ${ventilacao ? 'Ligada' : 'Desligada'}",
                      Icons.air,
                      ventilacao,
                      _carregandoVentilacao,
                      (val) async {
                        await _alternarAtuador(
                          equipamento: "ventilacao",
                          novoValor: val,
                          atualizarEstado: (v) => ventilacao = v,
                          setConversorLoading: (l) =>
                              setState(() => _carregandoVentilacao = l),
                        );
                      },
                    ),

                    // 4. DOSADOR DE NUTRIENTES
                    _buildControlCard(
                      "Dosador de Nutrientes",
                      "Status: ${nutrientes ? 'Ligada' : 'Desligada'}",
                      Icons.health_and_safety,
                      nutrientes,
                      _carregandoNutrientes,
                      (val) async {
                        await _alternarAtuador(
                          equipamento: "nutrientes",
                          novoValor: val,
                          atualizarEstado: (v) => nutrientes = v,
                          setConversorLoading: (l) =>
                              setState(() => _carregandoNutrientes = l),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Card modularizado preparado para receber o loadingState da API
  Widget _buildControlCard(
    String title,
    String subtitle,
    IconData icon,
    bool status,
    bool isLoading,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: status
                  ? const Color(0xFF7DCC5C).withOpacity(0.2)
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: status ? const Color(0xFF2E7D32) : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          // Substitui o Switch por um Loading circular se a requisição estiver ativa
          isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF7DCC5C),
                      ),
                    ),
                  ),
                )
              : Switch(
                  value: status,
                  onChanged: (value) => onChanged(value),
                  activeColor: const Color(0xFF7DCC5C),
                  activeTrackColor: const Color(0xFF7DCC5C).withOpacity(0.4),
                ),
        ],
      ),
    );
  }
}
