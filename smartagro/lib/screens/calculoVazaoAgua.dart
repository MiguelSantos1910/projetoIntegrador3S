import 'package:flutter/material.dart';
import 'package:smartagro/controller/calculo_vazao_tempo.dart';
import 'package:smartagro/components/navbar.dart';

class VazaoAguaPageBody extends StatefulWidget {
  const VazaoAguaPageBody({super.key});

  @override
  State<VazaoAguaPageBody> createState() => _VazaoAguaPageBodyState();
}

class _VazaoAguaPageBodyState extends State<VazaoAguaPageBody> {
  final CalculoController controller = CalculoController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void calcularConsumo() {
    final resultado = controller.calcular();

    final double consumoAgua = resultado['consumoAgua'] ?? 0;
    final double consumoEnergia = resultado['consumoEnergia'] ?? 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Resultado do Cálculo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consumo de Água: ${consumoAgua.toStringAsFixed(2)} L'),
            const SizedBox(height: 8),
            Text('Consumo de Energia: ${consumoEnergia.toStringAsFixed(2)} kWh'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE0E0E0),
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const NavBar(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cálculo de Consumo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Informe os dados da irrigação.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONTEÚDO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: controller.vazaoController,
                        label: 'Vazão (L/min)',
                        icon: Icons.water_drop,
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: controller.tempoController,
                        label: 'Tempo de Irrigação (min)',
                        icon: Icons.timer,
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: controller.potenciaController,
                        label: 'Potência da Bomba (W)',
                        icon: Icons.bolt,
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: controller.horasController,
                        label: 'Horas de Uso (h)',
                        icon: Icons.access_time,
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: calcularConsumo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7DCC5C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Calcular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF7DCC5C)),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}